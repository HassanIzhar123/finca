import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FarmModel {
  final String farmId;
  final String farmName;
  final String soilType;
  final double size;
  final String description;
  final List<Map<String, dynamic>> location;
  final String cropId;
  Crop? crop;
  final String soilStudy;
  final DateTime soilStudyDate;
  final List<String> soilStudyLink;
  final String agriculturalCertification;
  final DateTime agriculturalCertificationDate;
  DateTime? createdAt;
  DateTime? updatedAt;

  FarmModel({
    required this.farmId,
    required this.farmName,
    required this.size,
    required this.soilType,
    required this.description,
    required this.location,
    required this.cropId,
    this.crop,
    required this.soilStudy,
    required this.soilStudyDate,
    required this.soilStudyLink,
    required this.agriculturalCertification,
    required this.agriculturalCertificationDate,
    this.createdAt,
    this.updatedAt,
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
      soilType: '',
      description: '',
      location: [],
      crop: Crop.empty(),
      cropId: '',
      soilStudy: '',
      soilStudyDate: DateTime.now(),
      soilStudyLink: [],
      agriculturalCertification: '',
      agriculturalCertificationDate: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    final locationList = location.map((e) => e).toList();
    return {
      'farmId': farmId,
      'farmName': farmName,
      'size': size,
      'soilType': soilType,
      'description': description,
      'location': locationList,
      'cropId': cropId,
      'soilStudy': soilStudy,
      'soilStudyDate': soilStudyDate.toIso8601String(),
      'soilStudyLink': soilStudyLink,
      'agriculturalCertification': agriculturalCertification,
      'agriculturalCertificationDate': agriculturalCertificationDate.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory FarmModel.fromJson(Map<String, dynamic> json) {
    return FarmModel(
      farmId: json["farmId"],
      farmName: json["farmName"],
      size: json["size"],
      soilType: json["soilType"],
      description: json["description"],
      location: List<Map<String, dynamic>>.from(json["location"]),
      cropId: json["cropId"],
      soilStudy: json["soilStudy"],
      soilStudyDate: DateTime.parse(json["soilStudyDate"]),
      soilStudyLink: List<String>.from(json["soilStudyLink"]),
      agriculturalCertification: json["agriculturalCertification"],
      agriculturalCertificationDate: DateTime.parse(json["agriculturalCertificationDate"]),
      createdAt: DateTime.parse(json["createdAt"] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json["updatedAt"] ?? DateTime.now().toString()),
    );
  }
}
