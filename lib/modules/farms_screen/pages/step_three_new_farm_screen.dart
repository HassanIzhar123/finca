import 'dart:developer';

import 'package:finca/assets/assets.dart';
import 'package:finca/cubits/new_Crop/new_crop_cubit.dart';
import 'package:finca/cubits/new_Crop/new_crop_state.dart';
import 'package:finca/enums/sowing_enum.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/modules/farms_screen/pages/new_crop_screen.dart';
import 'package:finca/modules/farms_screen/pages/step_four_new_farm.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/utils/collection_refs.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:finca/views/step_progress_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  List<Crop> crops = [];

  final _stepsText = ["Sowing", "In Progress", "Harvest"];

  final _stepCircleRadius = 5.0;

  final _stepProgressViewHeight = 60.0;

  final Color _activeColor = AppColors.greenColor;

  final Color _inactiveColor = Colors.grey;

  final TextStyle _stepStyle = const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold);
  bool isCropDeleting = false;
  Stream<List<Crop>> cropsStream = const Stream<List<Crop>>.empty();

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
      }),
    );
  }

  Widget cropsList(Stream<List<Crop>> cropsStream) {
    final userInfo = UserPreferences().getUserInfo();
    // if (userInfo?.uid == null) {
    //   return const SizedBox();
    // }
    log("uidValueCheck: ${userInfo?.uid}");
    return StreamBuilder(
        stream: cropsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          log('snapshot.hasData: ${snapshot.hasData}');
          if (snapshot.hasData) {
            log("crops: ${snapshot.data.toString()}");
            crops = snapshot.data??[];
            return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                            Expanded(
                              child: Column(
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
                                      // bottom: 10,
                                    ),
                                    child: Text(
                                      crops[index].cropName,
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
                                  // Flexible(
                                  //   child: Wrap(
                                  //     children: List.generate(
                                  //       Random().nextInt(5) + 1,
                                  //       (_) => SizedBox(width: 50, height: 50),
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 10,
                                      top: 10,
                                    ),
                                    height: 25,
                                    child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      physics: const NeverScrollableScrollPhysics(),
                                      children: crops[index]
                                          .varieties
                                          .map((variety) => VarietyView(varietyName: variety))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        StepProgressView(
                          _stepsText,
                          (SowingEnum.values.indexOf(crops[index].sowing)) + 1,
                          _stepProgressViewHeight,
                          MediaQuery.of(context).size.width,
                          _stepCircleRadius,
                          _activeColor,
                          _inactiveColor,
                          _stepStyle,
                          decoration: const BoxDecoration(color: AppColors.lightGrey),
                          padding: const EdgeInsets.only(
                            // top: 48.0,
                            left: 24.0,
                            right: 24.0,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(Assets.calendar),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          crops[index].seedTime.toString(),
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
                                    Container(
                                      decoration: const BoxDecoration(color: AppColors.darkGrey),
                                      height: 0.5,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: isCropDeleting
                                          ? null
                                          : () {
                                              context.read<NewCropCubit>().deleteSpecificCrop(crops[index]);
                                            },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            Assets.delete,
                                            color: AppColors.red,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            Assets.eliminate,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.red,
                                              fontFamily: Assets.rubik,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
