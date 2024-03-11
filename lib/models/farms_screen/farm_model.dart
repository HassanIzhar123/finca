import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FarmModel {
  final String farmId;
  final String farmName;
  final double size;
  final String description;
  final List<Map<String, dynamic>> location;
  final List<String> crops;
  final String soilStudy;
  final DateTime soilStudyDate;
  final List<String> soilStudyLink;
  final String agriculturalCertification;
  final DateTime agriculturalCertificationDate;
  DateTime? createdAt;

  FarmModel({
    required this.farmId,
    required this.farmName,
    required this.size,
    required this.description,
    required this.location,
    required this.crops,
    required this.soilStudy,
    required this.soilStudyDate,
    required this.soilStudyLink,
    required this.agriculturalCertification,
    required this.agriculturalCertificationDate,
    this.createdAt,
  });

//createdAt  and setter
  DateTime? get getCreatedAt => createdAt;

  set setCreatedAt(DateTime? value) {
    createdAt = value;
  }

  //empty
  factory FarmModel.empty() {
    return FarmModel(
      farmId: '',
      farmName: '',
      size: 0,
      description: '',
      location: [],
      crops: [],
      soilStudy: '',
      soilStudyDate: DateTime.now(),
      soilStudyLink: [],
      agriculturalCertification: '',
      agriculturalCertificationDate: DateTime.now(),
    );
  }

  // factory FarmModel.fromJson(Map<String, dynamic> json) {
  //   return FarmModel(
  //     farmId: json['farmId'],
  //     farmName: json['farmName'],
  //     size: json['size'],
  //     description: json['description'],
  //     location: json['location'] as List<Map<String, double>> ?? [],
  //     crops: List<String>.from(json['crops']),
  //     soilStudy: json['soilStudy'],
  //     soilStudyDate: (json['soilStudyDate'] as Timestamp).toDate(),
  //     soilStudyLink: List<String>.from(json['soilStudyLink']),
  //     agriculturalCertification: json['agriculturalCertification'],
  //     agriculturalCertificationDate: (json['agriculturalCertificationDate'] as Timestamp).toDate(),
  //   );
  // }

  Map<String, dynamic> toJson() {
    final locationList = location.map((e) => e).toList();
    return {
      'farmId': farmId,
      'farmName': farmName,
      'size': size,
      'description': description,
      'location': locationList,
      'crops': crops,
      'soilStudy': soilStudy,
      'soilStudyDate': soilStudyDate.toIso8601String(),
      'soilStudyLink': soilStudyLink,
      'agriculturalCertification': agriculturalCertification,
      'agriculturalCertificationDate': agriculturalCertificationDate.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory FarmModel.fromJson(Map<String, dynamic> json) {
    return FarmModel(
      farmId: json["farmId"],
      farmName: json["farmName"],
      size: json["size"],
      description: json["description"],
      location: List<Map<String, dynamic>>.from(json["location"]),
      crops: List<String>.from(json["crops"]),
      soilStudy: json["soilStudy"],
      soilStudyDate: DateTime.parse(json["soilStudyDate"]),
      soilStudyLink: List<String>.from(json["soilStudyLink"]),
      agriculturalCertification: json["agriculturalCertification"],
      agriculturalCertificationDate: DateTime.parse(json["agriculturalCertificationDate"]),
      createdAt: DateTime.parse(json["createdAt"] ?? DateTime.now().toString()),
    );
  }
}
