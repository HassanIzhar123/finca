import 'package:finca/assets/assets.dart';
import 'package:finca/modules/farms_screen/pages/step_three_new_farm_screen.dart';
import 'package:finca/modules/farms_screen/pages/step_two_new_activity_screen.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/views/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StepOneNewActivity extends StatefulWidget {
  @override
  _StepOneNewActivityState createState() => _StepOneNewActivityState();
}

class _StepOneNewActivityState extends State<StepOneNewActivity> {
  final List<String> soilStudies = ['Soil Study 1', 'Soil Study 2', 'Soil Study 3'];
  final List<String> certifications = ['Certification 1', 'Certification 2', 'Certification 3'];

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
                  'Step 1 of 4',
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                const CustomTextField(name: '*Start date', hintText: "Select Date"),
                const SizedBox(height: 20),
                const CustomTextField(name: '*Start Time', hintText: "Select Time"),
                ListTile(
                  title: const Text('Option 1'),
                  leading: Radio<int>(
                    value: 1,
                    groupValue: 1,
                    activeColor: Colors.red,
                    // Change the active radio button color here
                    fillColor: MaterialStateProperty.all(Colors.red),
                    // Change the fill color when selected
                    splashRadius: 20,
                    // Change the splash radius when clicked
                    onChanged: (int? value) {},
                  ),
                ),
                const SizedBox(height: 20),
                const CustomTextField(name: '*End date', hintText: "Select Date"),
                const SizedBox(height: 20),
                const CustomTextField(name: '*Start Time', hintText: "Select Date"),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => const StepTwoNewActivityScreen()));
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
