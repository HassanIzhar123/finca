import 'dart:developer';
import 'package:finca/assets/assets.dart';
import 'package:finca/cubits/farms/farm_cubit.dart';
import 'package:finca/cubits/farms/farms_state.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/models/notification/notification_model.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/modules/global/page/new_property_save_screen.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/utils/collection_refs.dart';
import 'package:finca/utils/notification_service.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:finca/views/tags_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class StepThreeRemainingNewActivity extends StatefulWidget {
  const StepThreeRemainingNewActivity({
    super.key,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.selectedActivityType,
    required this.isAllDay,
    required this.chemicalName,
    required this.details,
    required this.amount,
  });

  final DateTime startDate, startTime, endDate, endTime;
  final String selectedActivityType, chemicalName, details;
  final bool isAllDay;
  final double amount;

  @override
  State<StepThreeRemainingNewActivity> createState() => _StepThreeRemainingNewActivityState();
}

class _StepThreeRemainingNewActivityState extends State<StepThreeRemainingNewActivity> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Tag? selectedCrop;
  List<Tag> crops = [];
  int selectedFarmIndex = 0;
  List<FarmModel> farms = [];
  bool isLoading = false;
  bool isAddingActivityLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return FarmCubit()..getAllFarms();
      },
      child: BlocConsumer<FarmCubit, FarmsState>(listener: (context, state) {
        log("stepthreestate: $state");
        if (state is FarmsLoadingState) {
          isLoading = true;
        } else if (state is FarmsFutureSuccessState) {
          farms = state.farms;
          if (farms.isNotEmpty) {
            crops.clear();
            if (farms[0].crop != null) {
              final cropNames = farms[0].crop!.cropNames;
              for (int i = 0; i < cropNames.length; i++) {
                crops.add(Tag(cropNames[i], false));
              }
            }
            if (crops.isNotEmpty) {
              crops[0].isSelected = true;
              selectedCrop = crops[0];
            }
          }
          isLoading = false;
        } else if (state is FarmsFailedState) {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is AddActivityLoadingState) {
          isAddingActivityLoading = true;
        } else if (state is AddActivitySuccessState) {
          isAddingActivityLoading = false;
          if (state.isAdded) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const NewPropertySaveScreen(isActivity: true)));
          }
        } else if (state is AddActivityFailedState) {
          isAddingActivityLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      }, builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: IgnorePointer(
            ignoring: isAddingActivityLoading,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 50,
                  margin: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Nueva Actividad',
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
                      if (isLoading) ...{
                        const SizedBox(
                          height: 50,
                          child: Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
                      } else ...{
                        if (farms.isNotEmpty) ...{
                          const Text(
                            'Seleccionar Finca',
                            style: TextStyle(
                              color: AppColors.darkGrey,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Flexible(
                          //   child: ListView.builder(
                          //     scrollDirection: Axis.horizontal,
                          //     shrinkWrap: true,
                          //     itemCount: farms.length,
                          //     itemBuilder: (context, index) {
                          //       return GestureDetector(
                          //         onTap: () {
                          //           setState(() {
                          //             selectedFarmIndex = index;
                          //             crops.clear();
                          //             if (farms[selectedFarmIndex].crop != null) {
                          //               final cropNames = farms[selectedFarmIndex].crop!.cropNames;
                          //               for (int i = 0; i < cropNames.length; i++) {
                          //                 crops.add(Tag(cropNames[i], false));
                          //               }
                          //             }
                          //             if (crops.isNotEmpty) {
                          //               crops[0].isSelected = true;
                          //               selectedCrop = crops[0];
                          //             }
                          //             // crops.clear();
                          //             // for (var element in farms[selectedFarmIndex].crop) {
                          //             //   crops.add(Tag(element, false));
                          //             // }
                          //             // if (crops.isNotEmpty) {
                          //             //   crops[0].isSelected = true;
                          //             //   selectedSoilType = crops[0];
                          //             // }
                          //           });
                          //         },
                          //         child: Column(
                          //           mainAxisSize: MainAxisSize.min,
                          //           children: [
                          //             Container(
                          //               padding: const EdgeInsets.all(1),
                          //               margin: EdgeInsets.only(
                          //                 right: index == farms.length - 1 ? 0 : 10,
                          //               ),
                          //               decoration: BoxDecoration(
                          //                 borderRadius: BorderRadius.circular(20),
                          //                 border: Border.all(
                          //                   color:
                          //                       selectedFarmIndex == index ? AppColors.greenColor : AppColors.lightGrey,
                          //                 ),
                          //               ),
                          //               child: Image.asset(
                          //                 Assets.mapIcon,
                          //                 fit: BoxFit.fitHeight,
                          //               ),
                          //             ),
                          //             Text(
                          //               farms[index].farmName,
                          //               style: TextStyle(
                          //                 fontSize: 14,
                          //                 fontWeight: FontWeight.w600,
                          //                 color: AppColors.darkGrey,
                          //                 fontFamily: Assets.rubik,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),
                          Wrap(
                            children: [
                              for (int i = 0; i < farms.length; i++) ...{
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedFarmIndex = i;
                                      crops.clear();
                                      if (farms[selectedFarmIndex].crop != null) {
                                        final cropNames = farms[selectedFarmIndex].crop!.cropNames;
                                        for (int i = 0; i < cropNames.length; i++) {
                                          crops.add(Tag(cropNames[i], false));
                                        }
                                      }
                                      if (crops.isNotEmpty) {
                                        crops[0].isSelected = true;
                                        selectedCrop = crops[0];
                                      }
                                    });
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(1),
                                        margin: EdgeInsets.only(
                                          right: i == farms.length - 1 ? 0 : 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: selectedFarmIndex == i ? AppColors.greenColor : AppColors.lightGrey,
                                          ),
                                        ),
                                        child: Image.asset(
                                          Assets.mapIcon,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      Text(
                                        farms[i].farmName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.darkGrey,
                                          fontFamily: Assets.rubik,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              }
                            ],
                          ),
                        },
                        const SizedBox(height: 20),
                        const Text(
                          '* Seleccionar recorte',
                          style: TextStyle(
                            color: AppColors.darkGrey,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (crops.isNotEmpty) ...{
                          SizedBox(
                            height: 50,
                            child: TagsView(
                              postTags: crops,
                              onTagTapped: (index) {
                                for (int i = 0; i < crops.length; i++) {
                                  if (i == index) {
                                    crops[i].isSelected = true;
                                  } else {
                                    crops[i].isSelected = false;
                                  }
                                }
                                selectedCrop = crops[index];
                                setState(() {});
                              },
                            ),
                          )
                        } else ...{
                          const SizedBox(height: 20),
                          const Text(
                            'No Crops found',
                            style: TextStyle(
                              color: AppColors.darkGrey,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        },
                      },
                      const Spacer(),
                      GestureDetector(
                        onTap: isAddingActivityLoading
                            ? null
                            : () async {
                                context.read<FarmCubit>().addActivity(
                                      farmName: farms[selectedFarmIndex].farmName,
                                      cropName: selectedCrop!.name,
                                      activityType: widget.selectedActivityType,
                                      startDate: widget.startDate,
                                      startTime: widget.startTime,
                                      endDate: widget.endDate,
                                      endTime: widget.endTime,
                                      isAllDay: widget.isAllDay,
                                      chemicalName: widget.chemicalName,
                                      amount: widget.amount,
                                      details: widget.details,
                                    );
                                String title = AppStrings.notificationTitle;
                                String message = AppStrings.notificationMessage;
                                NotificationService.scheduleWorkoutNotification(
                                  title,
                                  message,
                                  widget.startDate,
                                  widget.endDate,
                                );
                                NotificationModel notification = NotificationModel(
                                  title,
                                  message,
                                  DateTime.now(),
                                );
                                CollectionRefs.instance
                                    .notifications(UserPreferences().getUserInfo()?.uid ?? '')
                                    .add(notification.toJson());
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
                            child: isAddingActivityLoading
                                ? const CupertinoActivityIndicator()
                                : Text(
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
          ),
        );
      }),
    );
  }
}
