import 'dart:developer';
import 'dart:io';

import 'package:finca/cubits/farms/farms_state.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/repository/farm/farm_repository.dart';
import 'package:finca/services/storage_service.dart';
import 'package:finca/utils/collection_refs.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FarmCubit extends Cubit<FarmsState> {
  final FarmRepository _farmRepository = FarmRepository();

  FarmCubit() : super(FarmsInitial());

  void getAllFarms() {
    emit(FarmsLoadingState());
    try {
      if (UserPreferences().getUserInfo()?.uid == null) {
        emit(const FarmsFailedState('User not found'));
        return;
      }
      log("userId: ${UserPreferences().getUserInfo()?.uid}");
      final farmStream = _farmRepository.getAllFarms(UserPreferences().getUserInfo()?.uid ?? '');
      emit(FarmsSuccessState(farmStream));
    } catch (e) {
      emit(FarmsFailedState(e.toString()));
    }
  }

  void addNewFarm(
    String farmId,
    String farmName,
    double size,
    String description,
    Set<Polygon> selectedPolygons,
    List<Crop> selectedCrops,
    String soilStudy,
    DateTime soilStudyDate,
    List<File> attachedFiles,
    String agriculturalCertification,
    DateTime agriculturalCertificationDate,
  ) async {
    emit(AddFarmsLoadingState());
    try {
      if (UserPreferences().getUserInfo()?.uid == null) {
        emit(const FarmsFailedState('User not found'));
        return;
      }
      String farmId = CollectionRefs.instance.crops(UserPreferences().getUserInfo()?.uid ?? '').id;
      List<String> urls = await uploadFilesToFirebaseStorage(attachedFiles);
      FarmModel farm = FarmModel(
        farmId: farmId,
        farmName: farmName,
        size: size,
        description: description ?? '',
        location: convertPolygonsToMap(selectedPolygons),
        crops: selectedCrops.map((e) => e.cropName).toList(),
        soilStudy: soilStudy,
        soilStudyDate: soilStudyDate,
        agriculturalCertification: agriculturalCertification,
        soilStudyLink: urls,
        agriculturalCertificationDate: agriculturalCertificationDate,
        createdAt: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      );
      log('farmUrls: $urls');
      final isAdded = await _farmRepository.addNewFarm(UserPreferences().getUserInfo()?.uid ?? '', farm);
      emit(AddFarmsSuccessState(isAdded));
    } catch (e) {
      emit(AddFarmsFailedState(e.toString()));
    }
  }

  List<Map<String, double>> convertPolygonsToMap(Set<Polygon> polygons) {
    List<Map<String, double>> polygonsData = [];

    for (LatLng point in polygons.first.points) {
      polygonsData.add({
        'latitude': point.latitude,
        'longitude': point.longitude,
      });
    }

    return polygonsData;
  }

  Future<List<String>> uploadFilesToFirebaseStorage(List<File> attachedFiles) async {
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

  Future<String> _uploadImage(File file, String collectionName, String pictureId) async {
    final firebaseImagePath = '$collectionName/$pictureId.pdf'; // Assuming the image format is JPEG
    return StorageService.uploadFile(firebaseImagePath, file).then((value) {
      return value;
    });
  }
}
