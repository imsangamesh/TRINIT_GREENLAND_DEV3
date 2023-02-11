import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:greenland/model/farmer_expert_model.dart';

import '../../../core/constants/my_constants.dart';
import '../../../core/utilities/utils.dart';

class ContactExpertController {
  //
  static Future<String?> uploadImageFile(File file, String id) async {
    try {
      Utils.progressIndctr(label: 'uploading...');
      TaskSnapshot taskSnapshot = await store
          .ref()
          .child('farmers_experts_contact')
          .child(id)
          .putFile(file);

      Get.back();
      return await taskSnapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      Get.back();
      Utils.showAlert(e.code, e.message.toString());
    } catch (e) {
      Get.back();
      Utils.normalDialog();
    }
    return null;
  }

  static updateFarmerAppointmentToFire(
      FarmerExpertAppointmentModel farmerExpertAppointmentModel) async {
    try {
      await fire
          .collection('farmers_experts_contact')
          .doc('userId: ${auth.currentUser!.uid}')
          .set(farmerExpertAppointmentModel.toMap());

      Get.back();
      Utils.showSnackBar('your appointment placed', status: true);
    } on FirebaseException catch (e) {
      Utils.showAlert(e.code, e.message.toString());
    } catch (e) {
      Utils.normalDialog();
      log(e.toString());
    }
  }
}
