import 'dart:developer' as logger;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:finca/main.dart';
import 'package:finca/modules/farms_screen/models/soil_study_model/soil_study_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';

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
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
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

  Future<File> writeImageDataToFile(Uint8List imageData, String pictureId, String extension) async {
    if (Platform.isAndroid) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/$pictureId.$extension';
      File imageFile = File(filePath);
      await imageFile.writeAsBytes(imageData);
      logger.log('Image saved to android: $filePath');
      return imageFile;
    } else if (Platform.isIOS) {
      Directory appDocDir = await getApplicationSupportDirectory();
      String filePath = '${appDocDir.path}/$pictureId.$extension';
      File imageFile = File(filePath);
      await imageFile.writeAsBytes(imageData);
      logger.log('Image saved to ios : $filePath');
      return imageFile;
    }
    return File('');
  }

  Future<void> saveDataToHive(String uid, String farmId, String path) async {
    final newData = SoilStudyModel(uid: uid, id: farmId, path: path);
    await fincaPdfsBox.add(newData);
  }

  void showSnackBar(BuildContext context, String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }
}
