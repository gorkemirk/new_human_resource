import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FireBaseStorage {
  var firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadFileWeb(
      {required Uint8List file, required String fileName}) async {
    String? url;
    try {
      var ref = firebaseStorage.ref("files/$fileName");
      var task = ref.putData(file);
      await task.whenComplete(() async {
        url = await ref.getDownloadURL();
        debugPrint("url: $url");
      });
      return url;
    } catch (e) {
      debugPrint("url: HATA");

      return null;
    }
  }

  Future<String?> uploadFileMobile(
      {required File file, required String fileName}) async {
    String? url;
    try {
      var ref = firebaseStorage.ref("files/$fileName");
      var task = ref.putFile(file);
      await task.whenComplete(() async {
        url = await ref.getDownloadURL();
        debugPrint("url: $url");
      });
      return url;
    } catch (e) {
      debugPrint("url: HATA");
      return null;
    }
  }

  Future<String?> uploadProfilePhoto(
      {required File file, required String fileName}) async {
    String? url;
    try {
      var ref = firebaseStorage.ref(fileName);
      var task = ref.putFile(file);
      await task.whenComplete(() async {
        url = await ref.getDownloadURL();
        debugPrint("url: $url");
      });
      return url;
    } catch (e) {
      debugPrint("url: HATA");
      return null;
    }
  }
}
