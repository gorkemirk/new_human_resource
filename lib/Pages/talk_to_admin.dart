import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:new_human_resource/main.dart';
import 'package:new_human_resource/responsive.dart';

import 'user_message_page.dart';

class SelectAdminPage extends StatelessWidget {
  const SelectAdminPage({super.key});

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
            "Select Admin.",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          sizedboxFlexHeight(30),
          Expanded(
            child: StreamBuilder(
                stream: databaseService.getAdmins(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount:
                        snapshot.hasData ? snapshot.data!.docs.length : 0,
                    itemBuilder: (context, index) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text("No found admin."),
                          );
                        } else {
                          String adminName = snapshot.data!.docs[index]["name"];
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
                                        builder: (context) => MessagePage(
                                            curretnAdminDoc:
                                                snapshot.data!.docs[index]),
                                      )),
                                  child: Row(
                                    children: [
                                      Text(adminName),
                                      const Spacer(),
                                      const Text("Send Message"),
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
  }
}
