class FarmModel {
  final String title;
  final String description;
  final String location;
  final String image;
  final String soilStudy;
  final DateTime soilStudyDate;
  final List<String> selectPdfFile;
  final String certificate;
  final DateTime certificateDate;

  FarmModel({
    required this.title,
    required this.description,
    required this.location,
    required this.image,
    required this.soilStudy,
    required this.soilStudyDate,
    required this.selectPdfFile,
    required this.certificate,
    required this.certificateDate,
  });
}
