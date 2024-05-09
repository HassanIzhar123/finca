import 'package:finca/assets/assets.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/views/custom_text_field.dart';
import 'package:flutter/material.dart';

import 'step_three_remaining_new_activity.dart';

class StepThreeNewActivityScreen extends StatefulWidget {
  const StepThreeNewActivityScreen({
    super.key,
    required this.selectedActivityType,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.isAllDay,
  });

  final DateTime startDate, startTime, endDate, endTime;
  final bool isAllDay;
  final String selectedActivityType;

  @override
  State<StepThreeNewActivityScreen> createState() => _StepThreeNewActivityScreenState();
}

class _StepThreeNewActivityScreenState extends State<StepThreeNewActivityScreen> {
  String? chemicalName, details;

  double? amount;

  @override
  Widget build(BuildContext context) {
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
                CustomTextField(
                  name: '*Nombre',
                  hintText: "Escriba un nombre químico",
                  onChange: (value) {
                    chemicalName = value;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  name: '*Cantidad',
                  hintText: "0000",
                  isNumberTextField: true,
                  onChange: (value) {
                    amount = double.parse(value);
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  name: '*Detalle',
                  hintText: "Escriba detalles adicionales aquí",
                  onChange: (value) {
                    details = value;
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    if (chemicalName?.isEmpty ?? true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            AppStrings.chemicalNameEmpty,
                          ),
                        ),
                      );
                      return;
                    } else if (amount == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            AppStrings.amountEmpty,
                          ),
                        ),
                      );
                      return;
                    } else if (details?.isEmpty ?? true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            AppStrings.detailsEmpty,
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StepThreeRemainingNewActivity(
                          startDate: widget.startDate,
                          startTime: widget.startTime,
                          endDate: widget.endDate,
                          endTime: widget.endTime,
                          isAllDay:widget.isAllDay,
                          selectedActivityType: widget.selectedActivityType,
                          chemicalName: chemicalName!,
                          amount: amount!,
                          details: details!,
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
}
