import 'dart:developer';

import 'package:finca/assets/assets.dart';
import 'package:finca/cubits/signup/signup_cubit.dart';
import 'package:finca/cubits/signup/signup_state.dart';
import 'package:finca/modules/home_page/home_page.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/views/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isRegistered = false;
  String name = '';
  String email = '';
  String password = '';
  String rePassword = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit, SignUpState>(listener: (context, state) {
        log("state: $state");
        if (state is SignUpLoadingState) {
          isLoading = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Signing Up'),
            ),
          );
        } else if (state is SignUpSuccessState) {
          isLoading = false;
          if (state.isSignedIn) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sign Up Successful'),
              ),
            );
          }
        } else if (state is SignUpFailedState) {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      }, builder: (context, state) {
        log("buildState: ${state.toString()} u$isLoading");
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 55,
                  ),
                  Text(
                    'Create an account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      fontFamily: Assets.rubik,
                      color: const Color(0xFF3B3B3B),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Add your details here and register',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: Assets.rubik,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF3B3B3B),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  CustomTextField(
                    hintText: "Enter your name",
                    icon: Assets.userIcon,
                    showName: false,
                    onChange: (value) {
                      name = value;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    hintText: "Enter your email",
                    icon: Assets.emailIcon,
                    showName: false,
                    onChange: (value) {
                      email = value;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    hintText: "Enter your password",
                    icon: Assets.lockIcon,
                    showName: false,
                    onChange: (value) {
                      password = value;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    hintText: 'Enter your password',
                    icon: Assets.lockIcon,
                    showName: false,
                    onChange: (value) {
                      rePassword = value;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox(
                        side: const BorderSide(
                          color: AppColors.creamColor,
                        ),
                        value: isRegistered,
                        onChanged: (value) {
                          setState(() {
                            isRegistered = !isRegistered;
                          });
                        },
                      ),
                      Flexible(
                        child: Text(
                          AppStrings.agreement,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: Assets.rubik,
                            fontWeight: FontWeight.w300,
                            color: AppColors.darkGrey,
                          ),
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
                            context.read<SignUpCubit>().signUpUser(name, email, password, rePassword, isRegistered);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF24B763),
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
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
                        AppStrings.haveAccountSignup,
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
                            color: Color(0xFFA0A4A8),
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
                              color: const Color(0xFF3B3B3B),
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
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
