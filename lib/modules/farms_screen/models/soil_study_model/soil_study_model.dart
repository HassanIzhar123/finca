import 'package:hive/hive.dart';

part 'soil_study_model.g.dart';

@HiveType(typeId: 0)
class SoilStudyModel extends HiveObject {
  @HiveField(0)
  String uid;

  @HiveField(1)
  String id;

  @HiveField(2)
  String path;

  SoilStudyModel({required this.uid, required this.id, required this.path});

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'farmId': id,
      'path': path,
    };
  }
}
