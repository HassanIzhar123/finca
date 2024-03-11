import 'dart:developer' as logger;
import 'dart:io';
import 'dart:math';

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

  Future<bool> checkIfInternetIsAvailable() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        logger.log('wifi connected');
        return true;
      }
    } on SocketException catch (_) {
      logger.log('wifi not connected');
      return false;
    }
    return false;
  }

  DateTime generateRandomDateWithinCurrentMonth() {
    // Get the current date
    DateTime now = DateTime.now();

    // Get the first day of the current month
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);

    // Get the last day of the current month
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    // Get the number of days in the current month
    int daysInMonth = lastDayOfMonth.day;

    // Create a Random object
    Random random = Random();

    // Generate a random day within the current month
    int randomDay = firstDayOfMonth.day + random.nextInt(daysInMonth - firstDayOfMonth.day + 1);

    // Create a random DateTime object
    DateTime randomDateTime = DateTime(now.year, now.month, randomDay);

    return randomDateTime;
  }
}
