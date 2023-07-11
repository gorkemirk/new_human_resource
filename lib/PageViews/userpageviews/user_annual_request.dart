import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:new_human_resource/Components/header_profile_infos.dart';
import 'package:new_human_resource/Pages/user_checking_page.dart';
import 'package:new_human_resource/constants.dart';
import 'package:new_human_resource/main.dart';
import 'package:new_human_resource/responsive.dart';

class UserAnnualRequest extends ConsumerStatefulWidget {
  const UserAnnualRequest({super.key});

  @override
  ConsumerState<UserAnnualRequest> createState() => _UserAnnualRequestState();
}

DateTime? startDateTime, finishDateTime;
String startDateText = "Start Day";
String finishDateText = "Finish Day";
String? content;
var reflesh = StateProvider<bool>(
  (ref) => true,
);
late bool isReflesh;
int day = 0;
int? announalDay;

class _UserAnnualRequestState extends ConsumerState<UserAnnualRequest> {
  @override
  Widget build(BuildContext context) {
    isReflesh = ref.watch(reflesh.state).state;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text("Annual leave request",
                style: TextStyle(color: Colors.black)),
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            )),
        body: Padding(
          padding: paddingAll(width: 40, height: 40),
          child: StreamBuilder(
              stream: databaseService.firebaseDocumentSnapShot(
                  document:
                      ref.watch(currentUsercheckProvider.state).state!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  announalDay = snapshot.data!["yillikizin"];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Your Annual day: $announalDay",
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                      ),
                      sizedboxFlexHeight(80),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextField(
                          decoration: const InputDecoration(
                              hintText: "Add request content.."),
                          onChanged: (value) {
                            content = value;
                          },
                        ),
                      ),
                      sizedboxFlexHeight(80),
                      datePicker(
                          context: context,
                          buttonText: "Choose Start Day",
                          isStart: true),
                      sizedboxFlexHeight(60),
                      datePicker(
                          context: context,
                          buttonText: "Choose Finish Day",
                          isStart: false),
                      sizedboxFlexHeight(60),
                      checkDates()
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  startDateText,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Container(
                                  color: Colors.black,
                                  height: 2,
                                  width: 20.w,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  finishDateText,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          : Container(),
                      sizedboxFlexHeight(20),
                      checkDates()
                          ? Text(
                              "$day day",
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                            )
                          : Container(),
                      sizedboxFlexHeight(20),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                            backgroundColor: HexColor("4e7596"),
                            onPressed: () async {
                              debugPrint(content);
                              if (startDateTime == null ||
                                  finishDateTime == null ||
                                  content == null) {
                                scaffoldMessanger(
                                    content:
                                        "Either you chose the wrong dates or you didn't.",
                                    color: Colors.red,
                                    context: context);
                              } else if (((startDateTime!.year ==
                                          finishDateTime!.year) &&
                                      startDateTime!.month >
                                          finishDateTime!.month) ||
                                  ((startDateTime!.month ==
                                          finishDateTime!.month) &&
                                      startDateTime!.day >
                                          finishDateTime!.day)) {
                                scaffoldMessanger(
                                    content:
                                        "Either you chose the wrong dates or you didn't.",
                                    color: Colors.red,
                                    context: context);
                              } else if (finishDateTime!
                                      .difference(startDateTime!)
                                      .inDays >
                                  day) {
                                scaffoldMessanger(
                                    content: "You've exceeded your day off.",
                                    color: Colors.red,
                                    context: context);
                              } else {
                                bool isSending = await databaseService
                                    .addAnnualRequest(
                                        finishDate: finishDateTime!,
                                        startDate: startDateTime!,
                                        howmanyDay: day,
                                        id: ref
                                            .watch(
                                                currentUsercheckProvider.state)
                                            .state!
                                            .uid,
                                        day: DateTime.now().day,
                                        name: ref
                                            .watch(nameProvider!.state)
                                            .state!,
                                        telnumber: ref
                                            .watch(telnumberProvider!.state)
                                            .state!,
                                        month: DateTime.now().month,
                                        year: DateTime.now().year,
                                        content: content);
                                isSending
                                    ? scaffoldMessanger(
                                        content: "Request sent successfully",
                                        color: Colors.green,
                                        context: context)
                                    : scaffoldMessanger(
                                        content: "Request sending failed",
                                        color: Colors.red,
                                        context: context);
                              }
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.send)),
                      )
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }

  Row datePicker(
      {required BuildContext context,
      required String buttonText,
      required bool isStart}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: HexColor("4e7596")),
            onPressed: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day + 3),
                  maxTime: isStart
                      ? DateTime(DateTime.now().year + 1, DateTime.now().month,
                          DateTime.now().day + 3)
                      : startDateTime!.add(Duration(days: announalDay!)),
                  onConfirm: (date) {
                setState(() {
                  if (isStart) {
                    startDateTime = date;
                    startDateText = "${date.year}/${date.month}/${date.day}";
                  } else {
                    finishDateTime = date;
                    finishDateText = "${date.year}/${date.month}/${date.day}";
                    if (checkDates()) {
                      day = (finishDateTime!.day - startDateTime!.day);
                      if (day < 0) {
                        day = (day * (-1)) + 1;
                      } else {
                        day++;
                      }
                    }
                  }

                  ref.read(reflesh.state).state = !isReflesh;
                });
                debugPrint('confirm $date');
              },
                  currentTime: DateTime(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day + 3),
                  locale: LocaleType.tr);
            },
            child: Text(buttonText)),
        sizedboxFlexWidth(20),
        Text(isStart ? startDateText : finishDateText),
      ],
    );
  }

  bool checkDates() {
    if (startDateText != "Start Day" && finishDateText != "Finish Day") {
      return true;
    } else {
      return false;
    }
  }
}
/*DatePickerDialog(
                            initialDate: DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day + 3),
                            firstDate: DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day + 3),
                            lastDate: DateTime(DateTime.now().year + 1, 5, 5));*/