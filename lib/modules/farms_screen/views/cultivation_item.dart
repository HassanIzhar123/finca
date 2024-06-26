import 'package:finca/assets/assets.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CultivationItem extends StatelessWidget {
  const CultivationItem({super.key, required this.cultivationName});

  final String cultivationName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.purple,
        ),
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Text(
          cultivationName,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
            fontFamily: Assets.rubik,
          ),
        ),
      ),
    );
  }
}
