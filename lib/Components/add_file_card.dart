import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../main.dart';
import '../responsive.dart';

// ignore: camel_case_types
class fileCard extends ConsumerStatefulWidget {
  const fileCard({super.key});

  @override
  ConsumerState<fileCard> createState() => _fileCardState();
}

var excuseFileUrl = StateProvider<String?>(
  (ref) => null,
);
var requestFile = StateProvider<int>(
  (ref) => 0,
);
var result = StateProvider<FilePickerResult?>(
  (ref) => null,
);

// ignore: camel_case_types
class _fileCardState extends ConsumerState<fileCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingAll(width: 10, height: 10),
      child: InkWell(
        onTap: () async {
          if (ref.watch(requestFile.state).state == 0) {
            !kIsWeb ? await _uploadFileMobile() : await _uploadFileWeb();
          } else {
            setState(() {
              ref.read(requestFile.state).state = 0;
              ref.read(result.state).state = null;
            });
          }
        },
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                  style: BorderStyle.solid,
                  color: ref.watch(requestFile.state).state == 0
                      ? Colors.blue
                      : Colors.amber)),
          child: ListTile(
            title: ref.watch(requestFile.state).state == 0
                ? const Text(
                    "Select excuse folder +",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blue),
                  )
                : const Text(
                    "Selected 1 folder. Tap to Remove",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.amber),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _uploadFileMobile() async {
    ref.read(result.state).state =
        await FilePicker.platform.pickFiles(type: FileType.any);
    String id = databaseService.createRandomID();
    if (ref.watch(result.state).state != null &&
        ref.watch(result.state).state!.files.isNotEmpty) {
      File file = File(ref.watch(result.state).state!.files.single.path!);
      setState(() {
        ref.read(requestFile.state).state = 1;
      });
      await firebaseStorage
          .uploadFileMobile(file: file, fileName: id)
          .then((value) {
        ref.read(excuseFileUrl.state).state = value;
      });
    } else {
      debugPrint("FOTOGRAF NULL");
      scaffoldMessanger(
          content: "Could not select file",
          color: Colors.red,
          context: context);
    }
  }

  Future<void> _uploadFileWeb() async {
    ref.read(result.state).state =
        await FilePicker.platform.pickFiles(type: FileType.any);
    String id = databaseService.createRandomID();
    // ignore: unnecessary_null_comparison
    if (result != null && ref.watch(result.state).state!.count != 0) {
      setState(() {
        ref.read(requestFile.state).state = 1;
      });
      Uint8List? fileBytes = ref.watch(result.state).state!.files.first.bytes;
      await firebaseStorage
          .uploadFileWeb(file: fileBytes!, fileName: id)
          .then((value) {
        ref.read(excuseFileUrl.state).state = value;
      });
      debugPrint("ExcuseFileUrl:${ref.watch(excuseFileUrl.state).state}");
    } else {
      debugPrint("FOTOGRAF NULL");
      scaffoldMessanger(
          content: "Could not select file",
          color: Colors.red,
          context: context);
    }
  }
}
