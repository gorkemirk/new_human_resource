import 'package:flutter/material.dart';
import 'package:new_human_resource/Components/create_user_form.dart';
import 'package:new_human_resource/main.dart';
import 'package:new_human_resource/responsive.dart';

class CreateUserPage extends StatelessWidget {
  const CreateUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingOnly(top: 8),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
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
              "Register User",
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Padding(
              padding: paddingAll(width: 10, height: 20),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                        child: CreateUserForm(
                      authenticationService: authenticationService,
                      databaseService: databaseService,
                    )),
                  ),
                ),
              ))),
    );
  }
}
