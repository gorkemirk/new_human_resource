import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:new_human_resource/Components/create_user_form.dart';
import 'package:new_human_resource/PageViews/adminpageviews/admin_request_page_view.dart';
import 'package:new_human_resource/PageViews/adminpageviews/anonual_request.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../PageViews/userpageviews/annual_request_user.dart';
import '../PageViews/userpageviews/user_request_page.dart';

class RequestTabBarPage extends StatefulWidget {
  User user;
  late PersistentTabController navBarController;
  bool isAdmin;
  RequestTabBarPage({
    required this.isAdmin,
    super.key,
    required this.user,
    required this.navBarController,
  });

  @override
  State<RequestTabBarPage> createState() => _RequestTabBarPageState();
}

List<Widget> adminRequestList = [AdminRequestPageView(), AnonualRequests()];
List<Widget> userRequestList = [UserRequestPageView(), AnnualRequestUserPage()];

class _RequestTabBarPageState extends State<RequestTabBarPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: HexColor("4e7596"),
            bottom: const TabBar(tabs: [
              Tab(
                text: "Pendings",
              ),
              Tab(
                text: "Annuals",
              ),
            ]),
            title: const Text("Requests"),
            centerTitle: true,
          ),
          body: widget.isAdmin
              ? TabBarView(children: adminRequestList)
              : TabBarView(children: userRequestList),
        ));
  }
}
