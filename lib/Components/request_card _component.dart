import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:new_human_resource/constants.dart';
import 'package:new_human_resource/main.dart';
import 'package:new_human_resource/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class RequestCardComponent extends StatelessWidget {
  QueryDocumentSnapshot<Map<String, dynamic>> currentRequest;
  Color color;
  bool isPending;
  bool isAdmin;
  String? documentID;
  RequestCardComponent(
      {super.key,
      required this.isPending,
      this.color = Colors.white,
      required this.isAdmin,
      required this.currentRequest,
      required this.documentID});
  @override
  Widget build(BuildContext context) {
    var currentItem = currentRequest.data();
    DateTime? startDate =
        isPending ? null : (currentItem["startdate"] as Timestamp).toDate();
    DateTime? finishDate =
        isPending ? null : (currentItem["finishdate"] as Timestamp).toDate();
    int? howManyDay = isPending ? null : currentItem["howmanyday"];
    int? solutionChoose = isPending ? currentItem["solution"] : null; //
    String? solution = isPending
        ? solutionChoose == 0 //
            ? "Sampaş should change my incomplete hours status."
            : "I wanna use my day off."
        : null;
    bool isShowFile;
    String? phoneNumber = currentItem["phone"];
    String? fileUrl = isPending ? currentItem["fileUrl"] : null; //
    String content = currentItem["content"];
    String uid = currentItem["uid"];
    String name = currentItem["name"];
    DateTime createdAt = (currentItem["createdAt"] as Timestamp).toDate();
    String requestStatus = currentItem["isRead"] == false
        ? "Waiting for response"
        : currentItem["isConfirmed"]
            ? "Approved"
            : "Denied";
    int requestDay = currentItem["day"];
    int requestMonth = currentItem["month"];
    int requestYear = currentItem["year"];
    String workedDate =
        "$requestYear/${requestMonth < 10 ? "0$requestMonth" : "$requestMonth"}/${requestDay < 10 ? "0$requestDay" : "$requestDay"}";
    double currentHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: paddingOnly(bottom: 5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: color,
        child: Padding(
          padding: paddingOnly(top: 20, bottom: 8, left: 20, right: 20),
          child: SizedBox(
            height: currentHeight * 0.35,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Created At: ${formatDate(createdAt, [
                            yyyy,
                            '/',
                            mm,
                            '/',
                            dd
                          ])}",
                      style: GoogleFonts.aBeeZee(
                          fontSize: 15.h, color: Colors.white),
                    ),
                    const Spacer(),
                    Visibility(
                      visible: (!isAdmin && currentItem["isRead"] == false),
                      child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel")),
                                      ElevatedButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            if (currentItem["isRead"] ==
                                                false) {
                                              bool isDeleted = isPending
                                                  ? await databaseService
                                                      .currentRequestDelete(
                                                          requestID:
                                                              currentRequest.id)
                                                  : await databaseService
                                                      .currentAnnualRequestDelete(
                                                          requestID:
                                                              currentRequest
                                                                  .id);
                                              isDeleted
                                                  ? scaffoldMessanger(
                                                      content:
                                                          "Request deleted.",
                                                      color: Colors.green,
                                                      context: context)
                                                  : scaffoldMessanger(
                                                      content:
                                                          "Request not deleted try again.",
                                                      color: Colors.red,
                                                      context: context);
                                            } else {
                                              Navigator.pop(context);
                                              scaffoldMessanger(
                                                  content:
                                                      "Some one went wrong.",
                                                  color: Colors.yellow,
                                                  context: context);
                                            }
                                          },
                                          child: const Text("Delete"))
                                    ],
                                  ),
                                  title: const Text(
                                      "Do you want delete the request?"),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 1,
                  height: 0,
                ),
                Text("ID: $uid",
                    style: GoogleFonts.aBeeZee(
                      fontSize: 17.h,
                      color: Colors.white,
                    )),
                Text("Name: $name",
                    style: GoogleFonts.aBeeZee(
                      fontSize: 17.h,
                      color: Colors.white,
                    )),
                Text("Phone: $phoneNumber",
                    style: GoogleFonts.aBeeZee(
                      fontSize: 17.h,
                      color: Colors.white,
                    )),
                Text(
                  "Excuse content: $content",
                  style: GoogleFonts.aBeeZee(
                    fontSize: 17.h,
                    color: Colors.white,
                  ),
                ),
                isPending
                    ? Text(
                        "Excuse solution: $solution",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 17.h,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        "Dates: ${DateFormat('yyyy-MM-dd').format(startDate!)} - ${DateFormat('yyyy-MM-dd').format(finishDate!)}",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 17.h,
                          color: Colors.white,
                        ),
                      ),
                isPending
                    ? Text(
                        "Excuse day: $workedDate",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 17.h,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        "Day: $howManyDay",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 17.h,
                          color: Colors.white,
                        ),
                      ),
                Text("Status: $requestStatus",
                    style: GoogleFonts.aBeeZee(
                      fontSize: 17.h,
                      color: Colors.white,
                    )),
                isPending
                    ? fileUrl != null
                        ? Padding(
                            padding: paddingOnly(bottom: 10, top: 5),
                            child: GestureDetector(
                              onTap: () async {
                                isShowFile = await launchFileUrl(url: fileUrl);
                                if (isShowFile == false) {
                                  scaffoldMessanger(
                                      content: "File not viewed.",
                                      color: Colors.red,
                                      context: context);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.explore),
                                      sizedboxFlexWidth(8),
                                      const Text("Show excuse file")
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container()
                    : Container(),
                isAdmin
                    ? Row(
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                isPending
                                    ? await databaseService
                                        .updateRequestisReadAndisConfirmed(
                                            isRead: true,
                                            documentID: documentID!,
                                            isConfirmed: false)
                                    : await databaseService
                                        .updateRequestisReadAndisConfirmedAnnual(
                                            isRead: true,
                                            documentID: documentID!,
                                            isConfirmed: false);
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              child: Text("Decline",
                                  style: GoogleFonts.aBeeZee(
                                    color:
                                        const Color.fromARGB(255, 90, 89, 89),
                                  ))),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () async {
                              late bool isConfirmed;
                              if (isPending) {
                                isConfirmed = solutionChoose == 0
                                    ? await databaseService
                                        .updateRequestisReadAndisConfirmed(
                                            isRead: true,
                                            documentID: documentID!,
                                            isConfirmed: true)
                                        .whenComplete(() async {
                                        await databaseService.updateWorkDate(
                                            userid: uid,
                                            documentYearID: requestYear,
                                            documentMonthID: requestMonth,
                                            documentDayID: requestDay,
                                            mapName: "workedtimecompleted",
                                            value: true);
                                      })
                                    : await databaseService
                                        .updateRequestisReadAndisConfirmed(
                                            isRead: true,
                                            documentID: documentID!,
                                            isConfirmed: true)
                                        .whenComplete(
                                        () async {
                                          await databaseService
                                              .updateYillikIzin(id: uid, day: 1)
                                              .whenComplete(
                                            () async {
                                              await databaseService
                                                  .updateWorkDate(
                                                      userid: uid,
                                                      documentYearID:
                                                          requestYear,
                                                      documentMonthID:
                                                          requestMonth,
                                                      documentDayID: requestDay,
                                                      mapName:
                                                          "workedtimecompleted",
                                                      value: true);
                                            },
                                          );
                                        },
                                      );
                              } else {
                                isConfirmed = await databaseService
                                    .updateRequestisReadAndisConfirmedAnnual(
                                        isRead: true,
                                        documentID: documentID!,
                                        isConfirmed: true)
                                    .whenComplete(
                                  () async {
                                    await databaseService.updateYillikIzin(
                                        id: uid, day: howManyDay!);
                                  },
                                );
                              }
                              isConfirmed
                                  ? scaffoldMessanger(
                                      content: "Process completed.",
                                      color: Colors.green,
                                      context: context)
                                  : scaffoldMessanger(
                                      content:
                                          "The operation could not be completed.",
                                      color: Colors.red,
                                      context: context);
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            child: Text(
                              "Confirm",
                              style: GoogleFonts.aBeeZee(
                                color: const Color.fromARGB(255, 90, 89, 89),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> launchFileUrl({required String url}) async {
    Uri fileUrl = Uri.parse(url);
    if (!await launchUrl(
      fileUrl,
      mode: LaunchMode.externalApplication,
    )) {
      return false;
    } else {
      return true;
    }
  }
}
