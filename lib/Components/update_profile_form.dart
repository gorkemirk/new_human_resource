import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_human_resource/Pages/user_checking_page.dart';
import 'package:new_human_resource/constants.dart';
import 'package:new_human_resource/main.dart';
import 'package:new_human_resource/responsive.dart';

// ignore: camel_case_types
class updateProfileForm extends ConsumerStatefulWidget {
  const updateProfileForm({super.key});

  @override
  ConsumerState<updateProfileForm> createState() => _updateProfileFormState();
}

final formKey = GlobalKey<FormState>();
late List<String> searchkeys;

// ignore: camel_case_types
class _updateProfileFormState extends ConsumerState<updateProfileForm> {
  @override
  void initState() {
    super.initState();
    searchkeys = [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: databaseService.getFutureNumberAndName(
          uid: ref.watch(currentUsercheckProvider.state).state!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String name = snapshot.data!["name"];
          String number = snapshot.data!["telnumber"];
          TextEditingController nameTextController =
              TextEditingController(text: name);
          TextEditingController phoneTextController =
              TextEditingController(text: number);

          return AlertDialog(
            title: const Text("Update your profile"),
            content: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameTextController,
                    decoration: const InputDecoration(label: Text("Name")),
                    onSaved: (newValue) {},
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "Name can't be empty";
                      } else {
                        return null;
                      }
                    }),
                  ),
                  sizedboxFlexHeight(10),
                  TextFormField(
                      controller: phoneTextController,
                      decoration:
                          const InputDecoration(label: Text("Phone number")),
                      onSaved: (newValue) {},
                      keyboardType: TextInputType.number,
                      validator: ((value) {
                        if (value!.isEmpty) {
                          return "Phone number can't be empty";
                        } else if (value.length < 13 || value.length > 13) {
                          return "Wrong number";
                        } else {
                          return null;
                        }
                      })),
                  sizedboxFlexHeight(20),
                  ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          String searchkey =
                              nameTextController.text.toUpperCase();
                          for (int i = 1; i <= searchkey.length; i++) {
                            searchkeys.add(searchkey.substring(0, i));
                          }
                          bool isUpdated = await databaseService.updateProfile(
                              searchitems: searchkeys,
                              uid: ref
                                  .watch(currentUsercheckProvider.state)
                                  .state!
                                  .uid,
                              name: nameTextController.text.toUpperCase(),
                              number: phoneTextController.text);
                          if (isUpdated) {
                            scaffoldMessanger(
                                content: "Profile update successful.",
                                color: Colors.green,
                                context: context);
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          } else {
                            scaffoldMessanger(
                                content: "Profile update failed.",
                                color: Colors.red,
                                context: context);
                          }
                        } else {
                          formKey.currentState!.reset();
                          scaffoldMessanger(
                              content:
                                  "Make sure the information entered is correct.",
                              color: Colors.yellow,
                              context: context);
                          searchkeys = [];
                        }
                      },
                      child: const Text("Update"))
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
