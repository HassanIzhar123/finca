import 'package:finca/enums/sowing_enum.dart';

class Crop {
  String cropId;
  String farmName;
  List<String> cropNames;
  List<String> varieties;
  DateTime seedTime;
  SowingEnum sowing;
  String farmCoordinatesImage;

  Crop(this.cropId, this.farmName, this.farmCoordinatesImage, this.cropNames, this.varieties, this.seedTime, this.sowing);

  Map<String, dynamic> toJson() {
    return {
      'cropId': cropId,
      'farmName': farmName,
      'farmCoordinatesImage': farmCoordinatesImage,
      'cropNames': cropNames,
      'varieties': varieties,
      'seedTime': seedTime,
      'sowing': sowing.name,
    };
  }

  //frmJson
  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      json['cropId'] ?? '',
      json['farmName'] ?? '',
      json['farmCoordinatesImage'] ?? '',
      List<String>.from(json['cropNames']) ?? [],
      List<String>.from(json['varieties']) ?? [],
      json['seedTime'].toDate(),
      SowingEnum.values.firstWhere((element) => element.name == json['sowing']),
    );
  }

  //empty
  factory Crop.empty() {
    return Crop(
      '',
      '',
      '',
      [],
      [],
      DateTime.now(),
      SowingEnum.sowing,
    );
  }
}
