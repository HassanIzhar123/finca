import 'dart:developer';

import 'package:finca/assets/assets.dart';
import 'package:finca/modules/activity_screen/pages/step_three_new_activity_screen.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';

class StepTwoNewActivityScreen extends StatefulWidget {
  const StepTwoNewActivityScreen({super.key});

  @override
  State<StepTwoNewActivityScreen> createState() => _StepTwoNewActivityScreenState();
}

class _StepTwoNewActivityScreenState extends State<StepTwoNewActivityScreen> {
  String selectedActivity = "Insecticide";

  @override
  Widget build(BuildContext context) {
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
                  'New Activity',
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
                  '*Select an activity',
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                RadioGroup<String>.builder(
                  groupValue: selectedActivity,
                  activeColor: AppColors.greenColor,
                  onChanged: (value) {
                    setState(() {
                      selectedActivity = value!;
                    });
                  },
                  items: AppStrings.activityTypes,
                  itemBuilder: (item) => RadioButtonBuilder(
                    item,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StepThreeNewActivityScreen(
                          selectedActivityType: selectedActivity,
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
