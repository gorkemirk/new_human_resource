import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'base_database_managment.dart';

class FireBaseManagment extends DatabaseServices {
  String ppimageurl =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<int> getUserisAdmin({required String id}) async {
    try {
      var userDocument = await firestore.doc("users/$id").get();
      int isAdmin = userDocument.data()!["isAdmin"];
      return isAdmin;
    } catch (e) {
      debugPrint(e.toString());
      return 9;
    }
  }

  @override
  Future<bool> createUser(
      {required User user,
      required String email,
      required String telnumber,
      required int isAdmin,
      required String name,
      required List<String> searchitems,
      required int year}) async {
    try {
      await firestore.doc("users/${user.uid}").set({
        "email": email,
        "id": user.uid,
        "isAdmin": isAdmin,
        "telnumber": telnumber,
        "yillikizin": 18,
        "name": name,
        "ppimageurl": ppimageurl,
        "searchitems": searchitems
      });
      return true;
    } catch (e) {
      debugPrint("userCreate HATA");
      return false;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> firebaseSearchUser(
      {required String collection,
      required String name,
      required String where}) {
    return firestore
        .collection(collection)
        .where(where, arrayContains: name)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> firebaseCollectionSnapShot(
      {required String collection}) {
    return firestore
        .collection(collection)
        .orderBy("name", descending: false)
        .snapshots();
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> firebaseDocumentSnapShot(
      {required String document}) {
    return firestore.doc("users/$document").snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> firebaseDocumentWorkDatesSnapShot(
      {required String userid,
      required int documentYearID,
      required int documentMonthID}) {
    return firestore
        .collection("workdates")
        .where("uid", isEqualTo: userid)
        .where("year", isEqualTo: documentYearID)
        .where("month", isEqualTo: documentMonthID)
        .snapshots();
  }

  @override
  updatePhoto({required String id, required String url}) async {
    await firestore.doc("users/$id").update({"ppimageurl": url});
  }

  @override
  Future<bool> createRequest({
    required int solution,
    String? fileUrl,
    required String uid,
    required String content,
    required Timestamp createdAt,
    required int year,
    required int month,
    required int day,
    bool isConfirmed = false,
    bool isRead = false,
    required String? name,
    required String? phone,
  }) async {
    try {
      Map<String, dynamic> addValue = {
        "solution": solution,
        "fileUrl": fileUrl,
        "uid": uid,
        "phone": phone,
        "name": name,
        "content": content,
        "year": year,
        "month": month,
        "day": day,
        "isRead": isRead,
        "createdAt": createdAt,
        "isConfirmed": isConfirmed
      };
      await firestore.collection("requests").add(addValue);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> firebaseRequestSnapShot(
      {required String userid,
      required int documentYearID,
      required int documentMonthID,
      required int documentDayID}) {
    return firestore
        .collection("requests")
        .where("uid", isEqualTo: userid)
        .where("year", isEqualTo: documentYearID)
        .where("month", isEqualTo: documentMonthID)
        .where("day", isEqualTo: documentDayID)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllRequests(
      {required bool isAdmin, required String? uid}) {
    return isAdmin
        ? firestore
            .collection("requests")
            .where("isRead", isEqualTo: false)
            .snapshots()
        : firestore
            .collection("requests")
            .where("uid", isEqualTo: uid)
            .snapshots();
  }

  @override
  Future<bool> updateRequestisReadAndisConfirmed(
      {required bool isRead,
      required String documentID,
      required bool isConfirmed}) async {
    try {
      debugPrint("request documen ID:$documentID");
      await firestore
          .collection("requests")
          .doc(documentID)
          .update({"isRead": true, "isConfirmed": isConfirmed});
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateWorkDate(
      {required String userid,
      required int documentYearID,
      required int documentMonthID,
      required int documentDayID,
      required String mapName,
      required dynamic value}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> document = await firestore
          .collection("workdates")
          .where("uid", isEqualTo: userid)
          .where("year", isEqualTo: documentYearID)
          .where("month", isEqualTo: documentMonthID)
          .where("day", isEqualTo: documentDayID)
          .get();
      String documentID = document.docs.first.id;
      await firestore
          .collection("workdates")
          .doc(documentID)
          .update({mapName: value});

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  String createRandomID() {
    var randomId = firestore.collection("users").doc().id;
    return randomId;
  }

  @override
  Future<Map<String, dynamic>> getFutureNumberAndName(
      {required String uid}) async {
    Map<String, dynamic> myMap;
    DocumentSnapshot<Map<String, dynamic>> docRef =
        await firestore.collection("users").doc(uid).get();
    myMap = {
      "telnumber": docRef.data()!["telnumber"],
      "name": docRef.data()!["name"]
    };
    return myMap;
  }

  @override
  Future<bool> updateProfile(
      {required String uid,
      required String name,
      required String number,
      required List<String> searchitems}) async {
    try {
      await firestore.collection("users").doc(uid).update(
          {"name": name, "telnumber": number, "searchitems": searchitems});
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> createMachine(
      {required User user, required String email, required int isAdmin}) async {
    try {
      await firestore
          .collection("users")
          .doc(user.uid)
          .set({"isAdmin": isAdmin, "id": user.uid, "email": email});
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> createFingerID(
      {required String fingerID, required String uid}) async {
    try {
      firestore
          .collection("fingerprints")
          .doc(uid)
          .set({"id": uid, "fingerID": fingerID});
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> getIDwithFingerPrint({required String fingerID}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> docRef = await firestore
          .collection("fingerprints")
          .where("fingerID", isEqualTo: fingerID)
          .get();
      String id = docRef.docs.first.data()["id"];
      debugPrint(id.toString());
      return id;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> searchWorkDate(
      {required int year,
      required int month,
      required int day,
      required String uid}) async {
    QuerySnapshot<Map<String, dynamic>> docRef = await firestore
        .collection("workdates")
        .where("year", isEqualTo: year)
        .where("month", isEqualTo: month)
        .where("day", isEqualTo: day)
        .where("uid", isEqualTo: uid)
        .get();
    return docRef.docs.isNotEmpty ? true : false;
  }

  @override
  Future<bool> createEntryWorkTime(
      {required Timestamp entryTime,
      required int day,
      required int month,
      required int year,
      required String uid}) async {
    try {
      Map<String, dynamic> workdate = {
        "day": day,
        "month": month,
        "year": year,
        "uid": uid,
        "exittime": null,
        "entrytime": entryTime,
        "workedtime": 0.1,
        "workedtimecompleted": false
      };
      await firestore.collection("workdates").add(workdate);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateExitWorkTime(
      {required String uid,
      required Timestamp exitTime,
      required int day,
      required int month,
      required int year,
      required double workedtime,
      required bool workedtimecompleted}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> docRef = await firestore
          .collection("workdates")
          .where("year", isEqualTo: year)
          .where("month", isEqualTo: month)
          .where("day", isEqualTo: day)
          .where("uid", isEqualTo: uid)
          .get();
      await firestore.collection("workdates").doc(docRef.docs.first.id).update({
        "workedtime": workedtime,
        "workedtimecompleted": workedtimecompleted,
        "exittime": exitTime
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<DateTime?> getEntryTimeinWorkDate(
      {required String uid,
      required int day,
      required int month,
      required int year}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> docRef = await firestore
          .collection("workdates")
          .where("uid", isEqualTo: uid)
          .where("year", isEqualTo: year)
          .where("month", isEqualTo: month)
          .where("day", isEqualTo: day)
          .get();
      debugPrint(docRef.docs.length.toString());
      DateTime? entryTime =
          (docRef.docs.first.data()["entrytime"] as Timestamp).toDate();
      debugPrint(entryTime.toString());
      return entryTime;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> getEnxitTimeinWorkDate(
      {required String uid,
      required int day,
      required int month,
      required int year}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> docRef = await firestore
          .collection("workdates")
          .where("uid", isEqualTo: uid)
          .where("year", isEqualTo: year)
          .where("month", isEqualTo: month)
          .where("day", isEqualTo: day)
          .get();
      return docRef.docs.first.data()["exittime"] != null ? false : true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> currentRequestDelete({required String requestID}) async {
    try {
      await firestore.collection("requests").doc(requestID).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateYillikIzin({required String id, required int day}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docRef =
          await firestore.collection("users").doc(id).get();
      int newYillikIzin = (docRef.data()!["yillikizin"] as int) - day;
      await firestore
          .collection("users")
          .doc(id)
          .update({"yillikizin": newYillikIzin});
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> addAnnualRequest(
      {required String id,
      required int howmanyDay,
      required int day,
      required int month,
      required int year,
      required String? content,
      required String name,
      required String telnumber,
      required DateTime startDate,
      required DateTime finishDate}) async {
    try {
      Map<String, dynamic> addValue = {
        "uid": id,
        "startdate": startDate,
        "finishdate": finishDate,
        "howmanyday": howmanyDay,
        "phone": telnumber,
        "name": name,
        "content": content,
        "year": year,
        "month": month,
        "day": day,
        "isRead": false,
        "createdAt": Timestamp.now(),
        "isConfirmed": false
      };
      await firestore.collection("annualrequests").add(addValue);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllAnonualRequests(
      {required bool isAdmin, required String? uid}) {
    return isAdmin
        ? firestore
            .collection("annualrequests")
            .where("isRead", isEqualTo: false)
            .snapshots()
        : firestore
            .collection("annualrequests")
            .where("uid", isEqualTo: uid)
            .snapshots();
  }

  @override
  Future<bool> updateRequestisReadAndisConfirmedAnnual(
      {required bool isRead,
      required String documentID,
      required bool isConfirmed}) async {
    try {
      debugPrint("request documen ID:$documentID");
      await firestore
          .collection("annualrequests")
          .doc(documentID)
          .update({"isRead": true, "isConfirmed": isConfirmed});
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> currentAnnualRequestDelete({required String requestID}) async {
    try {
      await firestore.collection("annualrequests").doc(requestID).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getAdmins() {
    return firestore
        .collection("users")
        .where("isAdmin", isEqualTo: 0)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      {required String adminID, required String userID}) {
    return firestore
        .collection("messages")
        .doc("$adminID--$userID")
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  @override
  Future<bool> sendMessage(
      {required String senderID,
      required String ppimageurl,
      required Timestamp createdAt,
      required String message,
      required String adminID,
      required String userID,
      required String username,
      required bool isAdmin}) async {
    try {
      Map<String, dynamic> addValue = {
        "message": message,
        "createdAt": createdAt,
        "senderID": senderID
      };
      isAdmin
          ? null
          : await firestore
              .collection("messages")
              .doc("$adminID--$userID")
              .set({
              "adminID": adminID,
              "username": username,
              "userID": userID,
              "ppimageurl": ppimageurl
            });
      await firestore
          .collection("messages")
          .doc("$adminID--$userID")
          .collection("messages")
          .add(addValue);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getAdminChats(
      {required String adminID}) {
    return firestore
        .collection("messages")
        .where("adminID", isEqualTo: adminID)
        .snapshots();
  }
}
