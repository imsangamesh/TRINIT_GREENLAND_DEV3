import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:greenland/core/constants/pref_keys.dart';

import 'my_colors.dart';

class ThemeController extends GetxController {
  //
  final _box = GetStorage();

  final primary = Get.isDarkMode ? MyColors.lightPurple.obs : MyColors.pink.obs;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  bool get _isDarkMode => _box.read(MyIAKeys.isDarkMode) ?? false;

  configureTheme() {
    final isDark = _box.read(MyIAKeys.isDarkMode) ?? false;

    if (isDark) {
      primary(MyColors.lightPurple);
    } else {
      primary(MyColors.pink);
    }
  }

  toggleThemeMode() {
    if (Get.isDarkMode) {
      /// ------------------------------- `LIGHT`
      Get.changeThemeMode(ThemeMode.light);
      _box.write(MyIAKeys.isDarkMode, false);
      primary(MyColors.pink);
    } else {
      /// ------------------------------- `DARK`
      Get.changeThemeMode(ThemeMode.dark);
      _box.write(MyIAKeys.isDarkMode, true);
      primary(MyColors.lightPurple);
    }
  }
}
