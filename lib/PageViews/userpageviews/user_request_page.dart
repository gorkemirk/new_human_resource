import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_human_resource/Components/request_card%20_component.dart';
import 'package:new_human_resource/Pages/user_checking_page.dart';
import 'package:new_human_resource/responsive.dart';
import '../../main.dart';

// ignore: must_be_immutable
class UserRequestPageView extends ConsumerStatefulWidget {
  const UserRequestPageView({
    super.key,
  });

  @override
  ConsumerState<UserRequestPageView> createState() =>
      _UserRequestPageViewState();
}

class _UserRequestPageViewState extends ConsumerState<UserRequestPageView> {
  late Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Scaffold(
        body: SafeArea(
            child: StreamBuilder(
                stream: databaseService.getAllRequests(
                    isAdmin: false,
                    uid: ref.watch(currentUsercheckProvider.state).state!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return Padding(
                      padding: paddingAll(width: 20, height: 20),
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          switch (index % 3) {
                            case 0:
                              color = const Color.fromRGBO(178, 199, 219, 1);
                              break;
                            case 1:
                              color = const Color.fromRGBO(209, 188, 217, 1);
                              break;
                            case 2:
                              color = const Color.fromRGBO(204, 206, 197, 1);
                              break;
                          }
                          return RequestCardComponent(
                            isPending: true,

                            ///7
                            documentID: null,
                            currentRequest: snapshot.data!.docs[index],
                            isAdmin: false,
                            color: color,
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text("Request not found"),
                    );
                  }
                })),
      ),
    );
  }
}
