import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class DatabaseServices {
  Future<int> getUserisAdmin({required String id});
  Future<bool> createUser(
      {required User user,
      required String email,
      required String telnumber,
      required int isAdmin,
      required String name,
      required List<String> searchitems,
      required int year});
  Stream<QuerySnapshot<Map<String, dynamic>>> firebaseSearchUser(
      {required String collection,
      required String name,
      required String where});
  Stream<QuerySnapshot<Map<String, dynamic>>> firebaseCollectionSnapShot(
      {required String collection});
  Stream<DocumentSnapshot<Map<String, dynamic>>> firebaseDocumentSnapShot(
      {required String document});
  Stream<QuerySnapshot<Map<String, dynamic>>> firebaseDocumentWorkDatesSnapShot(
      {required String userid,
      required int documentYearID,
      required int documentMonthID});
  updatePhoto({required String id, required String url});
  Future<bool> createRequest(
      {required int solution,
      required String? fileUrl,
      required String uid,
      required String? name,
      required String? phone,
      required String content,
      required Timestamp createdAt,
      bool isRead = false,
      required int year,
      required int month,
      required int day,
      bool isConfirmed = false});
  Stream<QuerySnapshot<Map<String, dynamic>>> firebaseRequestSnapShot(
      {required String userid,
      required int documentYearID,
      required int documentMonthID,
      required int documentDayID});
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllRequests(
      {required bool isAdmin, required String? uid});
  Future<bool> updateRequestisReadAndisConfirmed(
      {required bool isRead,
      required String documentID,
      required bool isConfirmed});
  Future<bool> updateWorkDate(
      {required String userid,
      required int documentYearID,
      required int documentMonthID,
      required int documentDayID,
      required String mapName,
      required dynamic value});
  String createRandomID();
  Future<Map<String, dynamic>> getFutureNumberAndName({required String uid});
  Future<bool> updateProfile(
      {required String uid,
      required String name,
      required String number,
      required List<String> searchitems});
  Future<bool> createMachine({
    required User user,
    required String email,
    required int isAdmin,
  });
  Future<bool> createFingerID({required String fingerID, required String uid});
  Future<String?> getIDwithFingerPrint({required String fingerID});
  Future<bool> searchWorkDate(
      {required int year,
      required int month,
      required int day,
      required String uid});
  Future<bool> createEntryWorkTime(
      {required Timestamp entryTime,
      required int day,
      required int month,
      required int year,
      required String uid});
  Future<bool> updateExitWorkTime(
      {required String uid,
      required Timestamp exitTime,
      required int day,
      required int month,
      required int year,
      required double workedtime,
      required bool workedtimecompleted});
  Future<DateTime?> getEntryTimeinWorkDate(
      {required String uid,
      required int day,
      required int month,
      required int year});
  Future<bool> getEnxitTimeinWorkDate(
      {required String uid,
      required int day,
      required int month,
      required int year});
  Future<bool> currentRequestDelete({required String requestID});
  Future<bool> updateYillikIzin({required String id, required int day});
  Future<bool> addAnnualRequest(
      {required int howmanyDay,
      required String id,
      required int day,
      required String name,
      required String telnumber,
      required DateTime startDate,
      required DateTime finishDate,
      required int month,
      required int year,
      required String? content});
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllAnonualRequests(
      {required bool isAdmin, required String? uid});
  Future<bool> updateRequestisReadAndisConfirmedAnnual(
      {required bool isRead,
      required String documentID,
      required bool isConfirmed});
  Future<bool> currentAnnualRequestDelete({required String requestID});
  Stream<QuerySnapshot<Map<String, dynamic>>> getAdmins();
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      {required String adminID, required String userID});
  Future<bool> sendMessage(
      {required String senderID,
      required String ppimageurl,
      required Timestamp createdAt,
      required String message,
      required String adminID,
      required String userID,
      required String username,
      required bool isAdmin});
  Stream<QuerySnapshot<Map<String, dynamic>>> getAdminChats(
      {required String adminID});
}
