import 'package:flutter/material.dart';

class AdminCreateUserPageView extends StatelessWidget {
  const AdminCreateUserPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          decoration: const InputDecoration(label: Text("Email")),
        ),
        TextFormField(),
        TextFormField(),
        TextFormField(),
      ],
    ));
  }
}
