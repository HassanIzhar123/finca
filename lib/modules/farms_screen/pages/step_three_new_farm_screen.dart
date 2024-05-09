import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finca/assets/assets.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/modules/farms_screen/pages/crops_list.dart';
import 'package:finca/modules/farms_screen/pages/new_crop_screen.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class StepThreeNewFarmScreen extends StatefulWidget {
  const StepThreeNewFarmScreen({
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
  final List<LatLng> selectedPolygons;
  final String farmName;
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
    return Scaffold(
      body: SafeArea(
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
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) => NewCropScreen(
                            farm: widget.farm,
                            farmName: widget.farmName,
                            polygonImage: widget.polygonImage,
                            selectedPolygon: widget.selectedPolygons,
                          ),
                        ),
                      )
                          .then((value) {
                        if (value != null) {
                          if (value) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CropsList(
                                  isUpdating: widget.isUpdating,
                                  farm: widget.farm,
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
                        }
                      });
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
                ],
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CropsList(
                          isUpdating: widget.isUpdating,
                          farm: widget.farm,
                          farmName: widget.farmName,
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
