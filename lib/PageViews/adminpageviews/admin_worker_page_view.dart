import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_human_resource/Components/workers_listview_card_item.dart';
import 'package:new_human_resource/main.dart';
import 'package:new_human_resource/responsive.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

// ignore: must_be_immutable
class AdminWorkerPageView extends StatefulWidget {
  User user;
  late PersistentTabController navBarController;
  AdminWorkerPageView(
      {super.key, required this.user, required this.navBarController});

  @override
  State<AdminWorkerPageView> createState() => _AdminWorkerPageViewState();
}

String searchName = "";

class _AdminWorkerPageViewState extends State<AdminWorkerPageView> {
  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
    return Container(
      color: const Color.fromRGBO(250, 250, 250, 1),
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sizedboxFlexHeight(15),
          SizedBox(
            width: currentWidth * 0.8,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchName = value.toUpperCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
              ),
            ),
          ),
          sizedboxFlexHeight(10),
          StreamBuilder(
            stream: searchName != ""
                ? databaseService.firebaseSearchUser(
                    collection: "users", name: searchName, where: "searchitems")
                : databaseService.firebaseCollectionSnapShot(
                    collection: "users"),
            builder: (context, snapshotStream) {
              if (snapshotStream.connectionState == ConnectionState.active) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshotStream.data!.docs.length,
                    itemBuilder: (context, index) {
                      var currentUser = snapshotStream.data!.docs[index].data();
                      return WorkersListViewItem(
                        currentUser: currentUser,
                        authenticationService: authenticationService,
                        databaseServices: databaseService,
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      )),
    );
  }
}
