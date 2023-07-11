import 'package:flutter/material.dart';

import '../../Components/request_card _component.dart';
import '../../main.dart';
import '../../responsive.dart';

class AnonualRequests extends StatelessWidget {
  AnonualRequests({super.key});
  late Color color;
  @override
  Widget build(BuildContext context) {
    debugPrint("girdi");
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Scaffold(
        body: SafeArea(
            child: StreamBuilder(
                stream: databaseService.getAllAnonualRequests(
                    isAdmin: true, uid: null),
                builder: (context, snapshot) {
                  debugPrint(snapshot.hasData.toString() + " annoul data");
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return Padding(
                      padding: paddingAll(width: 20, height: 20),
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          switch (index % 3) {
                            case 0:
                              color = const Color.fromRGBO(204, 206, 197, 1);
                              break;
                            case 1:
                              color = const Color.fromRGBO(209, 188, 217, 1);
                              break;
                            case 2:
                              color = const Color.fromRGBO(178, 199, 219, 1);
                              break;
                          }
                          return RequestCardComponent(
                            isPending: false,
                            documentID: snapshot.data!.docs[index].id,
                            currentRequest: snapshot.data!.docs[index],
                            isAdmin: true,
                            color: color,
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text("Request not found"),
                    );
                  }
                })),
      ),
    );
  }
}
