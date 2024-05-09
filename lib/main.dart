import 'dart:developer';
import 'dart:io';
import 'package:finca/modules/farms_screen/database/soil_study_adapter.dart';
import 'package:finca/modules/farms_screen/models/soil_study_model/soil_study_model.dart';
import 'package:finca/modules/splash/page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'utils/notification_service.dart';
import 'utils/user_preferences.dart';
import 'wrappers/firebase_service_wrapper.dart';

late Box<SoilStudyModel> fincaPdfsBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.initialize();
  await UserPreferences.init();
  await FirebaseServiceWrapper().init();
  await Hive.initFlutter();
  Hive.registerAdapter(SoilStudyAdapter());
  fincaPdfsBox = await Hive.openBox<SoilStudyModel>('finca_pdfs_box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    log('userId: ${UserPreferences()
        .getUserInfo()
        ?.uid}');
    return MaterialApp(
      title: 'Finca',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
