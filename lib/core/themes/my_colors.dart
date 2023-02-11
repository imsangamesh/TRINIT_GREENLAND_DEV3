import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyColors {
  static const white = Colors.white;
  static const black = Color(0xFF030723);
  static const green = Color(0xFF00FF08);
  static const grey = Color(0xFF9E9E9E);

  static const pink = Color(0xffFF8FB1);
  static const orangePink = Color(0xffFEBEB1);
  static const purple = Color(0xff7A4495);
  static const emerald = Color(0xff647E68);
  static const wheatGrey = Color(0xffDCD7C9);
  static const wheat = Color(0xffF2DEBA);

  /// ------------------------------------------------------ `light theme`
  static const lightScaffoldBG = Color(0xffFFF5E4);
  static const lightPink = Color(0xffffc6d7);
  static const lightListTile = Color(0xFFFFE2EA);

  /// ------------------------------------------------------ `dark theme`
  static const darkScaffoldBG = Color(0xFF03071B);
  static final darkListTile = const Color(0xffBA94D1).withAlpha(25);

  /// ------------------------------------------------------ `dark`
  static const darkPink = Color(0xffde004a);
  static const lightPurple = Color(0xffBA94D1);
  static final darkPurple = const Color(0xffBA94D1).withAlpha(25);

  // static const darkBlue = Color(0xffC060A1);
  // static const darkBlue = Color.fromARGB(255, 76, 46, 95);

  /// ------------------------------------------------------ `intermediate`
  static const interPink = Color(0xFFEC407A);

  static primary(int a) => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(a)
      : MyColors.pink.withAlpha(a);
}

// 1 playfairDisplay
// 1 berkshireSwash
// 2 quicksand
// 3 zillaSlab - M

// amatic sc
