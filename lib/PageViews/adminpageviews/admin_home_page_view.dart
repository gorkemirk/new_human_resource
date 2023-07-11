import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:new_human_resource/Components/card_component.dart';
import 'package:new_human_resource/Pages/create_user_page.dart';
import 'package:new_human_resource/responsive.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../../Components/create_machine_account_form.dart';
import '../../Components/header_profile_infos.dart';
import '../../Pages/admin_message_chat.dart';
import '../../Pages/user_checking_page.dart';
import '../../constants.dart';
import '../../main.dart';

// ignore: must_be_immutable
class AdminHomePageView extends ConsumerStatefulWidget {
  User user;
  late PersistentTabController navBarController;
  AdminHomePageView(
      {super.key, required this.user, required this.navBarController});

  @override
  ConsumerState<AdminHomePageView> createState() => _AdminHomePageViewState();
}

class _AdminHomePageViewState extends ConsumerState<AdminHomePageView> {
  String createUserCardText = "Create User Account";

  String requestsInfoCardText = "Pending Excuse Requests";
  String requestsAnnualInfoCardText = "Annual Excuse Requests";

  String requestCardCountText = "8";

  String userName = "Gorkem Irk";

  @override
  Widget build(BuildContext context) {
    double currentDeviceHeightSize = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          color: const Color.fromRGBO(250, 250, 250, 1),
          padding: paddingOnly(left: 30, right: 30, top: 30, bottom: 10),
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
                child: Row(
                  children: [
                    StreamBuilder(
                        stream: databaseService.getAllRequests(
                            isAdmin: true, uid: null),
                        builder: (context, snapshot) {
                          return Expanded(
                            flex: 8,
                            child: GestureDetector(
                              onTap: (() {
                                widget.navBarController.index = 2;
                              }),
                              child: CustomCardWidget(
                                color: const Color.fromRGBO(178, 199, 219, 1),
                                title: requestsInfoCardText,
                                icon: whiteArrow,
                                isVertical: true,
                                subtitle: snapshot.hasData
                                    ? snapshot.data!.docs.length.toString()
                                    : "0",
                              ),
                            ),
                          );
                        }),
                    const Spacer(
                      flex: 1,
                    ),
                    StreamBuilder(
                        stream: databaseService.getAllAnonualRequests(
                            isAdmin: true, uid: null),
                        builder: (context, snapshot) {
                          return Expanded(
                            flex: 8,
                            child: GestureDetector(
                              onTap: (() {
                                widget.navBarController.index = 2;
                              }),
                              child: CustomCardWidget(
                                color: const Color.fromRGBO(204, 204, 0, 1),
                                title: requestsAnnualInfoCardText,
                                icon: whiteArrow,
                                isVertical: true,
                                subtitle: snapshot.hasData
                                    ? snapshot.data!.docs.length.toString()
                                    : "0",
                              ),
                            ),
                          );
                        }),
                  ],
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
                                builder: (context) => const CreateUserPage(),
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
                                builder: (context) => const CreateMachineForm(),
                              ));
                        },
                        child: CustomCardWidget(
                          color: const Color.fromRGBO(229, 208, 237, 1),
                          title: "Create Machine Account",
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
        ),
        Align(
            alignment: Alignment.topRight,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminMessagePage(),
                        ));
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        CupertinoIcons.mail,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ))),
      ],
    );
  }
}
