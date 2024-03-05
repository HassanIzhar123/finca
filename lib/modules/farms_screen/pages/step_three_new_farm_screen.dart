import 'package:finca/assets/assets.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/modules/farms_screen/pages/new_crop_screen.dart';
import 'package:finca/modules/farms_screen/pages/step_four_new_farm.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StepThreeNewFarmScreen extends StatefulWidget {
  const StepThreeNewFarmScreen(
      {super.key, required this.name, required this.size, required this.selectedSoilType, this.description});

  final String name;
  final String size;
  final Tag selectedSoilType;
  final String? description;

  @override
  State<StepThreeNewFarmScreen> createState() => _StepThreeNewFarmScreenState();
}

class _StepThreeNewFarmScreenState extends State<StepThreeNewFarmScreen> {
  double _currentSliderValue = 0;
  List<Crop> crops = [];

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
                          CupertinoButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) => const NewCropScreen()));
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
                          ),
                          cropsList(),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NewCropScreen()));
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => StepFourNewFarmScreen()));
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

  Widget cropsList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: crops.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                10,
              ),
              color: AppColors.lightGrey,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVkDF8i8wPSCO875Sj0ZDB8GFcVntXNlnb0Q&usqp=CAU',
                        height: 100.0,
                        width: 100.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Text(
                            'Crop name',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColors.darkGrey,
                              fontFamily: Assets.rubik,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Text(
                            '#Property name',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkGrey,
                              fontFamily: Assets.rubik,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(Assets.calendar),
                              Text(
                                '12/12/12',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.darkGrey,
                                  fontFamily: Assets.rubik,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            color: AppColors.darkGrey,
                            height: 3,
                            thickness: 3,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                Assets.delete,
                                color: AppColors.red,
                              ),
                              Text(
                                Assets.eliminate,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.darkGrey,
                                  fontFamily: Assets.rubik,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        });
  }
}
