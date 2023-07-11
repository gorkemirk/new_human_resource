import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_human_resource/FireBaseService/base_database_managment.dart';
import 'package:new_human_resource/PageViews/adminpageviews/admin_home_page_view.dart';
import 'package:new_human_resource/Pages/request_tab_bar.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../AuthService/base_auth_service.dart';
import '../PageViews/adminpageviews/admin_profile_page_view.dart';
import '../PageViews/adminpageviews/admin_request_page_view.dart';
import '../PageViews/adminpageviews/admin_worker_page_view.dart';
import '../constants.dart';

// ignore: must_be_immutable
class AdminPage extends StatefulWidget {
  final AuthenticationService authenticationService;
  User user;
  final DatabaseServices databaseService;
  AdminPage(
      {super.key,
      required this.user,
      required this.authenticationService,
      required this.databaseService});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

late PersistentTabController bottomNavBarController;

class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();
    bottomNavBarController = PersistentTabController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        decoration: NavBarDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
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
      AdminHomePageView(
        user: widget.user,
        navBarController: bottomNavBarController,
      ),
      AdminWorkerPageView(
        user: widget.user,
        navBarController: bottomNavBarController,
      ),
      RequestTabBarPage(
        isAdmin: true,
        user: widget.user,
        navBarController: bottomNavBarController,
      ),
      AdminProfilePageView(
        user: widget.user,
        navBarController: bottomNavBarController,
      )
    ];
  }

  List<PersistentBottomNavBarItem> items() {
    return adminNavigationBarItems;
  }
}
