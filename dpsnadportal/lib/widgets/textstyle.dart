import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTextStyle {

  static Function notosansRegular = ({required Color color, required double size}) =>
      _notosansRegular(color, size, FontWeight.normal);

  static TextStyle _notosansRegular(
      Color color, double size, FontWeight fontWeight) {
    return _textStyle("NotoSans", color, size, fontWeight);
  }

  static TextStyle _textStyle(
      String fontFamily, Color color, double size, FontWeight fontWeight) {
    return TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontSize: size,
        fontWeight: fontWeight);
  }
}
