import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:new_human_resource/constants.dart';
import 'package:new_human_resource/main.dart';
import 'package:new_human_resource/responsive.dart';
import '../AuthService/base_auth_service.dart';
import '../FireBaseService/base_database_managment.dart';
import '../Pages/user_checking_page.dart';

class CreateUserForm extends ConsumerStatefulWidget {
  final AuthenticationService authenticationService;
  final DatabaseServices databaseService;
  const CreateUserForm(
      {super.key,
      required this.authenticationService,
      required this.databaseService});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateUserFormState();
}

List<String> searchkeys = [];
User? registeringUser;
late TextEditingController _emailTextController,
    _phoneNumberTextController,
    _nameTextController,
    _fingerPrintTextController,
    _passTextController;
bool isAdmin = false;
bool completePrintID = false;
bool registeringCompleted = false;
final _formKey = GlobalKey<FormState>();

class _CreateUserFormState extends ConsumerState<CreateUserForm> {
  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
    _nameTextController = TextEditingController();
    _phoneNumberTextController = TextEditingController();
    _fingerPrintTextController = TextEditingController();
    _passTextController = TextEditingController();
    _phoneNumberTextController.text = "+90";
  }

  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
    double currentHeight = MediaQuery.of(context).size.height;
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Center(
          child: Wrap(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: currentWidth * 0.65,
              child: TextFormField(
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
                controller: _emailTextController,
                decoration: const InputDecoration(label: Text("Email")),
              )),
          sizedboxFlexHeight(15),
          SizedBox(
              width: currentWidth * 0.65,
              child: TextFormField(
                onSaved: (newValue) {},
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Name can't be empty";
                  } else {
                    return null;
                  }
                }),
                controller: _nameTextController,
                decoration:
                    const InputDecoration(label: Text("Name and Surname")),
              )),
          sizedboxFlexHeight(15),
          SizedBox(
              width: currentWidth * 0.65,
              child: TextFormField(
                obscureText: true,
                onSaved: (newValue) {},
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
                controller: _passTextController,
                decoration: const InputDecoration(label: Text("Password")),
              )),
          sizedboxFlexHeight(15),
          SizedBox(
              width: currentWidth * 0.65,
              child: TextFormField(
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
                }),
                controller: _phoneNumberTextController,
                decoration: const InputDecoration(
                    label: Text("Phone Number"), hintText: "+905312949145"),
              )),
          sizedboxFlexHeight(15),
          SizedBox(
              width: currentWidth * 0.65,
              child: TextFormField(
                onSaved: (newValue) {},
                keyboardType: TextInputType.number,
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Fingerprint ID can't be empty";
                  } else if (value.length < 6) {
                    return "Wrong fingerprint";
                  } else {
                    return null;
                  }
                }),
                controller: _fingerPrintTextController,
                decoration:
                    const InputDecoration(label: Text("Fingerprint ID")),
              )),
          sizedboxFlexHeight(15),
          SizedBox(
              width: currentWidth * 0.65,
              child: CheckboxListTile(
                title: const Text("He/She is Admin ?"),
                onChanged: (bool? value) {
                  isAdmin = !isAdmin;
                  setState(() {});
                },
                value: isAdmin,
              )),
          sizedboxFlexHeight(15),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: HexColor("4e7596"),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  String searchkey = _nameTextController.text.toUpperCase();
                  for (int i = 1; i <= searchkey.length; i++) {
                    searchkeys.add(searchkey.substring(0, i));
                  }
                  await registerUser();
                  debugPrint("Create user:$registeringUser");
                  if (registeringUser != null) {
                    await createUser();
                    await createFingerID();
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
                      ref.read(currentUsercheckProvider.state).state = null;
                    }
                    searchkey = "";
                    searchkeys.clear();
                  } else {
                    // delete curretn user gelecek
                  }
                } else {
                  scaffoldMessanger(
                      context: context,
                      color: Colors.red,
                      content: "enter the information correctly");
                }
              },
              child: SizedBox(
                width: currentWidth * 0.635,
                height: currentHeight * 0.03,
                child: const Center(
                  child: Text(
                    "Register",
                  ),
                ),
              ))
        ],
      )),
    );
  }

  Future<User?> registerUser() async {
    registeringUser = await authenticationService.registerUser(
        email: _emailTextController.text, password: _passTextController.text);
    return registeringUser;
  }

  Future<bool> createUser() async {
    registeringCompleted = await databaseService.createUser(
        year: DateTime.now().year,
        telnumber: _phoneNumberTextController.text,
        user: registeringUser!,
        email: _emailTextController.text,
        isAdmin: isAdmin ? 0 : 1,
        name: _nameTextController.text.toUpperCase(),
        searchitems: searchkeys);
    return registeringCompleted;
  }

  Future<bool> createFingerID() async {
    //finger ıd ve uid databse oluşturmada kaldın

    completePrintID = await databaseService.createFingerID(
        fingerID: _fingerPrintTextController.text, uid: registeringUser!.uid);
    return completePrintID;
  }
}
