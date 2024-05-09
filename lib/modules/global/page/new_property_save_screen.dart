import 'package:finca/assets/assets.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewPropertySaveScreen extends StatefulWidget {
  const NewPropertySaveScreen({super.key, this.isActivity = false, this.isUpdating = false});

  final bool isUpdating;
  final bool isActivity;

  @override
  State<NewPropertySaveScreen> createState() => _NewPropertySaveScreenState();
}

class _NewPropertySaveScreenState extends State<NewPropertySaveScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        if (widget.isActivity ?? false) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          if (!widget.isUpdating) {
            Navigator.pop(context);
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              if (widget.isActivity ?? false) {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                if (!widget.isUpdating) {
                  Navigator.pop(context);
                }
              }
            }
          });
          return true;
        },
        child: Container(
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
                SvgPicture.asset(Assets.savePropertyIcon),
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
      ),
    );
  }
}
