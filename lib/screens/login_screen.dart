import 'package:finca/assets/assets.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 25,
          right: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                SvgPicture.asset(
                  Assets.appIcon,
                  height: 100,
                  width: 100,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: Assets.rubik,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 55,
            ),
            Text(
              AppStrings.welcome,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: Assets.rubik,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              AppStrings.loginHere,
              style: TextStyle(
                fontSize: 14,
                fontFamily: Assets.rubik,
                fontWeight: FontWeight.w300,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            TextField(
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                prefixIcon: SizedBox(
                  height: 10,
                  width: 10,
                  child: Center(
                    child: SvgPicture.asset(
                      Assets.emailIcon,
                    ),
                  ),
                ),
                hintText: AppStrings.enterEmail,
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontFamily: Assets.rubik,
                  fontWeight: FontWeight.w400,
                  color: AppColors.creamColor,
                ),
                border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColors.creamColor, width: 0),
                    borderRadius: BorderRadius.circular(8.0)),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.creamColor, width: 0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                prefixIcon: SizedBox(
                  height: 10,
                  width: 10,
                  child: Center(
                    child: SvgPicture.asset(
                      Assets.lockIcon,
                    ),
                  ),
                ),
                hintText: "Enter your password",
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontFamily: Assets.rubik,
                  fontWeight: FontWeight.w400,
                  color: AppColors.creamColor,
                ),
                border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: AppColors.creamColor, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0)),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.creamColor, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Did you forget your password?',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: Assets.rubik,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greenColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 35,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenColor,
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                AppStrings.login,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: Assets.rubik,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.dntHaveAccount,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: Assets.rubik,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 55,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 1,
                    decoration: const BoxDecoration(
                      color: AppColors.lightGrey,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      AppStrings.theContinue,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: Assets.nunito,
                        fontWeight: FontWeight.w400,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 1,
                    decoration: const BoxDecoration(
                      color: Color(0xFFA0A4A8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: IconButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.all(12),
                        ),
                      ),
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        Assets.googleLogo,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1877F2),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: IconButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.all(12),
                        ),
                      ),
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        Assets.facebookLogo,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
