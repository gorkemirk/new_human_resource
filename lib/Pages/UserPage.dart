// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:new_human_resource/Pages/request_tab_bar.dart';
import 'package:new_human_resource/main.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../AuthService/base_auth_service.dart';
import '../FireBaseService/base_database_managment.dart';
import '../PageViews/userpageviews/user_worker_detail.dart';
import '../PageViews/userpageviews/user_homepage.dart';
import '../PageViews/userpageviews/user_profile_page.dart';
import '../PageViews/userpageviews/user_request_page.dart';
import '../constants.dart';

// ignore: must_be_immutable
class UserPage extends StatefulWidget {
  final AuthenticationService authenticationService;
  User user;
  final DatabaseServices databaseService;
  UserPage(
      {super.key,
      required this.authenticationService,
      required this.databaseService,
      required this.user});

  @override
  State<UserPage> createState() => _UserPageState();
}

late PersistentTabController bottomNavBarController;

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
    bottomNavBarController = PersistentTabController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        navBarHeight: MediaQuery.of(context).size.height * 0.09,
        controller: bottomNavBarController,
        context,
        screens: screens(),
        items: items(),
        navBarStyle: NavBarStyle.style10,
      ),
    );
  }

  List<Widget> screens() {
    return [
      UserHomePage(
          databaseServices: databaseService,
          user: widget.user,
          navBarController: bottomNavBarController,
          authenticationService: widget.authenticationService),
      RequestTabBarPage(
          isAdmin: false,
          user: widget.user,
          navBarController: bottomNavBarController),
      UserProfilePageView(
          user: widget.user,
          navBarController: bottomNavBarController,
          authenticationService: widget.authenticationService)
    ];
  }

  List<PersistentBottomNavBarItem> items() {
    return userNavigationBarItems;
  }
}
