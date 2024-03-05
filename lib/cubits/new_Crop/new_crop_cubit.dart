import 'package:finca/cubits/new_Crop/new_crop_state.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/repository/new_crop_repository/new_crop_repository.dart';
import 'package:finca/utils/app_exception.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewCropCubit extends Cubit<NewCropState> {
  NewCropCubit() : super(NewCropInitial());
  final _fireStoreService = NewCropRepository();

  void addNewCrop(Crop crop) {
    try {
      emit(NewCropLoadingState());
      _fireStoreService.addNewCrop(crop, UserPreferences().getUserInfo().uid);
      emit(const NewCropSuccessState(true));
    } on AppException catch (e) {
      emit(NewCropFailedState(e.toString()));
    }
  }
}
