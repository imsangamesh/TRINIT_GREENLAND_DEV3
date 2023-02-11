import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:greenland/core/constants/pref_keys.dart';
import 'package:greenland/core/widgets/my_drawer.dart';
import 'package:greenland/modules/auth/signin_screen.dart';
import 'package:greenland/modules/farmers/farmers_intro_page.dart';

import '../enthusiasts/enthusiasts_intro_page.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final currIndex = 0.obs;
  final _box = GetStorage();

  final pages = [
    FarmersIntroPage(),
    EnthusiastsIntroPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text(_box.read(MyIAKeys.userType) == 'FARMER'
            ? 'Farmers'
            : 'Enthusiasts'),
      ),
      body: _box.read(MyIAKeys.userType) == 'FARMER'
          ? FarmersIntroPage()
          : _box.read(MyIAKeys.userType) == 'GARDENER'
              ? EnthusiastsIntroPage()
              : SigninScreen(),
    );
  }
}
