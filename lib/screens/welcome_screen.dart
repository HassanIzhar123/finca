import 'package:finca/assets/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
                  'FincaAPP',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: Assets.rubikLight,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF3B3B3B),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 55,
            ),
            Text(
              'Welcome',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: Assets.rubikLight,
                color: const Color(0xFF3B3B3B),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Log in here',
              style: TextStyle(
                fontSize: 14,
                fontFamily: Assets.rubikLight,
                fontWeight: FontWeight.w300,
                color: const Color(0xFF3B3B3B),
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
                hintText: "Enter your email",
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontFamily: Assets.rubikLight,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFD2D2D2),
                ),
                border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xFFD2D2D2), width: 1.0),
                    borderRadius: BorderRadius.circular(8.0)),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFD2D2D2), width: 1.0),
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
                  fontFamily: Assets.rubikLight,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFD2D2D2),
                ),
                border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xFFD2D2D2), width: 1.0),
                    borderRadius: BorderRadius.circular(8.0)),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFD2D2D2), width: 1.0),
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
                    fontFamily: Assets.rubikLight,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF24B763),
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
                backgroundColor: const Color(0xFF24B763),
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: Assets.rubikLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('Login'),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'You do not have an account? Sign up',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: Assets.rubikLight,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3B3B3B),
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
                      color: Color(0xFF3B3B3B),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'and',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: Assets.rubikLight,
                        fontWeight: FontWeight.w600,
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
                      color: Color(0xFF3B3B3B),
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
