import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_human_resource/Pages/machine_page.dart';
import '../AuthService/base_auth_service.dart';
import '../FireBaseService/base_database_managment.dart';
import '../PageViews/login_page_view.dart';
import 'AdminPage.dart';
import 'UserPage.dart';

class LandingPage extends ConsumerStatefulWidget {
  final AuthenticationService authenticationService;
  final DatabaseServices databaseService;
  const LandingPage(
      {required this.databaseService,
      Key? key,
      required this.authenticationService})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LandingPageState();
}

late final StateProvider<User?> currentUsercheckProvider;

class _LandingPageState extends ConsumerState<LandingPage> {
  @override
  void initState() {
    super.initState();
    currentUsercheckProvider = StateProvider<User?>(
      (ref) => _checkUser(),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = ref.watch(currentUsercheckProvider.state).state;
    debugPrint("User:${user?.uid}");
    if (user == null) {
      return LoginPage(authenticationService: widget.authenticationService);
    } else {
      return FutureBuilder(
          future: widget.databaseService.getUserisAdmin(id: user.uid),
          builder: (context, snapshot) {
            debugPrint(
                "SnapShot Data: ${snapshot.data} snapshothasdata: ${snapshot.hasData}");
            if (snapshot.hasData) {
              if (snapshot.data == 0) {
                return AdminPage(
                  databaseService: widget.databaseService,
                  user: user,
                  authenticationService: widget.authenticationService,
                );
              } else if (snapshot.data == 1) {
                return UserPage(
                  databaseService: widget.databaseService,
                  user: user,
                  authenticationService: widget.authenticationService,
                );
              } else if (snapshot.data == 2) {
                return const MachinePage();
              } else {
                return Container(
                  color: Colors.white,
                  child: const Center(child: Text("Admin bilgisi alınamadı.")),
                );
              }
            } else {
              return Container(
                color: Colors.white,
                child: const Center(child: CircularProgressIndicator()),
              );
            }
          });
    }
  }

  User? _checkUser() {
    // ignore: await_only_futures
    return widget.authenticationService.currentUser();
  }
}
