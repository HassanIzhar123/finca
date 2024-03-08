import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finca/assets/assets.dart';
import 'package:finca/cubits/farms/farm_cubit.dart';
import 'package:finca/cubits/farms/farms_state.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/repository/farm/farm_repository.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(UserPreferences().getUserInfo()?.uid ?? '')
                            .collection('farms')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          log('snapshot.hasData: ${snapshot.hasData}');
                          if (snapshot.data != null) {
                            final farms = snapshot.data!.docs.map((e) {
                              final data = FarmModel.fromJson(e.data());
                              log("event: " + data.toJson().toString());
                              return data;
                            }).toList();
                            if (farms.isEmpty) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: double.infinity,
                                child: const SizedBox(
                                  height: 200,
                                  child: Center(
                                    child: Text(
                                      'No Farms Found',
                                      style: TextStyle(
                                        color: AppColors.darkGrey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
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
                                            right: index == soilType.length - 1 ? 0 : 10,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
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
                          return const Center(child: Text('No Farms found'));
                        }),
                    const SizedBox(height: 20),
                    Column(
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
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: double.infinity,
                          child: const SizedBox(
                            height: 200,
                            child: Center(
                              child: Text(
                                'No Crops Found',
                                style: TextStyle(
                                  color: AppColors.darkGrey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
                    GestureDetector(
                      onTap: () {},
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
                    )
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
