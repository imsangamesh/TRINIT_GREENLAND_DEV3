import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenland/core/themes/my_textstyles.dart';
import 'package:intl/intl.dart';

class GardeningDetails extends StatelessWidget {
  const GardeningDetails(this.image, this.desc, this.date, {super.key});

  final String image, desc;
  final Timestamp date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Description')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(image),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Text(
                    'Uploaded on: ',
                    style: MyTStyles.kTS14Medium,
                  ),
                  Text(
                    DateFormat('hh:mm a  |  dd MMMM yyyy').format(
                        DateTime.fromMicrosecondsSinceEpoch(
                            date.microsecondsSinceEpoch)),
                    style: MyTStyles.kTS14Regular,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('Description:', style: MyTStyles.kTS15Medium),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(desc),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
