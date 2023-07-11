import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:new_human_resource/Pages/user_checking_page.dart';

import '../main.dart';
import '../responsive.dart';
import 'admin_message_page.dart';

class AdminMessagePage extends ConsumerStatefulWidget {
  const AdminMessagePage({super.key});

  @override
  ConsumerState<AdminMessagePage> createState() => _AdminMessagePageState();
}

class _AdminMessagePageState extends ConsumerState<AdminMessagePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingAll(width: 30, height: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios)),
          sizedboxFlexHeight(30),
          const Text(
            "Select Chat.",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          sizedboxFlexHeight(30),
          Expanded(
            child: StreamBuilder(
                stream: databaseService.getAdminChats(
                    adminID:
                        ref.watch(currentUsercheckProvider.state).state!.uid),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount:
                        snapshot.hasData ? snapshot.data!.docs.length : 0,
                    itemBuilder: (context, index) {
                      if (snapshot.hasData) {
                        debugPrint("hasdata girdi");
                        if (snapshot.data!.docs.isEmpty) {
                          debugPrint("mesaj yoka girdi");
                          return const Center(
                            child: Text("Not found chat."),
                          );
                        } else {
                          String adminName =
                              snapshot.data!.docs[index]["username"];
                          String imageUrl =
                              snapshot.data!.docs[index]["ppimageurl"];
                          return Card(
                            child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    imageBuilder: (context, imageProvider) {
                                      return CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: imageProvider,
                                      );
                                    },
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                title: GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AdminChatMessagePage(
                                                curretnUserDoc:
                                                    snapshot.data!.docs[index]),
                                      )),
                                  child: Row(
                                    children: [
                                      Text(adminName),
                                      const Spacer(),
                                      const Text("Show Chat"),
                                      sizedboxFlexWidth(5),
                                      Icon(
                                        Icons.arrow_circle_right,
                                        color: HexColor("4e7596"),
                                      )
                                    ],
                                  ),
                                )),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                }),
          ),
        ],
      ),
    );
    ;
  }
}
