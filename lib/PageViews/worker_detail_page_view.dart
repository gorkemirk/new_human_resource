import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_human_resource/Components/dropDownMenu.dart';
import 'package:new_human_resource/Components/mycustom_listview_card.dart';
import '../Pages/user_checking_page.dart';
import '../main.dart';

// ignore: must_be_immutable
class WorkerDetailPageView extends StatelessWidget {
  bool userOrAdminLogin;
  Map<String, dynamic>? selectedUser;
  WorkerDetailPageView(
      {super.key, this.selectedUser, required this.userOrAdminLogin});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return StreamBuilder(
          stream: databaseService.firebaseDocumentWorkDatesSnapShot(
              userid: selectedUser != null
                  ? selectedUser!["id"].toString()
                  : ref
                      .read(currentUsercheckProvider.state)
                      .state!
                      .uid
                      .toString(),
              documentYearID: ref.watch(selectedYear.state).state,
              documentMonthID: ref.watch(selectedMonth.state).state),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.size != 0) {
                return ListView.builder(
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    Map<String, dynamic>? workdate =
                        snapshot.data!.docs[index].data();
                    for (int i = 0; i < snapshot.data!.size; i++) {
                      //kontrol documan günler
                      debugPrint(snapshot.data!.docs[index].id);
                    }
                    if (workdate.isNotEmpty) {
                      return MyCustomListViewItem(
                        workdate: workdate,
                        userOrAdminLogin: userOrAdminLogin,
                      );
                    } else {
                      return const ListTile(
                        title: Text("NULL"),
                      );
                    }
                  },
                );
              } else {
                return const Center(child: Text("Kayıt bulunamadı."));
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}
