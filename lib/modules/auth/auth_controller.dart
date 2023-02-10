import 'dart:developer';

import 'package:greenland/core/constants/pref_keys.dart';
import 'package:greenland/modules/auth/signin_screen.dart';
import 'package:greenland/core/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/constants/my_constants.dart';
import '../home/home_screen.dart';

class AuthController extends GetxController {
  //
  final _box = GetStorage();

  bool get isUserPresent => _box.read<bool>(MyIAKeys.userStatus) ?? false;

  signInWithGoogle() async {
    try {
      /// `Trigger` the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      /// get the authentication details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      /// create a new `credential`
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      Utils.progressIndctr(label: 'loading...');

      /// once signed-in extract `UserCredentials`
      final userCredential = await auth.signInWithCredential(credential);

      /// if user `couldn't` login
      if (userCredential.user == null) {
        Utils.normalDialog();
        return;
      }

      _box.write(MyIAKeys.userStatus, true);

      Get.offAll(() => const HomeScreen());
      Utils.showSnackBar('Login Successful!', status: true);
      //
    } on FirebaseAuthException catch (e) {
      Get.back();
      Utils.showAlert('Oops', e.message.toString());
    } catch (e) {
      Get.back();

      if (e.toString() == 'Null check operator used on a null value') {
        Utils.showSnackBar('Please select your email to proceed');
      } else {
        Utils.showAlert('Oops', e.toString());
      }
    }
  }

  logout() async {
    try {
      //
      await GoogleSignIn().signOut();
      _box.write(MyIAKeys.userStatus, false);
      Get.offAll(() => SigninScreen());
      //
    } catch (e) {
      log('=================== couldn\'t logout ==================');
    }
  }
}
