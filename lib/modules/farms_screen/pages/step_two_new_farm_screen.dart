import 'dart:typed_data';

import 'package:finca/assets/assets.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/modules/farms_screen/pages/step_three_new_farm_screen.dart';
import 'package:finca/views/tags_view.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/views/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter_platform_interface/src/types/polygon.dart';

class StepTwoNewFarmScreen extends StatefulWidget {
  final Set<Polygon> selectedPolygons;
  final Uint8List polygonImage;

  const StepTwoNewFarmScreen({super.key, required this.selectedPolygons, required this.polygonImage});

  @override
  State<StepTwoNewFarmScreen> createState() => _StepTwoNewFarmScreenState();
}

class _StepTwoNewFarmScreenState extends State<StepTwoNewFarmScreen> {
  String name = '';
  String size = '';
  Tag selectedSoilType = Tag("Option 1", false);
  String? description;
  List<Tag> soilType = [
    Tag("Option 1", true),
    Tag("Option 2", false),
    Tag("Option 3", false),
    Tag("Option 4", false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(
              left: 7,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            SvgPicture.asset(Assets.backIcon),
                          ],
                        ),
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
                            AppStrings.stepTwo,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGrey,
                              fontFamily: Assets.rubik,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
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
                      left: 25,
                      right: 10,
                    ),
                    child: CustomTextField(
                      name: AppStrings.name,
                      hintText: "Write name",
                      onChange: (text) {
                        setState(() {
                          name = text;
                        });
                      },
                    )),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    margin: const EdgeInsets.only(
                      left: 25,
                      right: 10,
                    ),
                    child: CustomTextField(
                      name: AppStrings.size,
                      hintText: "0000",
                      isNumberTextField: true,
                      onChange: (text) {
                        setState(() {
                          size = text;
                        });
                      },
                    )),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 25,
                    right: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.soilType,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGrey,
                          fontFamily: Assets.rubik,
                        ),
                      ),
                      SizedBox(
                        height: 70,
                        child: TagsView(
                          postTags: soilType,
                          onTagTapped: (index) {
                            setState(() {
                              for (int i = 0; i < soilType.length; i++) {
                                if (i == index) {
                                  soilType[i].isSelected = true;
                                } else {
                                  soilType[i].isSelected = false;
                                }
                              }
                              selectedSoilType = soilType[index];
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 25,
                    right: 10,
                  ),
                  child: CustomTextField(
                    name: AppStrings.stepTwoNewFarmDescription,
                    hintText: "Write additional description",
                    onChange: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please enter farm name'),
                      ));
                      return;
                    }
                    if (size.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please enter farm size'),
                      ));
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StepThreeNewFarmScreen(
                          name: name,
                          size: size,
                          selectedSoilType: selectedSoilType,
                          description: description,
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
                      color: AppColors.greenColor,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
