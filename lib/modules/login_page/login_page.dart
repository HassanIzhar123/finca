import 'dart:developer';

import 'package:finca/assets/assets.dart';
import 'package:finca/cubits/login/login_cubit.dart';
import 'package:finca/cubits/login/login_state.dart';
import 'package:finca/modules/home_page/home_page.dart';
import 'package:finca/modules/LogIn_page/LogIn_page.dart';
import 'package:finca/modules/signup_page/signup_page.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LogInCubit(),
      child: BlocConsumer<LogInCubit, LogInState>(listener: (context, state) {
        log("state: $state");
        if (state is LogInLoadingState) {
          isLoading = true;
          showLoadingDialog(context);
        } else if (state is LogInSuccessState) {
          isLoading = false;
          if (state.authModel != null) {
            log(state.authModel.toString());
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
          }
        } else if (state is LogInFailedState) {
          isLoading = false;
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      }, builder: (context, state) {
        log("buildState: ${state.toString()} u$isLoading");
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(
              left: 25,
              right: 25,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
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
                    controller: emailController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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
                          borderSide: const BorderSide(color: AppColors.creamColor, width: 0),
                          borderRadius: BorderRadius.circular(8.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.creamColor, width: 0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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
                          borderSide: const BorderSide(color: AppColors.creamColor, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.creamColor, width: 1.0),
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
                        AppStrings.didForgetPassword,
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
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<LogInCubit>().logInUser(emailController.text, passwordController.text);
                          },
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
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUpPage()));
                        },
                        child: Text(
                          AppStrings.dntHaveAccount,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: Assets.rubik,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkGrey,
                          ),
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
                            color: AppColors.lightSilver,
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
          ),
        );
      }),
    );
  }

  void showLoadingDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // User must tap button for close dialog!
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }
}
