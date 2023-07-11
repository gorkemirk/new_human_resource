import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

Color colorScaffoldBackground = const Color.fromRGBO(250, 250, 251, 1);

scaffoldMessanger(
    {dynamic context, required String content, required Color color}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      content: Text(
        content,
        style: const TextStyle(color: Colors.white),
      )));
}

//*******************  TextStyless ******************************************************************//
TextStyle headerTextStyleBlack =
    TextStyle(fontSize: 40.w, fontWeight: FontWeight.w600, color: Colors.black);
TextStyle headerTextStyle =
    TextStyle(fontSize: 40.h, fontWeight: FontWeight.bold, color: Colors.white);
TextStyle header1TextStyle =
    TextStyle(fontSize: 34.h, fontWeight: FontWeight.bold, color: Colors.white);
TextStyle header2TextStyle =
    TextStyle(fontSize: 26.h, fontWeight: FontWeight.bold, color: Colors.white);
//*******************  IconStyles ******************************************************************//
Icon whiteArrow = const Icon(
  Icons.arrow_forward_ios,
  color: Colors.white,
);
//*******************  Admin NavigationBarItems ******************************************************************//
// ignore: non_constant_identifier_names
List<PersistentBottomNavBarItem> adminNavigationBarItems = [
  PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.home),
      title: "Home",
      inactiveColorPrimary: CupertinoColors.systemGrey,
      activeColorSecondary: Colors.white,
      activeColorPrimary: HexColor("4e7596")),
  PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.person_3_fill),
      title: "Workers",
      inactiveColorPrimary: CupertinoColors.systemGrey,
      activeColorPrimary: HexColor("4e7596"),
      activeColorSecondary: Colors.white),
  PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.arrow_2_squarepath),
      title: "Requests",
      inactiveColorPrimary: CupertinoColors.systemGrey,
      activeColorPrimary: HexColor("4e7596"),
      activeColorSecondary: Colors.white),
  PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.profile_circled),
      title: "Profile",
      inactiveColorPrimary: CupertinoColors.systemGrey,
      activeColorPrimary: HexColor("4e7596"),
      activeColorSecondary: Colors.white),
];

List<PersistentBottomNavBarItem> userNavigationBarItems = [
  PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.home),
      title: "Home",
      inactiveColorPrimary: CupertinoColors.systemGrey,
      activeColorSecondary: Colors.white,
      activeColorPrimary: HexColor("4e7596")),
  PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.arrow_2_squarepath),
      title: "Requests",
      inactiveColorPrimary: CupertinoColors.systemGrey,
      activeColorPrimary: HexColor("4e7596"),
      activeColorSecondary: Colors.white),
  PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.profile_circled),
      title: "Profile",
      inactiveColorPrimary: CupertinoColors.systemGrey,
      activeColorPrimary: HexColor("4e7596"),
      activeColorSecondary: Colors.white),
];
