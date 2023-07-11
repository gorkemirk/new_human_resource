import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget sizedboxFlexHeight(double height) {
  return SizedBox(
    height: height.h,
  );
}

Widget sizedboxFlexWidth(double width) {
  return SizedBox(
    width: width.w,
  );
}

EdgeInsetsGeometry paddingHorizontal(double width) {
  return EdgeInsets.symmetric(horizontal: width.w);
}

EdgeInsetsGeometry paddingVertical(double height) {
  return EdgeInsets.symmetric(horizontal: height.h);
}

EdgeInsetsGeometry paddingAll({required double width, required double height}) {
  return EdgeInsets.symmetric(vertical: height.h, horizontal: width.w);
}

EdgeInsetsGeometry paddingOnly(
    {double top = 0, double bottom = 0, double left = 0, double right = 0}) {
  return EdgeInsets.only(
      bottom: bottom.h, left: left.w, right: right.w, top: top.h);
}
