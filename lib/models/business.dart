import 'dart:developer';

import 'package:logger/logger.dart';

var log = Logger();

class Business {
  final String id;
  final String ownerId;
  final String name;
  final String phoneNumber;
  final String type;
  final double lat;
  final double lng;
  final String description;
  final String imageUrl;
  final double rating;
  final int deliveryCharges;
  final String locationDescription;

  Business({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.phoneNumber,
    required this.type,
    required this.lat,
    required this.lng,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.deliveryCharges,
    required this.locationDescription,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    // log.d(json);
    return Business(
      id: json['_id'] ?? "1234555",
      ownerId: json['user'] ?? "default user id",
      name: json['name'] ?? "default",
      phoneNumber:
          "phoneNumber", // hardcoded for now, to be changed when backend is fixed
      type: json['type'] ?? "default",
      lat: json['location']['coordinates'][0].toDouble() ??
          1.0, // hardcoded for now, to be changed when backend is fixed
      lng: json['location']['coordinates'][1].toDouble() ??
          1.0, // hardcoded for now, to be changed when backend is fixed
      description: json['description'] ?? "default",
      imageUrl: json["image"] ??
          "https://balti-files.s3.ap-northeast-1.amazonaws.com/burger.jpg", // hardcoded for now, to be changed when backend is fixed
      rating: json['overallRating'].toDouble() ?? "default",
      deliveryCharges: json['delivery_charges'] ?? 0,
      locationDescription: "locationDesc",
    );
  }
}
