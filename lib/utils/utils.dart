import 'package:google_maps_flutter/google_maps_flutter.dart';

class Utils {
  List<List<Map<String, double>>> convertPolygonsIntoMap(_polygons) {
    List<List<Map<String, double>>> polygonDataList = [];
    for (Polygon polygon in _polygons) {
      List<Map<String, double>> points = [];
      for (LatLng point in polygon.points) {
        points.add({'latitude': point.latitude, 'longitude': point.longitude});
      }
      polygonDataList.add(points);
    }
    return polygonDataList;
  }
  String getImageExtension(String imagePath) {
    final dotIndex = imagePath.lastIndexOf('.');
    if (dotIndex != -1 && dotIndex < imagePath.length - 1) {
      final extension = imagePath.substring(dotIndex);
      return extension;
    }
    return '';
  }
}
