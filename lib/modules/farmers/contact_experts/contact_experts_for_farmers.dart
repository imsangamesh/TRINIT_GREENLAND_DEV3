import 'package:flutter/material.dart';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:greenland/core/themes/my_textstyles.dart';
import 'package:greenland/model/farmer_expert_model.dart';
import 'package:greenland/modules/farmers/contact_experts/contact_expert_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:greenland/core/helpers/my_helper.dart';
import 'package:greenland/core/themes/my_colors.dart';

import '../../../core/utilities/textfield_wrapper.dart';
import '../../../core/utilities/utils.dart';
import '../../../core/widgets/my_buttons.dart';
import 'location_services.dart';

class ContactExpertsForFarmers extends StatefulWidget {
  const ContactExpertsForFarmers({super.key});

  @override
  State<ContactExpertsForFarmers> createState() =>
      _ContactExpertsForFarmersState();
}

class _ContactExpertsForFarmersState extends State<ContactExpertsForFarmers> {
  //
  File? image;
  double? lat, long;
  FarmerExpertAppointmentModel? place;
  final fetching = false.obs;

  final nameCntrl = TextEditingController();
  final descCntrl = TextEditingController();
  final landDescCntrl = TextEditingController();

  final soilType = FarmSoilType.notEntered.obs;

  @override
  initState() {
    getLocation();

    super.initState();
  }

  primary(int a) => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(a)
      : MyColors.pink.withAlpha(a);

  submit() async {
    if (lat == null || long == null) {
      Utils.showAlert(
        'Oops!',
        'please make sure you\'ve selected your location before submitting.',
      );
      return;
    }

    if (soilType() == FarmSoilType.notEntered) {
      Utils.showAlert(
        'Oops!',
        'please select a particular soil type of your farm.',
      );
      return;
    }

    if (nameCntrl.text.trim() == '' || landDescCntrl.text.trim() == '') {
      Utils.showAlert(
        'Oops!',
        'please make sure you\'ve added the name and land information.',
      );
      return;
    }

    final id = MyHelper.genDateId;
    final imageUrl = await ContactExpertController.uploadImageFile(image!, id);
    if (imageUrl == null) {
      Utils.showSnackBar('couldn\'t upload image', status: false);
      return;
    }

    final appointment = FarmerExpertAppointmentModel(
      id: id,
      name: place!.name,
      city: place!.city,
      farmSoilType: soilType(),
      postCode: place!.postCode,
      lat: lat!,
      long: long!,
      date: DateTime.now().toIso8601String(),
      createdAt: Timestamp.now(),
      isVerified: 'false',
    );

    ContactExpertController.updateFarmerAppointmentToFire(appointment);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Upload New Pothole')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              if (fetching())
                const Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: LinearProgressIndicator(minHeight: 2),
                ),
              Row(
                children: [
                  /// ------------------------------------------------------- `image-picker card`
                  Expanded(child: imagePickerCard(size)),
                  const SizedBox(width: 15),

                  /// ------------------------------------------------------- `location card`
                  Expanded(
                    child: InkWell(
                      onTap: () => getLocation(),
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: size.width * 0.5 - 40,
                        decoration: BoxDecoration(
                          color: primary(50),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: primary(150)),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on_rounded),
                              const SizedBox(height: 5),
                              Text(
                                lat == null || long == null
                                    ? 'grant location\npermission'
                                    : 'location fetched!',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              MyOutlinedBtn(
                                'View in Map',
                                lat == null || long == null
                                    ? null
                                    : () => LocationServices.openGoogleMap(
                                        lat!, long!),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// ------------------------------------------------------- `location info`
              if (place != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '  Your location:',
                      style: MyTStyles.kTS14Regular,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 15),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: primary(25),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            labelText('Name', place!.name),
                            labelText('Postal-code', place!.postCode),
                            labelText('City', place!.city),
                            labelText(
                                'Latitude', place!.lat.toStringAsFixed(2)),
                            labelText(
                                'Longitude', place!.long.toStringAsFixed(2)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

              /// ------------------------------------------------------- `name`
              TextFieldWrapper(
                TextField(
                  controller: nameCntrl,
                  maxLines: 1,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'your name',
                    hintStyle: MyTStyles.kTS15Medium,
                  ),
                ),
              ),

              /// ------------------------------------------------------- `field information`
              TextFieldWrapper(
                TextField(
                  controller: landDescCntrl,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'land in acres',
                    hintStyle: MyTStyles.kTS15Medium,
                  ),
                ),
              ),

              /// ------------------------------------------------------- `description`
              TextFieldWrapper(
                TextField(
                  controller: descCntrl,
                  maxLines: 4,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'family description, (eg: income)',
                    hintStyle: MyTStyles.kTS15Medium,
                  ),
                ),
              ),

              /// ------------------------------------------------------- `crop type dropdown`
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 15, right: 10),
                    decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? MyColors.darkPurple
                          : MyColors.lightPink,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Obx(
                      () => DropdownButton<FarmSoilType>(
                        underline: const Divider(color: Colors.transparent),
                        value: soilType.value,
                        items: FarmSoilType.values
                            .map((FarmSoilType ech) => DropdownMenuItem(
                                  value: ech,
                                  child: Text(
                                    FarmerExpertAppointmentModel
                                        .soilTypeToString(ech),
                                  ),
                                ))
                            .toList(),
                        onChanged: (FarmSoilType? newValue) =>
                            soilType(newValue),
                      ),
                    ),
                  ),
                  MyOutlinedBtn(
                    'Fetch Location',
                    getLocation,
                    radius: 10,
                  ),
                ],
              ),
              const SizedBox(height: 15),

              /// ------------------------------------------------------- `upload button`
              SizedBox(
                width: double.infinity,
                child: MyOutlinedBtn('Place Appointment', submit, radius: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// --------------------------------------- `get LOCATION and ADDRESS`
  getLocation() async {
    fetching(true);

    await LocationServices.getCurrentLocation().then((value) async {
      if (value != null || value!.isNotEmpty) {
        setState(() {
          lat = value[0];
          long = value[1];
          place = value[2];
        });
      }
    });

    fetching(false);
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

  labelText(String title, String subtitle) {
    return RichText(
      text: TextSpan(
        text: '$title: ',
        style: MyTStyles.kTS13Medium.copyWith(
          color: Get.isDarkMode ? const Color(0xFFDBDBDB) : MyColors.black,
          height: 1.2,
        ),
        children: [TextSpan(text: subtitle, style: MyTStyles.kTS13Regular)],
      ),
    );
  }

  /// --------------------------------------- `image picker widget`
  Widget imagePickerCard(Size size) {
    if (image == null) {
      return InkWell(
        onTap: pickImage,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: size.width * 0.5 - 40,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: primary(50),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: primary(150)),
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
      );
    } else {
      return Container(
        height: size.width * 0.5 - 40,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: primary(50),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: primary(100)),
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
              child: MyCloseBtn(ontap: () => setState(() => image = null)),
            ),
          ],
        ),
      );
    }
  }
}
