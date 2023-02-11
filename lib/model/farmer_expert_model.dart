import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerExpertAppointmentModel {
  final String id, name, city, postCode;
  final double lat, long;
  final String date;
  final Timestamp createdAt;
  final String isVerified;
  final FarmSoilType farmSoilType;

  FarmerExpertAppointmentModel({
    required this.id,
    required this.name,
    required this.farmSoilType,
    required this.date,
    required this.lat,
    required this.long,
    required this.city,
    required this.postCode,
    required this.createdAt,
    required this.isVerified,
  });

  toMap() => {
        'id': id,
        'name': name,
        'city': city,
        'postCode': postCode,
        'date': date,
        'lat': lat,
        'long': long,
        'createdAt': createdAt,
        'isVerified': isVerified,
        'farmSoilType': soilTypeToString(farmSoilType),
      };

  static FarmerExpertAppointmentModel fromMap(Map<String, dynamic> map) {
    return FarmerExpertAppointmentModel(
      id: map['id'],
      name: map['name'],
      city: map['city'],
      postCode: map['postCode'],
      date: map['date'],
      lat: map['lat'],
      long: map['long'],
      createdAt: map['createdAt'],
      isVerified: map['isVerified'],
      farmSoilType: map['farmSoilType'],
    );
  }

  static soilTypeToString(FarmSoilType soilType) {
    switch (soilType) {
      case FarmSoilType.alluvial:
        return 'alluvial';
      case FarmSoilType.black:
        return 'black';
      case FarmSoilType.desert:
        return 'desert';
      case FarmSoilType.latrite:
        return 'latrite';
      case FarmSoilType.red:
        return 'red';
      case FarmSoilType.loamy:
        return 'loamy';
      case FarmSoilType.clay:
        return 'clay';
      case FarmSoilType.sandy:
        return 'sandy';
      default:
        return 'select soil type';
    }
  }
}

enum FarmSoilType {
  notEntered,
  alluvial,
  black,
  red,
  latrite,
  desert,
  loamy,
  clay,
  sandy,
}
