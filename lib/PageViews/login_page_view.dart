import 'package:flutter/material.dart';
import 'package:new_human_resource/Components/login_form.dart';
import '../AuthService/base_auth_service.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  final AuthenticationService authenticationService;
  LoginPage({super.key, required this.authenticationService});
  String loginImageUrl = "assets/images/logo.png";
  @override
  Widget build(BuildContext context) {
    double currentHeight = MediaQuery.of(context).size.height;
    double currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SizedBox(
        height: currentHeight * 1.2,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                  height: currentHeight * 0.6,
                  width: currentWidth * 0.8,
                  child: Image.asset(
                    loginImageUrl,
                    fit: BoxFit.contain,
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: currentHeight * 0.45,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white,
                ),
                child: Center(
                    child: LoginForm(
                        authenticationService: authenticationService)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
