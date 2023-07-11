import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:new_human_resource/Components/header_profile_infos.dart';
import 'package:new_human_resource/Pages/user_checking_page.dart';
import 'package:new_human_resource/constants.dart';
import 'package:new_human_resource/main.dart';

import '../responsive.dart';

class MessagePage extends ConsumerStatefulWidget {
  QueryDocumentSnapshot<Map<String, dynamic>> curretnAdminDoc;
  MessagePage({super.key, required this.curretnAdminDoc});

  @override
  ConsumerState<MessagePage> createState() => _MessagePageState();
}

Color? color;
String? messageboxText;
late TextEditingController _messageTextController;

class _MessagePageState extends ConsumerState<MessagePage> {
  @override
  void initState() {
    _messageTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> currentAdmin = widget.curretnAdminDoc.data();
    String imageUrl = currentAdmin["ppimageurl"];
    String adminName = currentAdmin["name"];
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          Card(
            child: ListTile(
                leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back)),
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        imageBuilder: (context, imageProvider) {
                          return CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: imageProvider,
                          );
                        },
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    sizedboxFlexWidth(16),
                    Text(adminName),
                  ],
                )),
          ),
          StreamBuilder(
              stream: databaseService.getMessages(
                  adminID: currentAdmin["id"],
                  userID: ref.watch(currentUsercheckProvider.state).state!.uid),
              builder: (context, snapshot) {
                return Expanded(
                    child: Padding(
                  padding: paddingAll(width: 15, height: 20),
                  child: ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount:
                        snapshot.hasData ? snapshot.data!.docs.length : 0,
                    itemBuilder: (context, index) {
                      if (snapshot.hasData) {
                        String currentMessage =
                            snapshot.data!.docs[index]["message"];
                        bool senderIsAdmin = snapshot.data!.docs[index]
                                    ["senderID"] ==
                                currentAdmin["id"]
                            ? true
                            : false;
                        color = senderIsAdmin ? Colors.purple : Colors.amber;
                        return Column(
                          crossAxisAlignment: senderIsAdmin
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                child: Text(
                                  currentMessage,
                                  style: TextStyle(
                                      fontSize: 20.h,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            sizedboxFlexHeight(15)
                          ],
                        );
                      } else {
                        return const Center(
                          child: Text("No message."),
                        );
                      }
                    },
                  ),
                ));
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextField(
                  controller: _messageTextController,
                  onChanged: (value) {
                    messageboxText = value;
                  },
                  decoration: InputDecoration(
                    hintText: "Message",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
              ),
              FloatingActionButton(
                  backgroundColor: HexColor("4e7596"),
                  onPressed: () {
                    if (messageboxText != null) {
                      databaseService.sendMessage(
                          isAdmin: false,
                          username: ref.watch(nameProvider!.state).state!,
                          ppimageurl: ref.watch(ppimageProvider!.state).state!,
                          senderID: ref
                              .watch(currentUsercheckProvider.state)
                              .state!
                              .uid,
                          createdAt: Timestamp.now(),
                          message: messageboxText!,
                          adminID: currentAdmin["id"],
                          userID: ref
                              .watch(currentUsercheckProvider.state)
                              .state!
                              .uid);
                      messageboxText = null;
                      _messageTextController.clear();
                    } else {
                      scaffoldMessanger(
                          content: "enter the message",
                          color: Colors.yellow,
                          context: context);
                    }
                  },
                  child: const Icon(
                    Icons.send,
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
