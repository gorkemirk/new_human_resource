import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_human_resource/FireBaseService/base_database_managment.dart';
import 'package:new_human_resource/Pages/worker_detail_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../AuthService/base_auth_service.dart';

// ignore: must_be_immutable
class UserHomePageView extends StatefulWidget {
  final AuthenticationService authenticationService;
  final DatabaseServices databaseServices;
  User user;
  late PersistentTabController navBarController;
  UserHomePageView(
      {super.key,
      required this.navBarController,
      required this.user,
      required this.authenticationService,
      required this.databaseServices});

  @override
  State<UserHomePageView> createState() => _UserHomePageViewState();
}

late StateProvider<String?> username;
late StateProvider<String?> phonenumber;

class _UserHomePageViewState extends State<UserHomePageView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.databaseServices
          .firebaseDocumentSnapShot(document: widget.user.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var currentUser = snapshot.data!.data();
          username = StateProvider<String?>(
            (ref) => snapshot.data!.data()!["name"],
          );
          phonenumber = StateProvider<String?>(
            (ref) => snapshot.data!.data()!["telnumber"],
          );
          return WorkerDetailPage(
            userOrAdminLogin: false,
            user: widget.user,
            selectedUser: currentUser,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
