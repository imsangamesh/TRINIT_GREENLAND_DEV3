import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerExpertChatModel {
  final String id, message, reply, image, senderId;
  final Timestamp createdAt;

  FarmerExpertChatModel({
    required this.id,
    required this.message,
    required this.image,
    required this.senderId,
    required this.reply,
    required this.createdAt,
  });

  toMap() => {
        'id': id,
        'message': message,
        'image': image,
        'senderId': senderId,
        'createdAt': createdAt,
        'reply': reply,
      };

  static FarmerExpertChatModel fromMap(Map<String, dynamic> map) {
    return FarmerExpertChatModel(
      id: map['id'],
      message: map['message'],
      image: map['image'],
      senderId: map['senderId'],
      createdAt: map['createdAt'],
      reply: map['reply'],
    );
  }
}
