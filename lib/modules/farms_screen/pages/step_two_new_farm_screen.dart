import 'package:finca/assets/assets.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StepTwoNewFarmScreen extends StatefulWidget {
  const StepTwoNewFarmScreen({super.key});

  @override
  State<StepTwoNewFarmScreen> createState() => _StepTwoNewFarmScreenState();
}

class _StepTwoNewFarmScreenState extends State<StepTwoNewFarmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
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
                          AppStrings.stepOne,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkGrey,
                            fontFamily: Assets.rubik,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          AppStrings.stepOneDescription,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
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
              textFieldContainer(AppStrings.name, "Write name"),
              const SizedBox(
                height: 20,
              ),
              textFieldContainer(AppStrings.size, "0000"),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppStrings.soilType,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGrey,
                  fontFamily: Assets.rubik,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              textFieldContainer(AppStrings.size, "0000", multiLine: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget textFieldContainer(
    String name,
    String hintText, {
    bool multiLine = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
            fontFamily: Assets.rubik,
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
          child: TextField(
            maxLines: multiLine ? 5 : null,
            keyboardType: multiLine ? TextInputType.multiline : null,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 16,
                fontFamily: Assets.rubik,
                fontWeight: FontWeight.w400,
                color: AppColors.creamColor,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.creamColor, width: 1.0),
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.creamColor, width: 1.0),
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
