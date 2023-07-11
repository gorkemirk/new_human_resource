import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:new_human_resource/Components/request_form.dart';
import 'package:new_human_resource/Pages/user_checking_page.dart';
import 'package:new_human_resource/main.dart';
import 'package:new_human_resource/responsive.dart';

// ignore: must_be_immutable
class MyCustomListViewItem extends ConsumerStatefulWidget {
  Map<String, dynamic>? workdate;
  bool userOrAdminLogin;
  MyCustomListViewItem(
      {super.key, required this.workdate, required this.userOrAdminLogin});

  @override
  ConsumerState<MyCustomListViewItem> createState() =>
      _MyCustomListViewItemState();
}

class _MyCustomListViewItemState extends ConsumerState<MyCustomListViewItem> {
  late double currentHeight;

  late double currentWidth;

  late String date, day, month, year;
  late int dayID, yearID, monthID;
  @override
  Widget build(BuildContext context) {
    String entryTime = DateFormat.Hm()
        .format((widget.workdate!["entrytime"] as Timestamp).toDate());
    String exitTime = widget.workdate!["exittime"] != null
        ? DateFormat.Hm()
            .format((widget.workdate!["exittime"] as Timestamp).toDate())
        : "Does not exit.";
    dayID = widget.workdate!["day"];
    yearID = widget.workdate!["year"];
    monthID = widget.workdate!["month"];
    currentHeight = MediaQuery.of(context).size.height;
    currentWidth = MediaQuery.of(context).size.width;
    day = widget.workdate!["day"] < 10
        ? "0${widget.workdate!["day"]}"
        : "${widget.workdate!["day"]}";
    month = widget.workdate!["month"] < 10
        ? "0${widget.workdate!["month"]}"
        : "${widget.workdate!["month"]}";
    year = "${widget.workdate!["year"]}";
    date = "$day/$month/$year";
    double workedtime = (widget.workdate!["workedtime"] as double).toDouble();
    bool workTimeCompleted = (widget.workdate!["workedtimecompleted"] as bool);
    return Card(
      child: ListTile(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(date), //formatDate(date, [yyyy, '-', mm, '-', dd]).toString()
          const Spacer(),
          SizedBox(
            height: 40.h,
            width: 150.w,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: LinearProgressIndicator(
                      minHeight: 40.h,
                      backgroundColor: Colors.grey,
                      value: workedtime * 12.5 / 100,
                      valueColor: workTimeCompleted
                          ? const AlwaysStoppedAnimation<Color>(Colors.green)
                          : const AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      "${workedtime.toStringAsFixed(2)} hour",
                      style: const TextStyle(color: Colors.white),
                    )),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "Work informations to $date",
                                  style: TextStyle(
                                      color: HexColor("4e7596"),
                                      fontSize: 18.h),
                                ),
                                content: Padding(
                                  padding: paddingHorizontal(30),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text("Entry Time"),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Container(
                                              width: 2,
                                              height: 80,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            const Text("Exit Time"),
                                          ],
                                        ),
                                      ),
                                      sizedboxFlexWidth(30),
                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(entryTime),
                                          const SizedBox(
                                            width: 2,
                                            height: 32,
                                          ),
                                          Text("$workedtime hour"),
                                          const SizedBox(
                                            width: 2,
                                            height: 32,
                                          ),
                                          Text(exitTime),
                                        ],
                                      ))
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(
                          Icons.info_outline,
                          color: Colors.yellow,
                        )),
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          widget.userOrAdminLogin == false
              ? StreamBuilder(
                  stream: databaseService.firebaseRequestSnapShot(
                      userid:
                          ref.watch(currentUsercheckProvider.state).state!.uid,
                      documentYearID: yearID,
                      documentMonthID: monthID,
                      documentDayID: dayID),
                  builder: (context, snapshot) {
                    debugPrint(snapshot.hasData.toString());
                    if (snapshot.hasData) {
                      return IconButton(
                          onPressed: () {
                            if (workTimeCompleted == false &&
                                widget.userOrAdminLogin == false &&
                                snapshot.data!.docs.isEmpty) {
                              createRequestBottomSheet(context);
                            }
                          },
                          icon: snapshot.data!.docs.isNotEmpty
                              ? snapshot.data!.docs.first.data()["isRead"]
                                  ? snapshot.data!.docs.first
                                          .data()["isConfirmed"]
                                      ? const Icon(
                                          Icons.check_box,
                                          color: Colors.green,
                                        )
                                      : const Icon(
                                          Icons.report_problem,
                                          color: Colors.red,
                                        )
                                  : const Icon(
                                      Icons.pending_actions,
                                      color: Colors.amber,
                                    )
                              : workTimeCompleted
                                  ? const Icon(
                                      Icons.check_box,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.edit_calendar_outlined,
                                      color: HexColor("4e7596"),
                                    ));
                    } else {
                      return IconButton(
                          onPressed: () {
                            if (workTimeCompleted == false &&
                                widget.userOrAdminLogin == false) {
                              createRequestBottomSheet(context);
                            }
                          },
                          icon: workTimeCompleted
                              ? const Icon(
                                  Icons.check_box,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.edit_calendar_outlined,
                                  color: HexColor("4e7596"),
                                ));
                    }
                  })
              : workTimeCompleted
                  ? const Icon(
                      Icons.check_box,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.report_problem,
                      color: Colors.red,
                    )
        ],
      )),
    );
  }

  Future<dynamic> createRequestBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      constraints: BoxConstraints(
          maxHeight: currentHeight,
          minHeight: currentHeight * 0.9,
          minWidth: currentWidth),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (context) {
        return Padding(
          padding: paddingAll(width: 20, height: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Select a reason for the omission on $date.",
                  style: TextStyle(fontSize: 20.h, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                  /*{formatDate(date, [
                        yyyy,
                        '-',
                        mm,
                        '-',
                        dd
                      ]).toString()}*/
                ),
                RequestRadioButtons(day: dayID, month: monthID, year: yearID)
              ],
            ),
          ),
        );
      },
    );
  }
}
