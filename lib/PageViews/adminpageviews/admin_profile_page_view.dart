import 'dart:io';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_human_resource/Components/header_profile_infos.dart';
import 'package:new_human_resource/main.dart';
import 'package:new_human_resource/responsive.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../../Components/update_profile_form.dart';
import '../../Pages/user_checking_page.dart';
import '../../constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// ignore: must_be_immutable
class AdminProfilePageView extends ConsumerStatefulWidget {
  User user;
  late PersistentTabController navBarController;

  AdminProfilePageView(
      {super.key, required this.user, required this.navBarController});

  @override
  ConsumerState<AdminProfilePageView> createState() =>
      _AdminProfilePageViewState();
}

XFile? profilePhoto;

class _AdminProfilePageViewState extends ConsumerState<AdminProfilePageView> {
  final _formKey = GlobalKey<FormState>();
  String _newPassword = "";
  @override
  Widget build(BuildContext context) {
    double currentHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: paddingAll(width: 10, height: 30),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                HeaderProfileWidget(
                    stream: databaseService.firebaseDocumentSnapShot(
                        document: ref
                            .read(currentUsercheckProvider.state)
                            .state!
                            .uid
                            .toString())),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.16.h),
                          context: context,
                          builder: (context) {
                            return Wrap(
                              children: [
                                !kIsWeb
                                    ? ListTile(
                                        leading: const Icon(Icons.camera),
                                        onTap: () {
                                          _openCamera();
                                          Navigator.pop(context);
                                        },
                                        title: const Text("Fotoğraf çek."),
                                      )
                                    : Container(),
                                ListTile(
                                  leading: const Icon(Icons.image),
                                  onTap: () {
                                    _selectGallery();
                                    Navigator.pop(context);
                                  },
                                  title: const Text("Galeriden seç."),
                                )
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.add_a_photo)),
                )
              ],
            ),
          ),
          sizedboxFlexHeight(20),
          Expanded(
            flex: 10,
            child: ListView(
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const updateProfileForm();
                      },
                    );
                  },
                  child: const Card(
                      child: ListTile(
                          leading: Icon(Icons.people_sharp),
                          title: Text("Update your profile"))),
                ),
                GestureDetector(
                  onTap: () async {
                    await updatePassShowDialogForm(context, currentHeight);
                  },
                  child: const Card(
                      child: ListTile(
                          leading: Icon(FontAwesomeIcons.penSquare),
                          title: Text("Update your password"))),
                ),
                GestureDetector(
                  onTap: () async {
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
                                    ref
                                        .read(currentUsercheckProvider.state)
                                        .state = null;
                                  },
                                  child: const Text("Yes"))
                            ],
                          ),
                          title: const Text("Do you want to exit?"),
                        );
                      },
                    );
                    debugPrint("logout currentUser: ${widget.user.email}");
                  },
                  child: const Card(
                    child: ListTile(
                      leading: Icon(FontAwesomeIcons.signOutAlt),
                      title: Text("Logout"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  updatePassShowDialogForm(BuildContext context, double currentHeight) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter new password:"),
          content: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: SizedBox(
                height: currentHeight * 0.23,
                child: Padding(
                  padding: paddingAll(width: 20, height: 10),
                  child: Column(
                    children: [
                      TextFormField(
                          validator: ((value) {
                            if (value!.isEmpty) {
                              return "Password can't be empty";
                            } else if (value.length < 6) {
                              return "Minimum 6 character";
                            } else {
                              return null;
                            }
                          }),
                          onSaved: (value) {
                            _newPassword = value!;
                          },
                          decoration:
                              const InputDecoration(hintText: "new password")),
                      sizedboxFlexHeight(30),
                      ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              var isUpdatePass = await authenticationService
                                  .updatePassword(newPassword: _newPassword);
                              // ignore: use_build_context_synchronously
                              if (isUpdatePass) {
                                await authenticationService.userLogOut();
                                ref.read(currentUsercheckProvider.state).state =
                                    null;
                                scaffoldMessanger(
                                    context: context,
                                    color: Colors.green,
                                    content: "Password update completed");
                              } else {
                                scaffoldMessanger(
                                    context: context,
                                    color: Colors.red,
                                    content:
                                        "Password update not completed maybe it's the same as your old password");
                              }
                              debugPrint(isUpdatePass.toString());
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            } else {
                              scaffoldMessanger(
                                  context: context,
                                  content: "Wrong login",
                                  color: Colors.red);
                            }
                          },
                          child: const Text("Change Password"))
                    ],
                  ),
                ),
              )),
        );
      },
    );
  }

  Future<void> _selectGallery() async {
    late String? photoUrl;
    XFile? profilePhoto;
    profilePhoto = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (profilePhoto != null) {
      photoUrl = await firebaseStorage.uploadProfilePhoto(
          fileName: ref.watch(currentUsercheckProvider.state).state!.uid,
          file: File(profilePhoto.path));
      debugPrint("photo not null");
      if (photoUrl != null) {
        databaseService.updatePhoto(
            id: ref.watch(currentUsercheckProvider.state).state!.uid,
            url: photoUrl);
        scaffoldMessanger(
            content: "Profile photo updated",
            color: Colors.green,
            context: context);
        debugPrint("storage tetiklendi");
      } else {
        scaffoldMessanger(
            content: "profile photo could not be updated",
            color: Colors.red,
            context: context);
      }
    } else {
      scaffoldMessanger(
          content: "Photo not received try again.",
          color: Colors.red,
          context: context);
      debugPrint("photo null");
    }
  }

  Future<void> _openCamera() async {
    late String? photoUrl;
    XFile? profilePhoto;
    profilePhoto = await ImagePicker().pickImage(source: ImageSource.camera);
    if (profilePhoto != null) {
      photoUrl = await firebaseStorage.uploadProfilePhoto(
          fileName: ref.watch(currentUsercheckProvider.state).state!.uid,
          file: File(profilePhoto.path));
      debugPrint("photo not null");
      if (photoUrl != null) {
        databaseService.updatePhoto(
            id: ref.watch(currentUsercheckProvider.state).state!.uid,
            url: photoUrl);
        scaffoldMessanger(
            content: "Profile photo updated",
            color: Colors.green,
            context: context);
        debugPrint("storage tetiklendi");
      } else {
        scaffoldMessanger(
            content: "profile photo could not be updated",
            color: Colors.red,
            context: context);
      }
    } else {
      scaffoldMessanger(
          content: "Photo not received try again.",
          color: Colors.red,
          context: context);
      debugPrint("photo null");
    }
  }
}
