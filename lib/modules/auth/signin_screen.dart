import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenland/core/constants/my_images.dart';
import 'package:greenland/core/constants/pref_keys.dart';
import 'package:greenland/core/themes/my_colors.dart';
import 'package:greenland/core/themes/my_textstyles.dart';
import 'package:greenland/core/widgets/my_buttons.dart';
import 'package:greenland/modules/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({super.key});

  final _box = GetStorage();
  final authController = Get.find<AuthController>();

  final selected = 10.obs;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: MyColors.white,
      body: Column(children: [
        const SizedBox(height: 120),
        Text(
          'Start your Gardening today!',
          style: MyTStyles.splHeading.copyWith(
            color: Get.isDarkMode ? MyColors.purple : MyColors.interPink,
          ),
        ),
        Text('by securely signin with us',
            style: GoogleFonts.rubik(textStyle: MyTStyles.kTS13Medium)),
        SizedBox(
          height: size.height * 0.5,
          width: size.width,
          child: Image.asset(MyImages.login),
        ),
        const SizedBox(height: 20),
        Obx(
          () => MyOutlinedBtn(
            selected() == 10
                ? '       Please Select type       '
                : selected() == 0
                    ? 'selected as Farmer'
                    : 'selected as Gardener',
            () => showBottomSheet(context),
          ),
        ),
        Obx(
          () => ElevatedButton(
            onPressed: selected() == 10
                ? null
                : () => authController.signInWithGoogle(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8),
              textStyle: MyTStyles.kTS16Medium,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.account_circle, size: 30),
                SizedBox(width: 30),
                Text('Sign up with Google'),
                SizedBox(width: 50),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  showBottomSheet(BuildContext context) {
    final size = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    selected(0);
                    Get.back();
                    _box.write(MyIAKeys.userType, 'FARMER');
                  },
                  borderRadius: BorderRadius.circular(20),
                  splashColor: MyColors.primary(100),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: selected() == 0
                          ? MyColors.primary(100)
                          : MyColors.primary(40),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 2,
                        color: selected() == 0
                            ? MyColors.primary(255)
                            : Colors.transparent,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        padding: const EdgeInsets.only(top: 7, left: 10),
                        width: size.width * 0.4,
                        height: size.width * 0.4,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage('assets/farmer.jpg'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Signin as Farmer',
                          style: MyTStyles.splHeading.copyWith(
                            fontSize: 28,
                            color: MyColors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    selected(1);
                    Get.back();
                    _box.write(MyIAKeys.userType, 'GARDENER');
                  },
                  borderRadius: BorderRadius.circular(20),
                  splashColor: MyColors.primary(100),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: selected() == 1
                          ? MyColors.primary(100)
                          : MyColors.primary(40),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 2,
                        color: selected() == 1
                            ? MyColors.primary(255)
                            : Colors.transparent,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        padding: const EdgeInsets.only(top: 7, left: 10),
                        width: size.width * 0.4,
                        height: size.width * 0.4,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage('assets/garden.jpg'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Signin as Gardener',
                          style: MyTStyles.splHeading.copyWith(
                            fontSize: 28,
                            color: MyColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
