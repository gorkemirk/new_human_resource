import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationService {
  Future<bool> logInWithEmailPass(
      {required String email, required String password});
  Future<bool> userLogOut();
  User? currentUser();
  Future<User?> registerUser({required String email, required String password});
  Future<bool> updatePassword({required String newPassword});
  //Future<bool> deleteUser({required String id});
}
