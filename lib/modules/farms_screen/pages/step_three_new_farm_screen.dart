import 'package:finca/assets/assets.dart';
import 'package:finca/modules/farms_screen/pages/step_four_new_farm_screen.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StepThreeNewFarmScreen extends StatefulWidget {
  const StepThreeNewFarmScreen({super.key});

  @override
  State<StepThreeNewFarmScreen> createState() => _StepThreeNewFarmScreenState();
}

class _StepThreeNewFarmScreenState extends State<StepThreeNewFarmScreen> {
  @override
  Widget build(BuildContext context) {
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
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(
                              left: 20,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  Assets.addCrops,
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
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => const StepFourNewFarmScreen()));
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
  }
}
