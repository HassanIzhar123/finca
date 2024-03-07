import 'package:finca/modules/home_page/home_page.dart';
import 'package:finca/modules/login_page/login_page.dart';
import 'package:flutter/material.dart';

import 'utils/user_preferences.dart';
import 'wrappers/firebase_service_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  await FirebaseServiceWrapper().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: (UserPreferences().getUserInfo()?.uid == null)
          ? const LogInPage()
          : const HomePage(),
    );
  }
}
