import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:new_human_resource/Components/add_file_card.dart';
import 'package:new_human_resource/PageViews/userpageviews/user_worker_detail.dart';
import 'package:new_human_resource/Pages/user_checking_page.dart';
import 'package:new_human_resource/constants.dart';
import 'package:new_human_resource/main.dart';
import 'package:new_human_resource/responsive.dart';

// ignore: must_be_immutable
class RequestRadioButtons extends ConsumerStatefulWidget {
  int year, month, day;
  RequestRadioButtons(
      {super.key, required this.year, required this.month, required this.day});

  @override
  ConsumerState<RequestRadioButtons> createState() =>
      _RequestRadioButtonsState();
}

String? otherTextField;
String? groupValue;
int? groupValue1;

late bool urlLoad;

class _RequestRadioButtonsState extends ConsumerState<RequestRadioButtons> {
  @override
  void initState() {
    super.initState();
    otherTextField = "";
    urlLoad = false;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.h,
      children: [
        RadioListTile(
          title: const Text(
            "I'm sick.",
          ),
          value: "I'm sick.",
          groupValue: groupValue,
          onChanged: (value) => setState(() {
            groupValue = value!;
          }),
        ),
        RadioListTile(
          title: const Text(
            "I had/have some personel problems.",
          ),
          value: "I had/have some personel problems.",
          groupValue: groupValue,
          onChanged: (value) {
            setState(() {
              groupValue = value!;
            });
          },
        ),
        RadioListTile(
          title: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextField(
              onTap: () {
                setState(() {
                  groupValue = otherTextField;
                });
              },
              decoration: const InputDecoration(hintText: "other"),
              onChanged: (value) {
                setState(() {
                  otherTextField = value;
                  groupValue = otherTextField;
                });
              },
            ),
          ),
          value: otherTextField,
          groupValue: groupValue,
          onChanged: (value) {
            setState(() {
              groupValue = otherTextField;
            });
          },
        ),
        sizedboxFlexHeight(20),
        Text(
          "You may send a request to cover your incomplete hour.",
          style: TextStyle(fontSize: 20.h, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
        sizedboxFlexHeight(30),
        RadioListTile(
          title: const Text("Sampaş should change my incomplete hours status."),
          value: 0,
          groupValue: groupValue1,
          onChanged: (value) {
            setState(() {
              groupValue1 = value;
            });
          },
        ),
        RadioListTile(
          title: const Text("I wanna use my day off."),
          value: 1,
          groupValue: groupValue1,
          onChanged: (value) {
            setState(() {
              groupValue1 = value;
            });
          },
        ),
        const fileCard(),
        sizedboxFlexHeight(30),
        Padding(
          padding: paddingHorizontal(36),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(excuseFileUrl.state).state = null;
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor("4e7596"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24))),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Cancel",
                    ),
                  ),
                ),
              ),
              const Spacer(
                flex: 2,
              ),
              Expanded(
                flex: 4,
                child: ElevatedButton(
                  onPressed: () async {
                    Future.delayed(const Duration(seconds: 2))
                        .whenComplete(() async {
                      if (groupValue != null && groupValue1 != null) {
                        bool isCreatedRequest;
                        isCreatedRequest = await databaseService.createRequest(
                            solution: groupValue1!,
                            fileUrl: ref.watch(excuseFileUrl.state).state,
                            phone: ref.watch(phonenumber.state).state,
                            name: ref.watch(username.state).state,
                            uid: ref
                                .watch(currentUsercheckProvider.state)
                                .state!
                                .uid,
                            content: groupValue!,
                            createdAt: Timestamp.now(),
                            year: widget.year,
                            month: widget.month,
                            day: widget.day);
                        if (isCreatedRequest) {
                          scaffoldMessanger(
                              context: context,
                              content: "Request send successful.",
                              color: Colors.green);
                        } else {
                          scaffoldMessanger(
                              context: context,
                              content: "The request could not be sent.",
                              color: Colors.red);
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      } else {
                        scaffoldMessanger(
                            content:
                                "Please select content or select cover method.",
                            color: Colors.yellow,
                            context: context);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor("4e7596"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24))),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Send",
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
