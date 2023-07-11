import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable

class HeaderProfileWidget extends StatefulWidget {
  Stream<DocumentSnapshot<Map<String, dynamic>>> stream;
  HeaderProfileWidget({super.key, required this.stream});

  @override
  State<HeaderProfileWidget> createState() => _HeaderProfileWidgetState();
}

StateProvider<String?>? telnumberProvider;
StateProvider<String?>? nameProvider;
StateProvider<String?>? ppimageProvider;

class _HeaderProfileWidgetState extends State<HeaderProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.stream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          debugPrint(snapshot.data!["ppimageurl"].toString());
          telnumberProvider = StateProvider<String?>(
            (ref) => snapshot.data!["telnumber"],
          );
          nameProvider = StateProvider<String?>(
            (ref) => snapshot.data!["name"],
          );
          ppimageProvider = StateProvider<String?>(
            (ref) => snapshot.data!["ppimageurl"],
          );
          return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 20,
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CachedNetworkImage(
                      imageUrl: snapshot.data!["ppimageurl"],
                      imageBuilder: (context, imageProvider) {
                        return CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: imageProvider,
                        );
                      },
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                const Spacer(
                  flex: 3,
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    snapshot.data!["name"],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ),
                const Spacer(
                  flex: 2,
                ),
                const Expanded(
                  flex: 1,
                  child: Divider(
                    endIndent: 10,
                    indent: 10,
                    color: Colors.black,
                    height: 2,
                    thickness: 0.5,
                  ),
                )
              ]);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
