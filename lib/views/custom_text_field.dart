import 'package:finca/assets/assets.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.name,
    required this.hintText,
    this.borderColor = AppColors.creamColor,
    this.multiLine = false,
  });

  final Color borderColor;
  final String name;
  final String hintText;
  final bool multiLine;

  @override
  Widget build(BuildContext context) {
    return textFieldContainer(name, hintText, multiLine: multiLine);
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
        const SizedBox(
          height: 5,
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
                borderSide: BorderSide(color: borderColor, width: 2.0),
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor, width: 2.0),
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
