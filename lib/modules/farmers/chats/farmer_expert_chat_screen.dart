import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:greenland/core/constants/my_constants.dart';
import 'package:greenland/core/helpers/my_helper.dart';
import 'package:greenland/core/themes/my_colors.dart';
import 'package:greenland/core/themes/my_textstyles.dart';
import 'package:greenland/core/utilities/utils.dart';
import 'package:greenland/model/farmer_expert_chat_model.dart';

class FarmerExpertChatScreen extends StatefulWidget {
  const FarmerExpertChatScreen({Key? key}) : super(key: key);

  @override
  State<FarmerExpertChatScreen> createState() => _FarmerExpertChatScreenState();
}

class _FarmerExpertChatScreenState extends State<FarmerExpertChatScreen> {
  TextEditingController msgController = TextEditingController();

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    String msg = msgController.text.trim();
    if (msg == '') {
      Utils.showSnackBar('enter message', status: false);
      return;
    }

    FarmerExpertChatModel newMessage = FarmerExpertChatModel(
      createdAt: Timestamp.now(),
      id: MyHelper.genDateId,
      image: auth.currentUser!.photoURL ?? MyHelper.profilePic,
      message: msg,
      senderId: auth.currentUser!.uid,
      reply: '',
    );

    try {
      fire
          .collection('chats')
          .doc('farmer_expert_chats')
          .collection('farmer_expert_chats')
          .doc(
              '${auth.currentUser!.uid} || ${DateTime.now().toIso8601String()}')
          .set(newMessage.toMap());

      msgController.clear();
    } catch (e) {
      Utils.normalDialog();
    }
  }

  void showCallConfirmDialog() {
    FocusScope.of(context).unfocus();
    Utils.confirmDialogBox(
      'Alert!',
      'Hey, do you want to place a call with our expert?',
      yesFun: () => showBottomSheet(context),
    );
  }

  showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              ListTile(
                onTap: () => FlutterPhoneDirectCaller.callNumber('8867634725'),
                title: const Text('Sangamesh'),
                subtitle: Text(
                  'agriculture expert',
                  style: MyTStyles.kTS12Regular.copyWith(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 15),
              ListTile(
                onTap: () => FlutterPhoneDirectCaller.callNumber('9591219026'),
                title: const Text('Rashmi Hiremath'),
                subtitle: Text(
                  'agriculture expert',
                  style: MyTStyles.kTS12Regular.copyWith(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 15),
              ListTile(
                onTap: () => FlutterPhoneDirectCaller.callNumber('9632638925'),
                title: const Text('Kaveri'),
                subtitle: Text(
                  'horticulture expert',
                  style: MyTStyles.kTS12Regular.copyWith(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Chats with Experts'),
        actions: [
          IconButton(
            onPressed: () {
              showCallConfirmDialog();
            },
            icon: const Icon(
              Icons.phone_in_talk_rounded,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc('farmer_expert_chats')
                  .collection('farmer_expert_chats')
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (context, snapshot) {
                final dataSnap = snapshot.data;

                if (snapshot.connectionState == ConnectionState.waiting ||
                    dataSnap == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  itemCount: dataSnap.docs.length,
                  itemBuilder: (context, index) {
                    final recMsgData = dataSnap.docs[index].data();

                    return messageTile(recMsgData, context);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 1),
          Container(
            decoration: BoxDecoration(
              color: Get.isDarkMode ? MyColors.darkPurple : MyColors.lightPink,
            ),
            padding: const EdgeInsets.only(
              right: 10,
              left: 10,
              bottom: 4,
              top: 3,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msgController,
                    decoration: const InputDecoration(
                      hintText: 'message',
                    ),
                    maxLines: null,
                  ),
                ),
                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget messageTile(Map<String, dynamic> recMsgData, BuildContext context) {
    return Row(
      mainAxisAlignment: recMsgData['senderId'] == auth.currentUser!.uid
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        if (recMsgData['senderId'] == auth.currentUser!.uid)
          const SizedBox(width: 90),
        Flexible(
            child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 10,
          ),
          margin: const EdgeInsets.only(
            bottom: 2.9,
            left: 11,
            right: 11,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: recMsgData['senderId'] == auth.currentUser!.uid
                ? MyColors.purple.withAlpha(100)
                : Theme.of(context).colorScheme.secondary.withAlpha(120),
          ),
          child: Text(
            recMsgData['message'],
            softWrap: true,
            style: const TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          // ),
        )),
        if (recMsgData['senderId'] != auth.currentUser!.uid)
          const SizedBox(width: 90),
      ],
    );
  }
}
