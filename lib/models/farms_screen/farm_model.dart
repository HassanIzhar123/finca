import 'package:cloud_firestore/cloud_firestore.dart';

class FarmModel {
  final String farmId;
  final String farmName;
  final double size;
  final String description;
  final String location;
  final List<String> crops;
  final String soilStudy;
  final DateTime soilStudyDate;
  final List<String> soilStudyLink;
  final String agriculturalCertification;
  final DateTime agriculturalCertificationDate;

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
  });

  factory FarmModel.empty() => FarmModel(
        farmId: '',
        farmName: '',
        size: 0,
        description: '',
        location: '',
        crops: [],
        soilStudy: '',
        soilStudyDate: DateTime.now(),
        soilStudyLink: [],
        agriculturalCertification: '',
        agriculturalCertificationDate: DateTime.now(),
      );

  factory FarmModel.fromJson(Map<String, dynamic> json) {
    return FarmModel(
      farmId: json['farmId'],
      farmName: json['farmName'],
      size: json['size'],
      description: json['description'],
      location: json['location'] ?? '',
      crops: List<String>.from(json['crops']),
      soilStudy: json['soilStudy'],
      soilStudyDate: (json['soilStudyDate'] as Timestamp).toDate(),
      soilStudyLink: List<String>.from(json['soilStudyLink']),
      agriculturalCertification: json['agriculturalCertification'],
      agriculturalCertificationDate: (json['agriculturalCertificationDate'] as Timestamp).toDate(),
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'farmId': farmId,
      'farmName': farmName,
      'size': size,
      'description': description,
      'location': location,
      'crops': crops,
      'soilStudy': soilStudy,
      'soilStudyDate': soilStudyDate.toIso8601String(),
      'soilStudyLink': soilStudyLink,
      'agriculturalCertification': agriculturalCertification,
      'agriculturalCertificationDate': agriculturalCertificationDate.toIso8601String(),
    };
  }
}
