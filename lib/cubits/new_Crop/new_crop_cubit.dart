import 'dart:developer';
import 'dart:typed_data';

import 'package:finca/cubits/new_Crop/new_crop_state.dart';
import 'package:finca/enums/sowing_enum.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/repository/new_crop_repository/new_crop_repository.dart';
import 'package:finca/services/storage_service.dart';
import 'package:finca/utils/app_exception.dart';
import 'package:finca/utils/collection_refs.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewCropCubit extends Cubit<NewCropState> {
  NewCropCubit() : super(NewCropInitial());
  final _fireStoreService = NewCropRepository();

  Future<String> _uploadImage(
      Uint8List? imageData, String collectionName, String pictureId) async {
    if (imageData != null) {
      final firebaseImagePath = '$collectionName/$pictureId.jpg';
      return StorageService.uploadFileWithUIntList(firebaseImagePath, imageData)
          .then((value) {
        return value;
      });
    }
    return '';
  }

  void addNewCrop(
      String farmName,
      String cropName,
      List<String> varieties,
      String scientificName,
      DateTime seedTime,
      SowingEnum sowing,
      Uint8List polygonImage) async {
    try {
      emit(NewCropLoadingState());
      final userInfo = UserPreferences().getUserInfo();
      final ref = CollectionRefs.instance.users
          .doc(userInfo?.uid ?? '')
          .collection('crops');
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
        cropName,
        farmImage,
        varieties,
        scientificName,
        DateTime.now(),
        sowing,
      );
      _fireStoreService.addNewCrop(docId, crop, userInfo?.uid ?? '');
      emit(const NewCropSuccessState(true));
    } on AppException catch (e) {
      log("EceptioneL: ${e.toString()}");
      emit(NewCropFailedState(e.toString()));
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
    final cropStream = CollectionRefs.instance.users
        .doc(userInfo?.uid ?? '')
        .collection('crops')
        .snapshots();
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

// getAllCropsOfSpecificFarm() {
//   emit(AllCropLoadingState());
//   final userInfo = UserPreferences().getUserInfo();
//   log("userInfo?.uid: ${userInfo?.uid}");
//   if (userInfo?.uid == null) {
//     emit(const AllCropFailedState('User not found'));
//     return;
//   }
//   final cropStream = CollectionRefs.instance.users.doc(userInfo?.uid ?? '').collection('crops').snapshots().map(
//         (event) => event.docs
//             .map(
//               (e) => Crop.fromJson(
//                 e.data(),
//               ),
//             )
//             .toList(),
//       );
//   emit(AllCropSuccessState(cropStream));
// }
}
