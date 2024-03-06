import 'package:finca/enums/sowing_enum.dart';

class Crop {
  String cropId;
  String cropName;
  List<String> varieties;
  String scientificName;
  DateTime seedTime;
  SowingEnum sowing;

  Crop(this.cropId, this.cropName, this.varieties, this.scientificName,
      this.seedTime, this.sowing);

  Map<String, dynamic> toJson() {
    return {
      'cropId': cropId,
      'cropName': cropName,
      'varieties': varieties,
      'scientificName': scientificName,
      'seedTime': seedTime,
      'sowing': sowing.name,
    };
  }

  //frmJson
  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      json['cropId'],
      json['cropName'],
      List<String>.from(json['varieties']),
      json['scientificName'],
      json['seedTime'].toDate(),
      SowingEnum.values.firstWhere((element) => element.name == json['sowing']),
    );
  }
}
