class FarmModel {
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
      farmName: json['farmName'],
      size: json['size'],
      description: json['description'],
      location: json['location'],
      crops: List<String>.from(json['crops']),
      soilStudy: json['soilStudy'],
      soilStudyDate: DateTime.parse(json['soilStudyDate']),
      soilStudyLink: List<String>.from(json['selectPdfFile']),
      agriculturalCertification: json['agriculturalCertification'],
      agriculturalCertificationDate:
          DateTime.parse(json['agriculturalCertificationDate']),
    );
  }
}
