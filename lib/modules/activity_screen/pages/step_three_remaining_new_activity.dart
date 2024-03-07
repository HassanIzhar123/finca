import 'package:finca/assets/assets.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/views/tags_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StepThreeRemainingNewActivity extends StatefulWidget {
  const StepThreeRemainingNewActivity({super.key});

  @override
  State<StepThreeRemainingNewActivity> createState() => _StepThreeRemainingNewActivityState();
}

class _StepThreeRemainingNewActivityState extends State<StepThreeRemainingNewActivity> {
  List<Tag> soilType = [
    Tag("Option 1", true),
    Tag("Option 2", false),
    Tag("Option 3", false),
    Tag("Option 4", false),
  ];
  Tag? selectedSoilType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(
              top: 10,
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'New Activity',
                  style: TextStyle(
                    color: AppColors.greenColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Step 3 of 4',
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: soilType.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(
                          right: index == soilType.length - 1 ? 0 : 10,
                        ),
                        decoration: BoxDecoration(
                          // color: soilType[index].isSelected ? AppColors.greenColor : AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: soilType[index].isSelected ? AppColors.greenColor : AppColors.lightGrey,
                          ),
                        ),
                        child: SvgPicture.asset(
                          Assets.mapIcon,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
