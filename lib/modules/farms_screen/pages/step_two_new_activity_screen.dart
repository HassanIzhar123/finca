import 'package:finca/assets/assets.dart';
import 'package:finca/modules/farms_screen/pages/step_three_new_farm_screen.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:flutter/material.dart';

import 'step_three_new_activity_screen.dart';

class StepTwoNewActivityScreen extends StatelessWidget {
  const StepTwoNewActivityScreen({super.key});

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
                Column(
                  children: [
                    RadioListTile(
                      title: const Text("Male"),
                      value: "male",
                      groupValue: 0,
                      onChanged: (value) {},
                    ),
                    RadioListTile(
                      title: const Text("Female"),
                      value: "female",
                      groupValue: 0,
                      onChanged: (value) {},
                    ),
                    RadioListTile(
                      title: const Text("Other"),
                      value: "other",
                      groupValue: 1,
                      onChanged: (value) {},
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const StepThreeNewActivityScreen()));
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
}
