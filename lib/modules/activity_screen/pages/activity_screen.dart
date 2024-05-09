import 'dart:async';
import 'dart:developer';
import 'package:finca/assets/assets.dart';
import 'package:finca/cubits/activity/activity_cubit.dart';
import 'package:finca/cubits/activity/activity_state.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/activity_screen/models/activity_model.dart';
import 'package:finca/modules/activity_screen/pages/step_one_new_activity_screen.dart';
import 'package:finca/modules/activity_screen/views/calendar_view.dart';
import 'package:finca/modules/activity_screen/views/notebook_view.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool isNoteBookSelected = false;
  DateTime focusedDay = DateTime.now();
  String farm = 'Farm';
  bool isFarmsLoading = false;
  List<FarmModel> farms = <FarmModel>[];
  List<DateTime> hoursInDay = [];
  bool isActivitiesLoading = true;
  List<ActivityModel> activities = [];
  List<ActivityModel> calendarFilteredActivities = [];
  List<ActivityModel> notebookFilteredActivities = [];
  Stream<List<ActivityModel>> activityStream = const Stream.empty();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final activityCubit = ActivityCubit();
        activityCubit.getAllFarms();
        return activityCubit;
      },
      child: BlocConsumer<ActivityCubit, ActivityState>(
        listener: (context, state) {
          if (state is FarmsLoadingState) {
            isFarmsLoading = true;
          } else if (state is FarmsSuccessState) {
            isFarmsLoading = false;
            farms = state.farms;
            if (farms.isNotEmpty) {
              farm = farms[0].farmName;
              context.read<ActivityCubit>().getActivities(farm, focusedDay);
            }
          } else if (state is FarmsFailedState) {
            isFarmsLoading = false;
          } else if (state is ActivityDateLoadingState) {
            isActivitiesLoading = true;
          } else if (state is ActivityDateSuccessState) {
            activityStream = state.activities;
            activityStream.listen((event) {
              activities = event;
              calendarFilteredActivities = activities
                  .where((x) =>
                      x.startDate.year == focusedDay.year &&
                      x.startDate.month == focusedDay.month &&
                      x.startDate.day == focusedDay.day)
                  .toList();
              calendarFilteredActivities.sort((a, b) => a.isAllDay ? -1 : 1);
              setState(() {});
            });
            isActivitiesLoading = false;
          } else if (state is ActivityDateFailedState) {
            isActivitiesLoading = false;
          } else {
            isFarmsLoading = false;
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    farmHeader(context, "Propiedad: $farm"),
                    !isNoteBookSelected
                        ? CalendarView(
                            isNoteBookSelected: isNoteBookSelected,
                            focusedDay: focusedDay,
                            activities: activities,
                            calendarFilteredActivities: calendarFilteredActivities,
                            onFocusedDayChanged: (focusedDay) {
                              this.focusedDay = focusedDay;
                              context.read<ActivityCubit>().getActivities(farm, focusedDay);
                            },
                            onNotebookTap: () {
                              setState(() {
                                isNoteBookSelected = true;
                              });
                            },
                            onCalendarTap: () {
                              setState(() {
                                isNoteBookSelected = false;
                              });
                            },
                          )
                        : NoteBookView(
                            isNoteBookSelected: isNoteBookSelected,
                            focusedDay: focusedDay,
                            activities: activities,
                            onFocusedDayChanged: (focusedDay) {
                              this.focusedDay = focusedDay;
                              context.read<ActivityCubit>().getActivities(farm, focusedDay);
                            },
                            onCalendarTap: () {
                              setState(() {
                                isNoteBookSelected = false;
                              });
                            },
                            onNotebookTap: () {
                              setState(() {
                                isNoteBookSelected = true;
                              });
                            },
                          ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const StepOneNewActivity()));
              },
              backgroundColor: AppColors.greenColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              child: SvgPicture.asset(
                Assets.addIcon,
                height: 15,
                width: 15,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget farmHeader(BuildContext context, String headerText) {
    return Column(
      children: [
        const Divider(),
        Container(
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                headerText,
                style: TextStyle(
                  color: const Color(0xFF3B3B3B),
                  fontFamily: Assets.rubik,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () {
                  openFarmsDialog(
                    context,
                    farms,
                    (String farm) {
                      setState(() {
                        this.farm = farm;
                        context.read<ActivityCubit>().getActivities(farm, focusedDay);
                      });
                    },
                  );
                },
                child: isFarmsLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator())
                    : Text(
                        'Cambiar',
                        style: TextStyle(
                          color: AppColors.greenColor,
                          fontFamily: Assets.rubik,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}

void openFarmsDialog(
  BuildContext context,
  List<FarmModel> farms,
  Function(String farm) onFarmSelected,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) => LayoutBuilder(
      builder: (context, constraints) => SimpleDialog(
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(15),
        title: const Text('Seleccionar Finca'),
        children: [
          SizedBox(
            height: constraints.maxHeight * .4, // 70% height
            width: constraints.maxWidth * .9,
            child: farms.isEmpty
                ? const Center(
                    child: Text('No data found'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: farms.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          onFarmSelected(farms[index].farmName);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Text(
                            farms[index].farmName,
                            style: TextStyle(
                              color: AppColors.darkGrey,
                              fontFamily: Assets.rubik,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    ),
  );
}
