import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finca/assets/assets.dart';
import 'package:finca/cubits/new_Crop/new_crop_cubit.dart';
import 'package:finca/cubits/new_Crop/new_crop_state.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/modules/farms_screen/pages/new_crop_screen.dart';
import 'package:finca/modules/farms_screen/pages/step_four_new_farm.dart';
import 'package:finca/modules/farms_screen/views/crop_item.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/utils/collection_refs.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class CropsList extends StatefulWidget {
  const CropsList({
    super.key,
    this.isUpdating = false,
    this.farm,
    required this.farmName,
    required this.size,
    required this.selectedSoilType,
    this.description,
    required this.selectedPolygons,
    required this.polygonImage,
  });

  final bool? isUpdating;
  final FarmModel? farm;
  final String farmName;
  final String size;
  final Tag selectedSoilType;
  final String? description;
  final List<LatLng> selectedPolygons;
  final Uint8List polygonImage;

  @override
  State<CropsList> createState() => _CropsListState();
}

class _CropsListState extends State<CropsList> {
  bool isCropDeleting = false;
  Stream<QuerySnapshot<Map<String, dynamic>>> cropsStream = const Stream.empty();
  List<Crop> crops = [];
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        CollectionRefs.instance.users
            .doc(UserPreferences().getUserInfo()?.uid ?? '')
            .collection('crops')
            .snapshots()
            .listen((event) {
          crops.clear();
          crops = event.docs
              .map(
                (e) => Crop.fromJson(
                  e.data(),
                ),
              )
              .toList();
          if (context.mounted) {
            setState(() {});
          }
        });
        return NewCropCubit()..getAllCrops();
      },
      child: BlocConsumer<NewCropCubit, NewCropState>(listener: (context, state) {
        log("stepthreestate: $state");
        if (state is AllCropLoadingState) {
        } else if (state is AllCropSuccessState) {
          cropsStream = state.cropStream;
        } else if (state is AllCropFailedState) {
        } else if (state is DeleteCropLoadingState) {
          isCropDeleting = true;
        } else if (state is DeleteCropSuccessState) {
          isCropDeleting = false;
        } else if (state is DeleteCropFailedState) {
          log("statemessage: ${state.message}");
          isCropDeleting = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      }, builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 7,
                        right: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 15,
                                ),
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                      10,
                                    ),
                                    bottomRight: Radius.circular(
                                      10,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: SvgPicture.asset(
                                            Assets.backIcon,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (widget.isUpdating ?? false) ? AppStrings.editFarm : AppStrings.newFarm,
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.greenColor,
                                            fontFamily: Assets.rubik,
                                          ),
                                        ),
                                        Text(
                                          AppStrings.stepThree,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.darkGrey,
                                            fontFamily: Assets.rubik,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              cropsList(state is AllCropSuccessState ? state.cropStream : const Stream.empty()),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 20,
                              bottom: 20,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                if (selectedIndex == -1) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        AppStrings.selectCrop,
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (widget.isUpdating ?? false) {
                                  if (widget.farm?.cropId == crops[selectedIndex].cropId) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => StepFourNewFarmScreen(
                                          isUpdating: widget.isUpdating,
                                          farm: widget.farm,
                                          selectedCrop: crops[selectedIndex],
                                          farmName: widget.farmName,
                                          size: widget.size,
                                          selectedSoilType: widget.selectedSoilType,
                                          description: widget.description,
                                          selectedPolygons: widget.selectedPolygons,
                                          polygonImage: widget.polygonImage,
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          AppStrings.cropNotMatching,
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => StepFourNewFarmScreen(
                                        isUpdating: widget.isUpdating,
                                        farm: widget.farm,
                                        selectedCrop: crops[selectedIndex],
                                        farmName: widget.farmName,
                                        size: widget.size,
                                        selectedSoilType: widget.selectedSoilType,
                                        description: widget.description,
                                        selectedPolygons: widget.selectedPolygons,
                                        polygonImage: widget.polygonImage,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: 25,
                                  right: 10,
                                ),
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedIndex != -1 ? AppColors.greenColor : AppColors.greenColor,
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    AppStrings.continueText,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.white,
                                      fontFamily: Assets.rubik,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  Widget cropsList(Stream<QuerySnapshot<Map<String, dynamic>>> cropsStream) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: crops.length,
      itemBuilder: (context, index) {
        return CropItem(
          crop: crops[index],
          index: index,
          isCropDeleting: isCropDeleting,
          isSelected: selectedIndex == index,
          onEditCrop: (crop) {
            if (crop.cropId == widget.farm?.cropId) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewCropScreen(
                    isUpdating: true,
                    farmName: widget.farmName,
                    crop: crops[index],
                    polygonImage: widget.polygonImage,
                    selectedPolygon: widget.selectedPolygons,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    AppStrings.cropNotMatching,
                  ),
                ),
              );
            }
          },
          onSelectCrop: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          onDeleteCrop: (crop) {
            context.read<NewCropCubit>().deleteSpecificCrop(crop);
          },
        );
      },
    );
  }
}
