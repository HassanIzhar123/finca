import 'dart:developer';

import 'package:finca/assets/assets.dart';
import 'package:finca/cubits/activity/activity_cubit.dart';
import 'package:finca/cubits/activity/activity_state.dart';
import 'package:finca/modules/activity_screen/pages/step_three_new_activity_screen.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_radio_button/group_radio_button.dart';

class StepTwoNewActivityScreen extends StatefulWidget {
  const StepTwoNewActivityScreen({
    super.key,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.isAllDay,
  });

  final DateTime startDate, startTime, endDate, endTime;
  final bool isAllDay;

  @override
  State<StepTwoNewActivityScreen> createState() => _StepTwoNewActivityScreenState();
}

class _StepTwoNewActivityScreenState extends State<StepTwoNewActivityScreen> {
  String? selectedActivity;

  List<Tag> activityTypes = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivityCubit()..getAllActivities(),
      child: BlocConsumer<ActivityCubit, ActivityState>(
        listener: (context, state) {
          if (state is ActivityLoadingState) {
            isLoading = true;
          }
          if (state is ActivitySuccessState) {
            log("ActivitySuccessState");
            activityTypes = state.activities;
            isLoading = false;
          }
          if (state is ActivityFailedState) {
            log("ActivityFailedState");
            isLoading = false;
          }
        },
        builder: (context, state) {
          return _buildBody();
        },
      ),
    );
  }

  Widget _buildBody() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  'Step 2 of 4',
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '*Seleccionar una actividad',
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                isLoading
                    ? const SizedBox(
                        height: 300,
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      )
                    : RadioGroup<String>.builder(
                        groupValue: selectedActivity ?? '',
                        activeColor: AppColors.greenColor,
                        onChanged: (value) {
                          setState(() {
                            selectedActivity = value!;
                          });
                        },
                        items: activityTypes.map((e) => e.name).toList(),
                        itemBuilder: (item) => RadioButtonBuilder(
                          item,
                        ),
                      ),
                GestureDetector(
                  onTap: () {
                    if (selectedActivity != null && (selectedActivity?.isNotEmpty ?? false)) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StepThreeNewActivityScreen(
                            selectedActivityType: selectedActivity!,
                            startDate: widget.startDate,
                            startTime: widget.startTime,
                            endDate: widget.endDate,
                            endTime: widget.endTime,
                            isAllDay: widget.isAllDay,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Por favor, selecciona una actividad',
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
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
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
