import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_human_resource/responsive.dart';

// ignore: camel_case_types
class dropDownMenu extends ConsumerStatefulWidget {
  const dropDownMenu({super.key});

  @override
  ConsumerState<dropDownMenu> createState() => _dropDownMenuState();
}

StateProvider<int> selectedMonth = StateProvider<int>(
  (ref) => DateTime.now().month,
);
StateProvider<int> selectedYear = StateProvider<int>(
  (ref) => DateTime.now().year,
);

// ignore: camel_case_types
class _dropDownMenuState extends ConsumerState<dropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton(
          value: ref.watch(selectedMonth.state).state,
          onChanged: (value) {
            ref.read(selectedMonth.state).state = value!;
          },
          items: const [
            DropdownMenuItem(value: 1, child: Text("Ocak")),
            DropdownMenuItem(value: 2, child: Text("Şubat")),
            DropdownMenuItem(value: 3, child: Text("Mart")),
            DropdownMenuItem(value: 4, child: Text("Nisan")),
            DropdownMenuItem(value: 5, child: Text("Mayıs")),
            DropdownMenuItem(value: 6, child: Text("Haziran")),
            DropdownMenuItem(value: 7, child: Text("Temmuz")),
            DropdownMenuItem(value: 8, child: Text("Ağustos")),
            DropdownMenuItem(value: 9, child: Text("Eylül")),
            DropdownMenuItem(value: 10, child: Text("Ekim")),
            DropdownMenuItem(value: 11, child: Text("Kasım")),
            DropdownMenuItem(value: 12, child: Text("Aralık")),
          ],
        ),
        sizedboxFlexWidth(20),
        DropdownButton(
          value: ref.watch(selectedYear.state).state,
          onChanged: (value) {
            ref.read(selectedYear.state).state = value!;
          },
          items: [
            DropdownMenuItem(
                value: DateTime.now().year - 2,
                child: Text((DateTime.now().year - 2).toString())),
            DropdownMenuItem(
                value: DateTime.now().year - 1,
                child: Text((DateTime.now().year - 1).toString())),
            DropdownMenuItem(
                value: DateTime.now().year,
                child: Text((DateTime.now().year).toString())),
          ],
        )
      ],
    );
  }
}
