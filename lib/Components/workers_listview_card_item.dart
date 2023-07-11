import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../AuthService/base_auth_service.dart';
import '../FireBaseService/base_database_managment.dart';
import '../Pages/worker_detail_page.dart';

// ignore: must_be_immutable
class WorkersListViewItem extends StatefulWidget {
  final AuthenticationService authenticationService;
  User? user;
  final DatabaseServices databaseServices;
  Map<String, dynamic> currentUser;
  WorkersListViewItem(
      {super.key,
      required this.currentUser,
      this.user,
      required this.authenticationService,
      required this.databaseServices});

  @override
  State<WorkersListViewItem> createState() => _WorkersListViewItemState();
}

class _WorkersListViewItemState extends State<WorkersListViewItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: CachedNetworkImage(
            imageUrl: widget.currentUser["ppimageurl"],
            imageBuilder: (context, imageProvider) {
              return CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: imageProvider,
              );
            },
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.currentUser["name"],
              style: TextStyle(color: HexColor("4e7596")),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => WorkerDetailPage(
                            userOrAdminLogin: true,
                            selectedUser: widget.currentUser),
                      ));
                },
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: HexColor("4e7596"),
                ))
          ],
        ),
        subtitle: Text("ID: ${widget.currentUser["id"]}"),
      ),
    );
  }
}
