import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenland/core/helpers/my_helper.dart';
import 'package:greenland/core/utilities/utils.dart';

import '../../../core/constants/my_constants.dart';
import '../../../core/themes/my_colors.dart';
import '../../../core/themes/my_textstyles.dart';
import '../../main.dart';
import '../../modules/auth/auth_controller.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final authController = Get.put(AuthController());

  String get name => auth.currentUser!.displayName ?? 'Guest User';

  String get email => auth.currentUser!.email ?? '';

  String get imageUrl => auth.currentUser!.photoURL ?? MyHelper.profilePic;

  primary() => isDark.value ? MyColors.lightPurple : MyColors.pink;

  primaryWithAlpha(int a) => isDark.value
      ? MyColors.lightPurple.withAlpha(a)
      : MyColors.pink.withAlpha(a);

  final isDark = Get.isDarkMode.obs;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Drawer(
      child: Obx(
        () => SizedBox(
          height: size.height,
          width: size.width * 0.6,
          child: Column(
            children: [
              AppBar(
                leading: const SizedBox(),
                title: const Text('it\'s all ME'),
              ),
              // --------------------------------------------------- profile
              const SizedBox(height: 25),
              CircleAvatar(
                radius: 50,
                backgroundColor: primaryWithAlpha(60),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      width: 7,
                      color: primaryWithAlpha(100),
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 35,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(imageUrl),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // ----------------------- name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  name,
                  style: MyTStyles.kTS18Medium.copyWith(
                      color: isDark.value ? MyColors.wheat : MyColors.darkPink),
                  textAlign: TextAlign.center,
                ),
              ),
              // ----------------------- email
              Text(
                email,
                overflow: TextOverflow.clip,
                maxLines: 1,
                style: GoogleFonts.quicksand(
                  textStyle: MyTStyles.kTS12Regular.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark.value ? MyColors.wheat : MyColors.darkPink,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // --------------------------------------------------------- change theme
              Container(
                height: 45,
                decoration: BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(
                    width: 0,
                    color: primaryWithAlpha(100),
                  )),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: primaryWithAlpha(100),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ----------------------- day
                              Icon(
                                isDark.value
                                    ? Icons.light_mode_outlined
                                    : Icons.light_mode_rounded,
                                size: 25,
                                color: isDark.value
                                    ? Colors.grey
                                    : MyColors.darkPink,
                              ),
                              // ----------------------- switch
                              CupertinoSwitch(
                                thumbColor: primary(),
                                activeColor: MyColors.emerald,
                                value: isDark.value,
                                onChanged: (newVal) {
                                  globalThemeContrl.toggleThemeMode();
                                  isDark(newVal);
                                },
                              ),
                              // ----------------------- night
                              Icon(
                                isDark.value
                                    ? Icons.nights_stay
                                    : Icons.nights_stay_outlined,
                                size: 25,
                                color:
                                    isDark.value ? MyColors.wheat : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // ------------------------------- label-text
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryWithAlpha(100), Colors.transparent],
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              isDark.value ? 'it\'s Dark!' : 'rise & shine!',
                              style:
                                  MyTStyles.splHeading.copyWith(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // --------------------------------------------------------- logout
              InkWell(
                onTap: () => Utils.confirmDialogBox(
                  'Wanna Logout?',
                  'Hey you\'d have stayed a little longer and written some more journals...',
                  yesFun: authController.logout,
                ),
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(color: primaryWithAlpha(100)),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.power_settings_new_rounded,
                        color: MyColors.darkPink,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'logout',
                        style: MyTStyles.splHeading.copyWith(
                          fontSize: 18,
                          color: MyColors.darkPink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
