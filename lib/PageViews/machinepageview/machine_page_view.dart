import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:new_human_resource/Components/update_profile_form.dart';
import 'package:new_human_resource/constants.dart';
import 'package:new_human_resource/main.dart';
import 'package:new_human_resource/responsive.dart';

class MachinePageView extends StatefulWidget {
  const MachinePageView({super.key});

  @override
  State<MachinePageView> createState() => _MachinePageViewState();
}

final _formkey = GlobalKey<FormState>();
TextEditingController _fingerPrintTextController = TextEditingController();
String? currentUserID;
Map<String, Map<String, dynamic>> usersWorkDates = {};
Timer? _timer;

class _MachinePageViewState extends State<MachinePageView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double currenWitdh = MediaQuery.of(context).size.width;
    return Form(
      key: _formkey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: paddingHorizontal(50),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: currenWitdh * 0.5,
                  child: TextFormField(
                    onSaved: (newValue) {},
                    keyboardType: TextInputType.number,
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "Fingerprint ID can't be empty";
                      } else if (value.length < 6) {
                        return "Wrong fingerprint";
                      } else {
                        return null;
                      }
                    }),
                    controller: _fingerPrintTextController,
                    decoration:
                        const InputDecoration(label: Text("Fingerprint ID")),
                  )),
              sizedboxFlexHeight(30),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor("4e7596")),
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      var weekdays = findWeekdays(
                          DateTime.now().year, DateTime.now().month);
                      _formkey.currentState!.save();
                      currentUserID =
                          await databaseService.getIDwithFingerPrint(
                              fingerID: _fingerPrintTextController.text);
                      debugPrint("uid on fingerprint: $currentUserID");
                      debugPrint("çıkış yapmamıs");
                      if (currentUserID != null) {
                        bool isThere = await databaseService.searchWorkDate(
                            year: DateTime.now().year,
                            month: DateTime.now().month,
                            day: DateTime.now().day,
                            uid: currentUserID!);
                        if (isThere) {
                          bool isAlreadyNotExit =
                              await databaseService.getEnxitTimeinWorkDate(
                                  uid: currentUserID!,
                                  day: DateTime.now().day,
                                  month: DateTime.now().month,
                                  year: DateTime.now().year);
                          if (isAlreadyNotExit) {
                            DateTime? entryTime =
                                await databaseService.getEntryTimeinWorkDate(
                                    uid: currentUserID!,
                                    day: DateTime.now().day,
                                    month: DateTime.now().month,
                                    year: DateTime.now().year);
                            debugPrint("$entryTime");
                            if (entryTime != null) {
                              Timestamp exitTimestamp = Timestamp.now();
                              DateTime exitTime = exitTimestamp.toDate();
                              debugPrint("entry:$entryTime exit:$exitTime");
                              Duration diference =
                                  exitTime.difference(entryTime);
                              var differenceHour =
                                  (diference.inHours as double);
                              var differenceMinute =
                                  (((diference.inMinutes % 60) as double) / 10);
                              double differenceTime =
                                  differenceHour + differenceMinute;
                              bool isUpdatedWorkExit =
                                  await databaseService.updateExitWorkTime(
                                      uid: currentUserID!,
                                      exitTime: exitTimestamp,
                                      day: DateTime.now().day,
                                      month: DateTime.now().month,
                                      year: DateTime.now().year,
                                      workedtime: differenceTime <= 0.1
                                          ? 0.1
                                          : differenceTime,
                                      workedtimecompleted:
                                          differenceTime >= 8 ? true : false);

                              isUpdatedWorkExit
                                  // ignore: use_build_context_synchronously
                                  ? scaffoldMessanger(
                                      content: "Exit Aproved",
                                      color: Colors.green,
                                      context: context)
                                  // ignore: use_build_context_synchronously
                                  : scaffoldMessanger(
                                      content: "Exit Failed.",
                                      color: Colors.red,
                                      context: context);
                            } else {
                              // ignore: use_build_context_synchronously
                              scaffoldMessanger(
                                  content: "Try Again.",
                                  color: Colors.red,
                                  context: context);
                            }
                          } else {
                            debugPrint("çıkış yapmıs");
                            // ignore: use_build_context_synchronously
                            scaffoldMessanger(
                                content: "You've already logged out",
                                color: Colors.red,
                                context: context);
                          }
                        } else {
                          if (!weekdays.contains(DateTime.now())) {
                            bool entryApproved =
                                await databaseService.createEntryWorkTime(
                                    entryTime: Timestamp.now(),
                                    day: DateTime.now().day,
                                    month: DateTime.now().month,
                                    year: DateTime.now().year,
                                    uid: currentUserID!);
                            if (entryApproved) {
                              await databaseService
                                  .setIsthereTrue(currentUserID!);
                            }
                            entryApproved
                                // ignore: use_build_context_synchronously
                                ? scaffoldMessanger(
                                    content: "Entry Aproved",
                                    color: Colors.green,
                                    context: context)
                                // ignore: use_build_context_synchronously
                                : scaffoldMessanger(
                                    content: "Entry Failed.",
                                    color: Colors.red,
                                    context: context);
                          } else {
                            // ignore: use_build_context_synchronously
                            scaffoldMessanger(
                                content: "Today is not a work day",
                                color: Colors.red,
                                context: context);
                          }
                        }
                      } else {
                        // ignore: use_build_context_synchronously
                        scaffoldMessanger(
                            content:
                                "Wrong fingerprint or some one went wrong try again.",
                            color: Colors.red,
                            context: context);
                      }
                    } else {
                      scaffoldMessanger(
                          content: "Wrong fingerprint",
                          color: Colors.red,
                          context: context);
                    }
                    _formkey.currentState!.reset();
                    _fingerPrintTextController.clear();
                  },
                  child: SizedBox(
                      width: currenWitdh * 0.44,
                      child: const Text(
                        "Kayıt Ekle",
                        textAlign: TextAlign.center,
                      )))
            ],
          ),
        ),
      ),
    );
  }

  List<DateTime> findWeekdays(int year, int month) {
    List<DateTime> weekdays = [];
    int daysInMonth = DateTime(year, month + 1, 0).day;

    for (int i = 1; i <= daysInMonth; i++) {
      DateTime currentDay = DateTime(year, month, i);
      if (currentDay.weekday >= DateTime.monday &&
          currentDay.weekday <= DateTime.friday) {
        weekdays.add(currentDay);
      }
    }

    return weekdays;
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer t) => _runFunction());
  }

  void _runFunction() async {
    if (DateTime.now().hour == 22 &&
        DateTime.now().minute == 47 &&
        DateTime.now().second == 0) {
      var lostWorkers = await databaseService.getLostWorkers();
      if (lostWorkers.length != 0) {
        for (int i = 0; i < lostWorkers.length; i++) {
          await databaseService.createEntryWorkTime(
              entryTime: Timestamp.now(),
              day: DateTime.now().day,
              month: DateTime.now().month,
              year: DateTime.now().year,
              uid: lostWorkers[i],
              exitTime: Timestamp.now());
        }
        await databaseService.updateIsthereDocumentsFalse();
      }
    }
  }
}
