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

class _MachinePageViewState extends State<MachinePageView> {
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
                                  ? scaffoldMessanger(
                                      content: "Exit Aproved",
                                      color: Colors.green,
                                      context: context)
                                  : scaffoldMessanger(
                                      content: "Exit Failed.",
                                      color: Colors.red,
                                      context: context);
                            } else {
                              scaffoldMessanger(
                                  content: "Try Again.",
                                  color: Colors.red,
                                  context: context);
                            }
                          } else {
                            debugPrint("çıkış yapmıs");
                            scaffoldMessanger(
                                content: "You've already logged out",
                                color: Colors.red,
                                context: context);
                          }
                        } else {
                          bool entryApproved =
                              await databaseService.createEntryWorkTime(
                                  entryTime: Timestamp.now(),
                                  day: DateTime.now().day,
                                  month: DateTime.now().month,
                                  year: DateTime.now().year,
                                  uid: currentUserID!);
                          entryApproved
                              ? scaffoldMessanger(
                                  content: "Entry Aproved",
                                  color: Colors.green,
                                  context: context)
                              : scaffoldMessanger(
                                  content: "Entry Failed.",
                                  color: Colors.red,
                                  context: context);
                        }
                      } else {
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
}
