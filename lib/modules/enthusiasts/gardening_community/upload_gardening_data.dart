import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:greenland/core/constants/my_constants.dart';
import 'package:greenland/core/themes/my_colors.dart';
import 'package:greenland/core/utilities/utils.dart';
import 'package:greenland/model/gardening_model.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/helpers/my_helper.dart';
import '../../../core/themes/my_textstyles.dart';
import '../../../core/utilities/textfield_wrapper.dart';
import '../../../core/widgets/my_buttons.dart';
import '../../farmers/contact_experts/contact_expert_controller.dart';

class UploadGardeningData extends StatefulWidget {
  const UploadGardeningData({super.key});

  @override
  State<UploadGardeningData> createState() => _UploadGardeningDataState();
}

class _UploadGardeningDataState extends State<UploadGardeningData> {
  File? image;

  final descCntrl = TextEditingController();

  submit() async {
    if (descCntrl.text.trim() == '' || image == null) {
      Utils.showAlert(
        'Oops!',
        'please make sure you\'ve added image and description about your gardening.',
      );
      return;
    }

    final id = MyHelper.genDateId;
    final imageUrl = await ContactExpertController.uploadImageFile(image!, id);
    if (imageUrl == null) {
      Utils.showSnackBar('couldn\'t upload image', status: false);
      return;
    }

    final newData = GardeningModel(
      id: id,
      message: descCntrl.text.trim(),
      image: imageUrl,
      senderId: auth.currentUser!.uid,
      createdAt: Timestamp.now(),
    );

    try {
      fire.collection('gardening_community').doc(id).set(newData.toMap());

      Get.back();
      Utils.showSnackBar('posted successful!', status: true);
    } catch (e) {
      Utils.normalDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Upload your Gardening Progress')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// --------------------------------------- `image picker widget`
              if (image == null)
                InkWell(
                  onTap: pickImage,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: size.width * 0.5 - 40,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: MyColors.primary(50),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: MyColors.primary(150)),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add_a_photo),
                          SizedBox(height: 10),
                          Text('capture image'),
                        ],
                      ),
                    ),
                  ),
                ),
              if (image != null)
                Container(
                  height: size.width * 0.5 - 40,
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: MyColors.primary(50),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: MyColors.primary(100)),
                  ),
                  child: Stack(
                    children: [
                      SizedBox.expand(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(image!, fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: MyCloseBtn(
                            ontap: () => setState(() => image = null)),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),

              /// ------------------------------------------------------- `description`
              TextFieldWrapper(
                TextField(
                  maxLines: null,
                  controller: descCntrl,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'description',
                    hintStyle: MyTStyles.kTS15Medium,
                  ),
                ),
              ),

              /// ------------------------------------------------------- `upload button`
              SizedBox(
                width: double.infinity,
                child: MyOutlinedBtn('Upload new Post', submit, radius: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// --------------------------------------- `pick IMAGE`
  pickImage() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.camera);

      if (img == null) {
        Utils.showSnackBar('you didn\'t choose image');
        return;
      }

      setState(() {
        image = File(img.path);
      });
    } on PlatformException {
      Utils.showSnackBar('Oops, failed to capture image');
    }
  }
}
