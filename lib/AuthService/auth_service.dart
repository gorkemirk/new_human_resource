import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_human_resource/AuthService/base_auth_service.dart';

class FirebaseAuthentication extends AuthenticationService {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<bool> userLogOut() async {
    try {
      await auth.signOut();
      return true;
    } catch (e) {
      debugPrint('Çıkış Yapılamadı: $e');
      return false;
    }
  }

  @override
  Future<bool> logInWithEmailPass(
      {required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      debugPrint("Giriş yapılamadı $e");
      return false;
    }
  }

  @override
  User? currentUser() {
    User? currentUser = auth.currentUser;
    // ignore: prefer_if_null_operators
    debugPrint("Current User: $currentUser");
    // ignore: prefer_if_null_operators
    return currentUser != null ? currentUser : null;
  }

  @override
  Future<User?> registerUser(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await auth.currentUser?.sendEmailVerification();
      return userCredential.user;
    } catch (e) {
      debugPrint("createuseremailandpass erorrr");
      return null;
    }
  }

  @override
  Future<bool> updatePassword({required String newPassword}) async {
    try {
      await auth.currentUser!.updatePassword(newPassword);
      return true;
    } catch (e) {
      return false;
    }
  }
}
