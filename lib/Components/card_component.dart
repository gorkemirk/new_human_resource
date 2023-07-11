import 'package:flutter/material.dart';
import 'package:new_human_resource/constants.dart';
import 'package:new_human_resource/responsive.dart';

// ignore: must_be_immutable
class CustomCardWidget extends StatelessWidget {
  String title;
  Color color;
  Icon icon;
  bool isVertical;
  String? subtitle;
  CustomCardWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.isVertical,
      this.subtitle,
      this.color = Colors.red});

  @override
  Widget build(BuildContext context) {
    return isVertical == true
        ? Material(
            borderRadius: BorderRadius.circular(15),
            color: color,
            child: Padding(
                padding: paddingAll(width: 20, height: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      title,
                      style: header2TextStyle,
                    ),
                    Center(
                      child: Text(
                        subtitle!,
                        style: header1TextStyle,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        icon,
                      ],
                    )
                  ],
                )),
          )
        : Material(
            borderRadius: BorderRadius.circular(15),
            color: color,
            child: Padding(
                padding: paddingAll(width: 20, height: 20),
                child: Stack(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          title,
                          style: header2TextStyle,
                        )),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: icon,
                    )
                  ],
                )),
          );
  }
}
