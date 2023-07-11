import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_human_resource/PageViews/userpageviews/user_annual_request.dart';
import 'package:new_human_resource/PageViews/userpageviews/user_worker_detail.dart';
import 'package:new_human_resource/Pages/talk_to_admin.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../AuthService/base_auth_service.dart';
import '../../Components/card_component.dart';
import '../../Components/header_profile_infos.dart';
import '../../FireBaseService/base_database_managment.dart';
import '../../Pages/user_checking_page.dart';
import '../../constants.dart';
import '../../main.dart';
import '../../responsive.dart';

class UserHomePage extends ConsumerStatefulWidget {
  final AuthenticationService authenticationService;
  final DatabaseServices databaseServices;
  User user;
  late PersistentTabController navBarController;
  UserHomePage(
      {super.key,
      required this.navBarController,
      required this.user,
      required this.authenticationService,
      required this.databaseServices});

  @override
  ConsumerState<UserHomePage> createState() => _UserHomePageState();
}

String createUserCardText = "Annual leave request";

String requestsInfoCardText = "Worked Days";

String userName = "Gorkem Irk";
String thirtCardText = "Talk to the admin";

class _UserHomePageState extends ConsumerState<UserHomePage> {
  @override
  Widget build(BuildContext context) {
    double currentDeviceHeightSize = MediaQuery.of(context).size.height;
    return Container(
      color: const Color.fromRGBO(250, 250, 250, 1),
      padding: paddingOnly(left: 30, right: 30, top: 30, bottom: 30),
      height: currentDeviceHeightSize * 0.80.w,
      child: Column(
        children: [
          Expanded(
              flex: 9,
              child: HeaderProfileWidget(
                stream: databaseService.firebaseDocumentSnapShot(
                    document: ref
                        .read(currentUsercheckProvider.state)
                        .state!
                        .uid
                        .toString()),
              )),
          const Spacer(
            flex: 2,
          ),
          Expanded(
            flex: 14,
            child: GestureDetector(
              onTap: (() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserHomePageView(
                          navBarController: widget.navBarController,
                          user: widget.user,
                          authenticationService: widget.authenticationService,
                          databaseServices: widget.databaseServices),
                    ));
              }),
              child: CustomCardWidget(
                color: const Color.fromRGBO(178, 199, 219, 1),
                title: requestsInfoCardText,
                icon: whiteArrow,
                isVertical: false,
              ),
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Expanded(
            flex: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 8,
                  child: GestureDetector(
                    onTap: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserAnnualRequest(),
                          ));
                    }),
                    child: CustomCardWidget(
                      color: const Color.fromRGBO(121, 129, 84, 1),
                      title: createUserCardText,
                      icon: whiteArrow,
                      isVertical: false,
                    ),
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                Expanded(
                  flex: 8,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SelectAdminPage(),
                          ));
                    },
                    child: CustomCardWidget(
                      color: const Color.fromRGBO(229, 208, 237, 1),
                      title: thirtCardText,
                      icon: whiteArrow,
                      isVertical: false,
                    ),
                  ),
                )
              ],
            ),
          ),
          const Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
}
