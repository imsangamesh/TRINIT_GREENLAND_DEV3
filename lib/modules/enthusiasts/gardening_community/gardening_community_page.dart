import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenland/core/constants/my_constants.dart';
import 'package:greenland/core/themes/my_colors.dart';
import 'package:greenland/core/utilities/utils.dart';
import 'package:greenland/modules/enthusiasts/gardening_community/gardening_details.dart';
import 'package:greenland/modules/enthusiasts/gardening_community/upload_gardening_data.dart';

class GardeningCommunityPage extends StatelessWidget {
  const GardeningCommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Gardening Community')),
      body: StreamBuilder(
        stream: fire
            .collection('gardening_community')
            .orderBy('createdAt')
            .snapshots(),
        builder: (context, snapshot) {
          final dataSnap = snapshot.data;

          if (snapshot.connectionState == ConnectionState.waiting ||
              dataSnap == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (dataSnap.docs.isEmpty) {
            return Utils.emptyList('no uploads for now');
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: dataSnap.docs.length,
            itemBuilder: (context, index) {
              final data = dataSnap.docs[index].data();

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () => Get.to(
                    () => GardeningDetails(
                      data['image'],
                      data['message'],
                      data['createdAt'],
                    ),
                  ),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyColors.primary(50),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: size.width * 0.5,
                              width: size.width,
                              child: Image.network(data['image'],
                                  fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: MyColors.primary(30),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            margin: const EdgeInsets.all(1),
                            padding: const EdgeInsets.all(10),
                            child: Text(data['message']),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const UploadGardeningData()),
        label: const Text('Upload'),
      ),
    );
  }
}
