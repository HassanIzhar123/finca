import 'package:finca/assets/assets.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:flutter/material.dart';

class NewPropertySaveScreen extends StatefulWidget {
  const NewPropertySaveScreen({super.key});

  @override
  State<NewPropertySaveScreen> createState() => _NewPropertySaveScreenState();
}

class _NewPropertySaveScreenState extends State<NewPropertySaveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF167A4A), Color(0xFF00FF85)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.newPropertySave,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                  fontFamily: Assets.rubik,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
