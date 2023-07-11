import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import '../AuthService/base_auth_service.dart';
import '../constants.dart';
import '../Pages/user_checking_page.dart';
import '../responsive.dart';

// ignore: must_be_immutable
class LoginForm extends ConsumerStatefulWidget {
  AuthenticationService authenticationService;
  LoginForm({super.key, required this.authenticationService});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginFormState();
}

User? currentUser;
final _formKey = GlobalKey<FormState>();
late TextEditingController _emailController, _passController;

class _LoginFormState extends ConsumerState<LoginForm> {
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passController = TextEditingController();
    // ignore: unused_local_variable
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  late bool isSignIn;
  User? onSignInUser;
  @override
  Widget build(BuildContext context) {
    return Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: Padding(
          padding: paddingHorizontal(60),
          child: Column(
            children: [
              sizedboxFlexHeight(30),
              TextFormField(
                controller: _emailController,
                onSaved: (newValue) {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return "E-mail can't be empty";
                  } else {
                    return EmailValidator.validate(value)
                        ? null
                        : "Undefined email";
                  }
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.alternate_email),
                    label: Text(
                      "E-mail",
                    )),
              ),
              sizedboxFlexHeight(20),
              TextFormField(
                obscureText: true,
                controller: _passController,
                onSaved: (newValue) {},
                keyboardType: TextInputType.visiblePassword,
                validator: (pass) {
                  if (pass!.isEmpty) {
                    return "Password can't be empty";
                  } else if (pass.length < 6) {
                    return "Minimum 6 character";
                  } else {
                    return null;
                  }
                },
                textInputAction: TextInputAction.go,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    label: Text(
                      "Password",
                    )),
              ),
              sizedboxFlexHeight(40),
              signInButton(context)
            ],
          ),
        ));
  }

  ElevatedButton signInButton(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: HexColor("4e7596")),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            isSignIn = await widget.authenticationService.logInWithEmailPass(
                email: _emailController.text, password: _passController.text);
            isSignIn
                ? ref.read(currentUsercheckProvider.state).state = _checkUser()
                // ignore: use_build_context_synchronously
                : scaffoldMessanger(
                    context: context,
                    content: "The user is not registered",
                    color: Colors.red);
            debugPrint("form savelendi issignin:$isSignIn");
          } else {
            scaffoldMessanger(
                context: context, content: "Wrong login", color: Colors.red);
          }
        },
        child: const Center(child: Text("Sign in")));
  }

  User? _checkUser() {
    currentUser = widget.authenticationService.currentUser();
    debugPrint("login currentUser: $currentUser");
    return currentUser;
  }
}
