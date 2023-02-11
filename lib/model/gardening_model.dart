import 'package:cloud_firestore/cloud_firestore.dart';

class GardeningModel {
  final String id, message, image, senderId;
  final Timestamp createdAt;

  GardeningModel({
    required this.id,
    required this.message,
    required this.image,
    required this.senderId,
    required this.createdAt,
  });

  toMap() => {
        'id': id,
        'message': message,
        'image': image,
        'senderId': senderId,
        'createdAt': createdAt,
      };

  static GardeningModel fromMap(Map<String, dynamic> map) {
    return GardeningModel(
      id: map['id'],
      message: map['message'],
      image: map['image'],
      senderId: map['senderId'],
      createdAt: map['createdAt'],
    );
  }
}
