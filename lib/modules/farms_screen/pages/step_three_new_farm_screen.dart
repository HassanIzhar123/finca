import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finca/assets/assets.dart';
import 'package:finca/cubits/new_Crop/new_crop_cubit.dart';
import 'package:finca/cubits/new_Crop/new_crop_state.dart';
import 'package:finca/enums/sowing_enum.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/modules/farms_screen/pages/new_crop_screen.dart';
import 'package:finca/modules/farms_screen/pages/step_four_new_farm.dart';
import 'package:finca/modules/farms_screen/views/crop_item.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/utils/collection_refs.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:finca/views/step_progress_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class StepThreeNewFarmScreen extends StatefulWidget {
  const StepThreeNewFarmScreen({
    super.key,
    required this.name,
    required this.size,
    required this.selectedSoilType,
    this.description,
    required this.selectedPolygons,
    required this.polygonImage,
  });

  final Set<Polygon> selectedPolygons;
  final String name;
  final String size;
  final Tag selectedSoilType;
  final String? description;
  final Uint8List polygonImage;

  @override
  State<StepThreeNewFarmScreen> createState() => _StepThreeNewFarmScreenState();
}

class _StepThreeNewFarmScreenState extends State<StepThreeNewFarmScreen> {
  bool isCropDeleting = false;
  Stream<QuerySnapshot<Map<String, dynamic>>> cropsStream = const Stream.empty();
  int selectedIndex = -1;
  List<Crop> crops = [];
  Set<int> selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        log("hi i am here");
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
          isCropDeleting = false;
          Navigator.pop(context);
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
                                          AppStrings.newFarm,
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
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 15,
                                  right: 20,
                                ),
                                child: Text(
                                  AppStrings.addTheCrops,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkGrey,
                                    fontFamily: Assets.rubik,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              CupertinoButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => NewCropScreen(
                                        farmName: widget.name,
                                        polygonImage: widget.polygonImage,
                                        selectedPolygon: widget.selectedPolygons,
                                      ),
                                    ),
                                  );
                                },
                                padding: EdgeInsets.zero,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(
                                    left: 20,
                                    right: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(
                                      25,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        Assets.addNewCrop,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        AppStrings.addCrops,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.darkGrey,
                                          fontFamily: Assets.rubik,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
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
                              onTap: selectedIndexes.isEmpty
                                  ? null
                                  : () {
                                      List<Crop> selectedCrops = [];
                                      for (var index in selectedIndexes) {
                                        selectedCrops.add(crops[index]);
                                      }

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => StepFourNewFarmScreen(
                                            selectedCrops: selectedCrops,
                                            name: widget.name,
                                            size: widget.size,
                                            selectedSoilType: widget.selectedSoilType,
                                            description: widget.description,
                                            selectedPolygons: widget.selectedPolygons,
                                            polygonImage: widget.polygonImage,
                                          ),
                                        ),
                                      );
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
    return StreamBuilder(
        stream: cropsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          log('snapshot.hasData: ${snapshot.hasData}');
          if (snapshot.hasData) {
            log("crops: ${snapshot.data.toString()}");
            crops.clear();
            crops = snapshot.data?.docs
                    .map(
                      (e) => Crop.fromJson(
                        e.data(),
                      ),
                    )
                    .toList() ??
                [];
            return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: crops.length,
                itemBuilder: (context, index) {
                  return CropItem(
                    crop: crops[index],
                    index: index,
                    isCropDeleting: isCropDeleting,
                    isSelected: selectedIndexes.contains(index),
                    onSelectCrop: (int index) {
                      setState(() {
                        if (selectedIndexes.contains(index)) {
                          selectedIndexes.remove(index);
                        } else {
                          selectedIndexes.add(index);
                        }
                      });
                      // setState(() {
                      //   selectedIndex = -1;
                      //   selectedIndex = index;
                      //   log('index: $index');
                      // });
                    },
                    onDeleteCrop: (crop) {
                      context.read<NewCropCubit>().deleteSpecificCrop(crop);
                    },
                  );
                });
          }
          return const SizedBox();
        });
  }
}

class VarietyView extends StatelessWidget {
  const VarietyView({super.key, required this.varietyName});

  final String varietyName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.purple,
      ),
      margin: const EdgeInsets.only(
        // left: 10,
        right: 10,
      ),
      padding: const EdgeInsets.only(
        top: 3,
        bottom: 3,
        left: 10,
        right: 10,
      ),
      child: Text(
        varietyName,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
          fontFamily: Assets.rubik,
        ),
      ),
    );
  }
}
