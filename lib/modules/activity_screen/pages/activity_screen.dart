import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finca/assets/assets.dart';
import 'package:finca/cubits/activity/activity_cubit.dart';
import 'package:finca/cubits/activity/activity_state.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/activity_screen/pages/step_one_new_activity_screen.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:finca/views/table_calender.dart';
import 'package:flutter/cupertino.dart';
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
  Stream<List<FarmModel>> farms = const Stream.empty();

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
          log("ActiviityState: $state");
          if (state is FarmsLoadingState) {
            isFarmsLoading = true;
          } else if (state is FarmsSuccessState) {
            isFarmsLoading = false;
            farms = state.farms;
          } else if (state is FarmsFailedState) {
            isFarmsLoading = false;
          }else{
            isFarmsLoading = false;
            log('not handled');
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    farmHeader("Property: $farm"),
                    !isNoteBookSelected ? calendarWidget() : noteBookWidget(),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => StepOneNewActivity()));
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

  Widget calendarWidget() {
    return Column(
      children: [
        TableCalender(
          focusedDay: focusedDay,
          isNoteBookSelected: isNoteBookSelected,
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
          onFocusedDayChanged: (DateTime focusedDay) {
            this.focusedDay = focusedDay;
          },
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: 10,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Activity $index'),
              subtitle: Text('Activity $index'),
              trailing: SvgPicture.asset(
                Assets.addIcon,
                height: 15,
                width: 15,
                colorFilter: const ColorFilter.mode(AppColors.greenColor, BlendMode.srcIn),
              ),
            );
          },
        )
      ],
    );
  }

  Widget noteBookWidget() {
    return Column(
      children: [
        _CalendarHeader(
          isNoteBookSelected: isNoteBookSelected,
          focusedDay: focusedDay,
          onLeftArrowTap: () {
            setState(() {
              focusedDay = DateTime(focusedDay.year, focusedDay.month - 1, focusedDay.day);
            });
          },
          onRightArrowTap: () {
            setState(() {
              focusedDay = DateTime(focusedDay.year, focusedDay.month + 1, focusedDay.day);
            });
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
    );
  }

  Widget farmHeader(String headerText) {
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
                      });
                    },
                  );
                },
                child: isFarmsLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        'Change',
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
  Stream<List<FarmModel>> farms,
  Function(String farm) onFarmSelected,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) => LayoutBuilder(
      builder: (context, constraints) => SimpleDialog(
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(15),
        title: const Text('Select Farm'),
        children: [
          SizedBox(
            height: constraints.maxHeight * .4, // 70% height
            width: constraints.maxWidth * .9,
            child: StreamBuilder(
              stream: farms,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error'),
                  );
                }
                if (snapshot.data == null) {
                  return const Center(
                    child: Text('No data found'),
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No data found'),
                  );
                }
                final farms = snapshot.data!;
                return ListView.builder(
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
                );
              },
            ),
          )
        ],
      ),
    ),
  );
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.isNoteBookSelected,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onCalendarTap,
    required this.onNotebookTap,
  });

  final bool isNoteBookSelected;
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onCalendarTap;
  final VoidCallback onNotebookTap;

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SizedBox(width: 10),
            Text(
              headerText,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 10),
            CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.zero,
              onPressed: onLeftArrowTap,
              child: const Icon(
                Icons.chevron_left,
                color: Color(0xFF333333),
              ),
            ),
            CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.zero,
              onPressed: onRightArrowTap,
              child: const Icon(
                Icons.chevron_right,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
        Row(
          children: [
            CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.zero,
              onPressed: onCalendarTap,
              child: SvgPicture.asset(
                Assets.calendarIcon,
                colorFilter: ColorFilter.mode(
                  !isNoteBookSelected ? AppColors.greenColor : const Color(0xFF797979),
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.zero,
              onPressed: onNotebookTap,
              child: SvgPicture.asset(
                Assets.notebookIcon,
                colorFilter: ColorFilter.mode(
                  isNoteBookSelected ? AppColors.greenColor : const Color(0xFF797979),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
