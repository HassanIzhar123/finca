import 'dart:developer';
import 'dart:io';
import 'package:finca/cubits/farms/farms_state.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/activity_screen/models/activity_model.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/repository/farm/farm_repository.dart';
import 'package:finca/services/storage_service.dart';
import 'package:finca/utils/collection_refs.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:finca/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:hive/hive.dart';

class FarmCubit extends Cubit<FarmsState> {
  final FarmRepository _farmRepository = FarmRepository();

  FarmCubit() : super(FarmsInitial());

  void getAllFarms() async {
    await Future.delayed(const Duration(milliseconds: 1));
    emit(FarmsLoadingState());
    try {
      if (UserPreferences().getUserInfo()?.uid == null) {
        emit(const FarmsFailedState('User not found'));
        return;
      }
      log("userId: ${UserPreferences().getUserInfo()?.uid}");
      final farms = await _farmRepository.getAllFarmsWithOutStream(UserPreferences().getUserInfo()?.uid ?? '');
      emit(FarmsFutureSuccessState(farms));
    } catch (e) {
      emit(FarmsFailedState(e.toString()));
    }
  }

  void addNewFarm(
      FarmModel? farmModel,
      String farmName,
      double size,
      String soilType,
      String description,
      List<LatLng> selectedPolygons,
      Crop selectedCrop,
      String soilStudy,
      DateTime soilStudyDate,
      List<File> attachedFiles,
      String agriculturalCertification,
      DateTime agriculturalCertificationDate,
      {bool? isUpdating = false}) async {
    emit(AddFarmsLoadingState());
    try {
      String farmId = '';
      if (isUpdating ?? false) {
        farmId = farmModel?.farmId ?? '';
      } else {
        farmId = CollectionRefs.instance.crops(UserPreferences().getUserInfo()?.uid ?? '').doc().id;
      }
      log('farmId: $farmId');
      List<String> urls =
          await uploadFilesToFirebaseStorage(UserPreferences().getUserInfo()?.uid ?? '', farmId, attachedFiles);

      FarmModel farm = FarmModel(
        farmId: farmId,
        farmName: farmName,
        size: size,
        soilType: soilType,
        description: description ?? '',
        location: convertPolygonsToMap(selectedPolygons),
        cropId: selectedCrop.cropId,
        soilStudy: soilStudy,
        soilStudyDate: soilStudyDate,
        agriculturalCertification: agriculturalCertification,
        soilStudyLink: urls,
        agriculturalCertificationDate: agriculturalCertificationDate,
        createdAt: (isUpdating ?? false) ? farmModel?.createdAt : getCurrentDate(),
        updatedAt: (isUpdating ?? false) ? getCurrentDate() : farmModel?.updatedAt ?? getCurrentDate(),
      );
      log('farmUrls: ${urls} ${farm.toJson().toString()}');
      final isAdded = _farmRepository.addNewFarm(UserPreferences().getUserInfo()?.uid ?? '', farm);
      emit(AddFarmsSuccessState(isAdded));
    } catch (e) {
      emit(AddFarmsFailedState(e.toString()));
    }
  }

  DateTime getCurrentDate() {
    return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  }

  List<Map<String, double>> convertPolygonsToMap(List<LatLng> polygons) {
    List<Map<String, double>> polygonsData = [];

    for (LatLng point in polygons) {
      polygonsData.add({
        'latitude': point.latitude,
        'longitude': point.longitude,
      });
    }

    return polygonsData;
  }

  Future<List<String>> uploadFilesToFirebaseStorage(
    String uid,
    String farmId,
    List<File> attachedFiles,
  ) async {
    if (!await Utils().checkIfInternetIsAvailable()) {
      for (File file in attachedFiles) {
        String path = await savePdfInAppDirectory(uid, file);
        log('file: ${file.path} path: $path');
        await Utils().saveDataToHive(uid, farmId, path);
      }
      //because its gonna save in app directory
      return [];
    } else {
      List<String> fileUrls = [];
      for (File file in attachedFiles) {
        String farmId = CollectionRefs.instance.crops(UserPreferences().getUserInfo()?.uid ?? '').doc().id;
        log('farmsIds: $farmId');
        String soilStudyLink = await _uploadImage(
          file,
          'Farms',
          farmId,
        );
        fileUrls.add(soilStudyLink);
      }
      return fileUrls;
    }
  }

  Future<String> savePdfInAppDirectory(String uid, File file) async {
    if (Platform.isIOS) {
      Directory appSupportDir = await getApplicationDocumentsDirectory();
      String fileName = path.basename(file.path);
      File pdfFile = File('${appSupportDir.path}/${uid}_$fileName');
      await file.copy(pdfFile.path);
      return pdfFile.path;
    } else if (Platform.isAndroid) {
      Directory appDir = await getApplicationSupportDirectory();
      String fileName = path.basename(file.path);
      String pdfPath = '${appDir.path}/${uid}_${fileName}';
      await file.copy(pdfPath);
      return pdfPath;
    } else {
      return '';
    }
  }

  Future<String> _uploadImage(File file, String collectionName, String pictureId) async {
    final firebaseImagePath = '$collectionName/$pictureId.pdf'; // Assuming the image format is JPEG
    return StorageService.uploadFile(firebaseImagePath, file).then((value) {
      return value;
    });
  }

  Future<String> _updateImage(File file, String collectionName, String pictureId) async {
    final firebaseImagePath = '$collectionName/$pictureId.pdf'; // Assuming the image format is JPEG
    return StorageService.uploadFile(firebaseImagePath, file).then((value) {
      return value;
    });
  }

  void getSoiType() async {
    await Future.delayed(const Duration(milliseconds: 1));
    emit(SoilLoadingState());
    try {
      emit(SoilSuccessState(await _farmRepository.getSoilType()));
    } catch (e) {
      emit(SoilFailedState(e.toString()));
    }
  }

  void getAgriculturalCertifications() async {
    emit(AgriculturalCertificationLoadingState());
    try {
      emit(AgriculturalCertificationSuccessState(await _farmRepository.getAgriculturalCertifications()));
    } catch (e) {
      emit(AgriculturalCertificationFailedState(e.toString()));
    }
  }

  Future<void> addActivity({
    required String farmName,
    required String cropName,
    required String activityType,
    required DateTime startDate,
    required DateTime endDate,
    required DateTime startTime,
    required DateTime endTime,
    required bool isAllDay,
    String? chemicalName,
    String? details,
    double? amount,
  }) async {
    emit(AddActivityLoadingState());
    try {
      if (UserPreferences().getUserInfo()?.uid == null) {
        emit(const AddActivityFailedState('User not found'));
        return;
      }
      startDate = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
        startTime.hour,
        startTime.minute,
      );
      endDate = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        endTime.hour,
        endTime.minute,
      );
      String activityId = CollectionRefs.instance.activities(UserPreferences().getUserInfo()?.uid ?? '').id;
      ActivityModel activity = ActivityModel(
        activityId: activityId,
        farmName: farmName,
        cropName: cropName,
        activityType: activityType,
        startDate: startDate,
        endDate: endDate,
        chemicalName: chemicalName,
        details: details,
        amount: amount,
        isAllDay: isAllDay,
      );
      final isAdded = await _farmRepository.addActivity(UserPreferences().getUserInfo()?.uid ?? '', activity);
      emit(AddActivitySuccessState(isAdded));
    } catch (e) {
      emit(AddActivityFailedState(e.toString()));
    }
  }
}
