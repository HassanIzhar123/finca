import 'dart:developer';

import 'package:finca/assets/assets.dart';
import 'package:finca/cubits/farms/farm_cubit.dart';
import 'package:finca/cubits/farms/farms_state.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StepThreeRemainingNewActivity extends StatefulWidget {
  const StepThreeRemainingNewActivity({super.key});

  @override
  State<StepThreeRemainingNewActivity> createState() =>
      _StepThreeRemainingNewActivityState();
}

class _StepThreeRemainingNewActivityState
    extends State<StepThreeRemainingNewActivity> {
  List<Tag> soilType = [
    Tag("Option 1", true),
    Tag("Option 2", false),
    Tag("Option 3", false),
    Tag("Option 4", false),
  ];
  Tag? selectedSoilType;
  List<Crop> crops = [];
  Stream<List<FarmModel>>? farmsStream;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return FarmCubit()..getAllFarms();
      },
      child: BlocConsumer<FarmCubit, FarmsState>(listener: (context, state) {
        log("stepthreestate: $state");
        if (state is FarmsLoadingState) {
        } else if (state is FarmsSuccessState) {
          farmsStream = state.farms;
        } else if (state is FarmsFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      }, builder: (context, state) {
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
                    StreamBuilder(
                        stream: farmsStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          log('snapshot.hasData: ${snapshot.hasData}');
                          if (snapshot.hasData) {
                            final farms = snapshot.requireData;
                            return SizedBox(
                              height: 155,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: farms.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      // setState(() {
                                      //   for (int i = 0; i < soilType.length; i++) {
                                      //     if (i == index) {
                                      //       soilType[i].isSelected = true;
                                      //     } else {
                                      //       soilType[i].isSelected = false;
                                      //     }
                                      //   }
                                      //   selectedSoilType = soilType[index];
                                      // });
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(1),
                                          margin: EdgeInsets.only(
                                            right: index == soilType.length - 1
                                                ? 0
                                                : 10,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: soilType[index].isSelected
                                                  ? AppColors.greenColor
                                                  : AppColors.lightGrey,
                                            ),
                                          ),
                                          child: Image.asset(
                                            Assets.mapIcon,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                        Text(
                                          farms[index].farmName,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.darkGrey,
                                            fontFamily: Assets.rubik,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                          return const SizedBox();
                        }),
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
                            AppStrings.selectWhichCrops,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGrey,
                              fontFamily: Assets.rubik,
                            ),
                          ),
                          // SizedBox(
                          //   height: 70,
                          //   child: TagsView(
                          //     postTags: tag,
                          //     onTagTapped: (index) {
                          //       setState(() {
                          //         for (int i = 0; i < soilType.length; i++) {
                          //           if (i == index) {
                          //             soilType[i].isSelected = true;
                          //           } else {
                          //             soilType[i].isSelected = false;
                          //           }
                          //         }
                          //         selectedSoilType = soilType[index];
                          //       });
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
