import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_human_resource/responsive.dart';

import '../Pages/user_checking_page.dart';
import '../constants.dart';
import '../main.dart';

class CreateMachineForm extends ConsumerStatefulWidget {
  const CreateMachineForm({super.key});

  @override
  ConsumerState<CreateMachineForm> createState() => _CreateMachineFormState();
}

bool registeringCompleted = false;
User? registeringUser;
var _emailTextController = TextEditingController();
var _passTextController = TextEditingController();
final _formKey = GlobalKey<FormState>();

class _CreateMachineFormState extends ConsumerState<CreateMachineForm> {
  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title:
            const Text("Create Machine", style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: paddingAll(width: 50, height: 50),
        child: Center(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: currentWidth * 0.5,
                    child: TextFormField(
                      controller: _emailTextController,
                      onSaved: (newValue) {},
                      keyboardType: TextInputType.emailAddress,
                      validator: ((value) {
                        if (value!.isEmpty) {
                          return "E-mail can't be empty";
                        } else {
                          return EmailValidator.validate(value)
                              ? null
                              : "Undefined email";
                        }
                      }),
                      decoration: const InputDecoration(label: Text("Email")),
                    )),
                sizedboxFlexHeight(10),
                SizedBox(
                    width: currentWidth * 0.5,
                    child: TextFormField(
                      obscureText: true,
                      onSaved: (newValue) {},
                      controller: _passTextController,
                      keyboardType: TextInputType.visiblePassword,
                      validator: ((value) {
                        if (value!.isEmpty) {
                          return "Password can't be empty";
                        } else if (value.length < 6) {
                          return "Password minimum 6 character";
                        } else {
                          return null;
                        }
                      }),
                      decoration:
                          const InputDecoration(label: Text("Password")),
                    )),
                sizedboxFlexHeight(30),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        await registerUser();
                        debugPrint("Create user:$registeringUser");
                        if (registeringUser != null) {
                          await createUser();
                          if (registeringCompleted) {
                            _formKey.currentState!.reset();
                            // ignore: use_build_context_synchronously
                            scaffoldMessanger(
                                context: context,
                                content: "Register is successful",
                                color: Colors.green);
                            // ignore: use_build_context_synchronously
                            //Navigator.pop(context);
                            authenticationService.userLogOut();
                            ref.read(currentUsercheckProvider.state).state =
                                null;
                          }
                        } else {
                          scaffoldMessanger(
                              context: context,
                              color: Colors.red,
                              content: "Some one went wrong.");
                        }
                      } else {
                        scaffoldMessanger(
                            context: context,
                            color: Colors.red,
                            content: "enter the information correctly");
                      }
                    },
                    child: const Text("Create Machine"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<User?> registerUser() async {
    registeringUser = await authenticationService.registerUser(
        email: _emailTextController.text, password: _passTextController.text);
    return registeringUser;
  }

  Future<bool> createUser() async {
    registeringCompleted = await databaseService.createMachine(
        user: registeringUser!, email: _emailTextController.text, isAdmin: 2);
    return registeringCompleted;
  }
}
