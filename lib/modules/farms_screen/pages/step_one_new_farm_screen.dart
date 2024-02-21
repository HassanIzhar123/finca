import 'package:finca/assets/assets.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StepOneNewFarmScreen extends StatefulWidget {
  const StepOneNewFarmScreen({super.key});

  @override
  State<StepOneNewFarmScreen> createState() => _StepOneNewFarmScreenState();
}

class _StepOneNewFarmScreenState extends State<StepOneNewFarmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset(Assets.backIcon),
                  Text(
                    "New Farm",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.greenColor,
                      fontFamily: Assets.rubik,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
