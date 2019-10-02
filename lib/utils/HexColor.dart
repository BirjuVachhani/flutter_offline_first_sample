import 'package:flutter/material.dart';

/*
* A Dart Utility class for Using Hex color string in Flutter
* Examples:
* color: HexColor("#ff4433")
* color: HexColor("ff4433")
* color: HexColor("#80ff4433")
* */
class HexColor extends Color {
  HexColor(String hexString) : super(_parseColor(hexString));

  static int _parseColor(String color) {
    try {
      color = color.toUpperCase().replaceAll("#", "");
      if (color.length == 6) {
        color = "FF" + color;
      }
    } on Exception catch (e) {
      return Colors.white.value;
    }
    return int.parse(color, radix: 16);
  }
}
