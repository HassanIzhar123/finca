import 'package:finca/enums/sowing_enum.dart';

class Crop {
  String cropName;
  List<String> varieties;
  String scientificName;
  DateTime seedTime;
  SowingEnum sowing;

  Crop(this.cropName, this.varieties, this.scientificName, this.seedTime, this.sowing);

  Map<String, dynamic> toJson() {
    return {
      'cropName': cropName,
      'varieties': varieties,
      'scientificName': scientificName,
      'seedTime': seedTime,
      'sowing': sowing.toString(),
    };
  }
}
