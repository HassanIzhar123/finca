import 'dart:developer';

import 'package:finca/cubits/new_Crop/new_crop_state.dart';
import 'package:finca/enums/sowing_enum.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/repository/new_crop_repository/new_crop_repository.dart';
import 'package:finca/utils/app_exception.dart';
import 'package:finca/utils/collection_refs.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewCropCubit extends Cubit<NewCropState> {
  NewCropCubit() : super(NewCropInitial());
  final _fireStoreService = NewCropRepository();

  void addNewCrop(
      String cropName, List<String> varieties, String scientificName, DateTime seedTime, SowingEnum sowing) async {
    try {
      emit(NewCropLoadingState());
      Crop crop = Crop(
        '',
        cropName,
        varieties,
        scientificName,
        DateTime.now(),
        sowing,
      );
      final userInfo = UserPreferences().getUserInfo();
      _fireStoreService.addNewCrop(crop, userInfo?.uid ?? '');
      emit(const NewCropSuccessState(true));
    } on AppException catch (e) {
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
    final cropStream = CollectionRefs.instance.users.doc(userInfo?.uid ?? '').collection('crops').snapshots().map(
          (event) => event.docs
              .map(
                (e) => Crop.fromJson(
                  e.data(),
                ),
              )
              .toList(),
        );
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
}
