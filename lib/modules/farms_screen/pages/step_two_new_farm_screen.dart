import 'package:finca/assets/assets.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/modules/farms_screen/pages/step_three_new_farm_screen.dart';
import 'package:finca/views/tags_view.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/views/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StepTwoNewFarmScreen extends StatefulWidget {
  const StepTwoNewFarmScreen({super.key});

  @override
  State<StepTwoNewFarmScreen> createState() => _StepTwoNewFarmScreenState();
}

class _StepTwoNewFarmScreenState extends State<StepTwoNewFarmScreen> {
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
                      Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          SvgPicture.asset(Assets.backIcon),
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
                    child: const CustomTextField(name: AppStrings.name, hintText: "Write name")),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    margin: const EdgeInsets.only(
                      left: 25,
                      right: 10,
                    ),
                    child: const CustomTextField(name: AppStrings.size, hintText: "0000")),
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
                        height: 120,
                        child: TagsView(
                          postTags: [
                            Tag("Clay", true),
                            Tag("Sandy", false),
                            Tag("Sandy", false),
                            Tag("Sandy", false),
                            Tag("Sandy", false),
                            Tag("Sandy", false),
                            Tag("Sandy", false),
                            Tag("Sandy", false),
                            Tag("Sandy", false),
                            Tag("Sandy", false),
                          ],
                          onTagTapped: (index) {},
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
                  child: const CustomTextField(name: AppStrings.size, hintText: "0000"),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const StepThreeNewFarmScreen()));
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
