import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_human_resource/PageViews/worker_detail_page_view.dart';
import 'package:new_human_resource/responsive.dart';
import '../Components/dropDownMenu.dart';

// ignore: must_be_immutable
class WorkerDetailPage extends ConsumerStatefulWidget {
  Map<String, dynamic>? selectedUser;
  bool userOrAdminLogin;
  WorkerDetailPage(
      {super.key,
      User? user,
      this.selectedUser,
      required this.userOrAdminLogin});

  @override
  ConsumerState<WorkerDetailPage> createState() => _WorkerDetailPageState();
}

class _WorkerDetailPageState extends ConsumerState<WorkerDetailPage> {
  User? user;

  @override
  Widget build(BuildContext context) {
    String workerName = widget.selectedUser != null
        ? (widget.selectedUser!["name"] as String)
        : "null";
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            Visibility(
                visible: false, //widget.userOrAdminLogin,
                child: PopupMenuButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                          onTap: () {
                            // deleteuser
                          },
                          child: Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.black,
                                size: 24.h,
                              ),
                              sizedboxFlexWidth(10),
                              Text(
                                "Delete the User",
                                style: TextStyle(fontSize: 15.h),
                              )
                            ],
                          ))
                    ];
                  },
                ))
          ],
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: const Text(
            "Worker Details",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(children: [
          Padding(
            padding: paddingHorizontal(10),
            child: Row(
              children: [
                Text(workerName),
                const Spacer(),
                const dropDownMenu()
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: WorkerDetailPageView(
                userOrAdminLogin: widget.userOrAdminLogin,
                selectedUser: widget.selectedUser),
          ),
        ]),
      ),
    );
  }
}
