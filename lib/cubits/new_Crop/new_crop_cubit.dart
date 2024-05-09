import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:finca/cubits/new_Crop/new_crop_state.dart';
import 'package:finca/enums/sowing_enum.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/repository/new_crop_repository/new_crop_repository.dart';
import 'package:finca/services/storage_service.dart';
import 'package:finca/utils/app_exception.dart';
import 'package:finca/utils/collection_refs.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:finca/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class NewCropCubit extends Cubit<NewCropState> {
  NewCropCubit() : super(NewCropInitial());
  final _fireStoreService = NewCropRepository();

  void getScientificNames() async {
    emit(VarietiesLoadingState());
    final scientificName = await CollectionRefs.instance.cropVarieties().get();
    //convert it into list of string
    final varieties = scientificName.docs.map((e) => e['name'].toString()).toList();
    emit(VarietiesSuccessState(varieties));
  }

  void getVarieties() async {
    emit(CropNamesLoadingState());
    final scientificName = await CollectionRefs.instance.cropNames().get();
    final scientificNames = scientificName.docs
        .map(
          (e) => Tag.fromJson(
            e.data(),
          ),
        )
        .toList();
    emit(CropNamesSuccessState(scientificNames));
  }

  Future<String> _uploadImage(
    Uint8List? imageData,
    String collectionName,
    String docId, {
    bool isUpdating = false,
  }) async {
    if (!await Utils().checkIfInternetIsAvailable()) {
      if (imageData != null) {
        String uid = UserPreferences().getUserInfo()?.uid ?? '';
        File file = await Utils().writeImageDataToFile(imageData, docId, 'jpg');
        String path = await savePdfInAppDirectory(uid, file);
        log('file: ${file.path} path: $path');
        await Utils().saveDataToHive(uid, docId, path);
      }
      return '';
    } else {
      if (imageData != null) {
        final firebaseImagePath = '$collectionName/$docId.jpg';
        return StorageService.uploadFileWithUIntList(firebaseImagePath, imageData, isUpdating: isUpdating)
            .then((value) {
          return value;
        });
      }
    }
    return '';
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

  void addNewCrop(String farmName, List<String> cropNames, List<String> varieties, DateTime seedTime, SowingEnum sowing,
      Uint8List polygonImage) async {
    try {
      emit(NewCropLoadingState());
      final userInfo = UserPreferences().getUserInfo();
      final ref = CollectionRefs.instance.users.doc(userInfo?.uid ?? '').collection('crops');
      String docId = ref.doc().id;
      log('docId: $docId');
      String farmImage = await _uploadImage(
        polygonImage,
        'Crops',
        docId,
      );
      Crop crop = Crop(
        docId,
        farmName,
        farmImage,
        cropNames,
        varieties,
        DateTime.now(),
        sowing,
      );
      _fireStoreService.addNewCrop(docId, crop, userInfo?.uid ?? '');
      emit(const NewCropSuccessState(true));
    } on AppException catch (e) {
      log("EceptioneL: ${e.toString()}");
      emit(NewCropFailedState(e.message.toString()));
    }
  }

  void getAllCrops() {
    emit(AllCropLoadingState());
    final userInfo = UserPreferences().getUserInfo();
    log("userInfo?.uid: ${userInfo?.uid}");
    if (userInfo?.uid == null) {
      emit(const AllCropFailedState('User not found'));
      return;
    }
    final cropStream = CollectionRefs.instance.users.doc(userInfo?.uid ?? '').collection('crops').snapshots();
    emit(AllCropSuccessState(cropStream));
  }

  void deleteSpecificCrop(Crop crop) {
    emit(DeleteCropLoadingState());
    CollectionRefs.instance.users
        .doc(UserPreferences().getUserInfo()?.uid)
        .collection('crops')
        .doc(crop.cropId)
        .delete();
    emit(const DeleteCropSuccessState(true));
  }

  void updateCrop(String cropId, String farmName, List<String> cropNames, List<String> variety, DateTime seedTime,
      SowingEnum sowing, Uint8List polygonImage) async {
    try {
      emit(UpdateCropLoadingState());
      final userInfo = UserPreferences().getUserInfo();
      final ref = CollectionRefs.instance.users.doc(userInfo?.uid ?? '').collection('crops');
      String docId = cropId;
      log('docId: $docId');
      String farmImage = await _uploadImage(
        isUpdating: true,
        polygonImage,
        'Crops',
        docId,
      );
      Crop crop = Crop(
        docId,
        farmName,
        farmImage,
        cropNames,
        variety,
        seedTime,
        sowing,
      );
      _fireStoreService.addNewCrop(docId, crop, userInfo?.uid ?? '');
      emit(const UpdateCropSuccessState(true));
    } on AppException catch (e) {
      log("EceptioneL: ${e.toString()}");
      emit(UpdateCropFailedState(e.message.toString()));
    }
  }

  void setIfUpdating(bool isUpdating) async {
    if (isUpdating) {
      await Future.delayed(const Duration(milliseconds: 1));
      emit(InitialCropData());
    }
  }
}
