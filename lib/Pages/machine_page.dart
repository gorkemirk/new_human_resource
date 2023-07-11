import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_human_resource/PageViews/machinepageview/machine_page_view.dart';
import 'package:new_human_resource/Pages/user_checking_page.dart';
import 'package:new_human_resource/main.dart';

class MachinePage extends ConsumerStatefulWidget {
  const MachinePage({super.key});

  @override
  ConsumerState<MachinePage> createState() => _MachinePageState();
}

class _MachinePageState extends ConsumerState<MachinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Machine"),
        actions: [
          IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("No")),
                          ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await authenticationService.userLogOut();
                                ref.read(currentUsercheckProvider.state).state =
                                    null;
                              },
                              child: const Text("Yes"))
                        ],
                      ),
                      title: const Text("Do you want to exit?"),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: const MachinePageView(),
    );
  }
}
