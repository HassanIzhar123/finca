import 'dart:developer';
import 'package:finca/assets/assets.dart';
import 'package:finca/modules/activity_screen/pages/step_two_new_activity_screen.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/views/custom_text_field.dart';
import 'package:flutter/material.dart';

class StepOneNewActivity extends StatefulWidget {
  const StepOneNewActivity({super.key});

  @override
  _StepOneNewActivityState createState() => _StepOneNewActivityState();
}

class _StepOneNewActivityState extends State<StepOneNewActivity> {
  DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime startTime = DateTime(0, 0, 0, DateTime.now().hour, DateTime.now().minute, DateTime.now().second);
  DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime endTime = DateTime(0, 0, 0, DateTime.now().hour, DateTime.now().minute, DateTime.now().second);
  bool isAllDay = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(
              top: 8,
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.newActivity,
                  style: TextStyle(
                    color: AppColors.greenColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  AppStrings.stepOneOfFour,
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                _buildDatePicker(AppStrings.startDate, startDate, (value) {
                  setState(() {
                    startDate = value;
                  });
                }),
                const SizedBox(height: 20),
                _buildTimePicker(AppStrings.startTime, (value) {
                  setState(() {
                    log("before: ${startTime.toString()}");
                    startTime = value;
                    log("before: ${startTime.toString()}");
                  });
                }),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Theme(
                      data: ThemeData(
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4), // Adjust the values as needed
                      ),
                      child: Checkbox(
                        value: isAllDay,
                        checkColor: AppColors.white,
                        activeColor: AppColors.greenColor,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (newValue) {
                          setState(() {
                            isAllDay = !isAllDay;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      AppStrings.allDay,
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDatePicker(AppStrings.endDate, endDate, (value) {
                  setState(() {
                    endDate = value;
                  });
                }),
                const SizedBox(height: 20),
                _buildTimePicker(AppStrings.endTime, (value) {
                  setState(() {
                    endTime = value;
                  });
                }),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    startDate = DateTime(startDate.year, startDate.month, startDate.day, startTime.hour,
                        startTime.minute, startTime.second);
                    endDate = DateTime(
                        endDate.year, endDate.month, endDate.day, endTime.hour, endTime.minute, endTime.second);
                    if (endDate.isBefore(startDate)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(AppStrings.endDateSmallerThanStartDate),
                        ),
                      );
                      return;
                    }
                    if (!isAllDay && endDate.isAtSameMomentAs(startDate)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(AppStrings.endDateEqualToStartDate),
                        ),
                      );
                      return;
                    }
                    if (!isAllDay && endDate.difference(startDate).inDays < 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(AppStrings.oneDayGap),
                        ),
                      );
                      return;
                    }
                    if (isAllDay) {
                      startTime = DateTime(0, 0, 0, 8, 0, 0);
                      endTime = DateTime(0, 0, 0, 8, 0, 0);
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StepTwoNewActivityScreen(
                          startDate: startDate,
                          startTime: startTime,
                          endDate: endDate,
                          endTime: endTime,
                          isAllDay: isAllDay,
                        ),
                      ),
                    );
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(String title, DateTime date, Function(DateTime) onDateSelected) {
    return CustomTextField(
      name: title,
      hintText: AppStrings.selectDate,
      borderColor: const Color(0xFFD9D9D9),
      icon: Assets.calendarIcon,
      iconOnLeft: false,
      isCalendarPicker: true,
      isDatePicker: true,
      initialSelectedDate: date,
      onDateSelected: (selectedDate) {
        log('onDateSelected: $selectedDate');
        onDateSelected(selectedDate);
      },
    );
  }

  Widget _buildTimePicker(String title, Function(DateTime) onDateSelected) {
    return CustomTextField(
      name: title,
      hintText: AppStrings.selectTime,
      borderColor: const Color(0xFFD9D9D9),
      icon: Assets.calendarIcon,
      iconOnLeft: false,
      isCalendarPicker: true,
      isDatePicker: false,
      isEnabled: isAllDay ? false : true,
      onDateSelected: (selectedDate) {
        onDateSelected(selectedDate);
      },
    );
  }
}