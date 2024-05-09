import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finca/assets/assets.dart';
import 'package:finca/main.dart';
import 'package:finca/modules/farms_screen/models/soil_study_model/soil_study_model.dart';
import 'package:finca/modules/home_page/home_page.dart';
import 'package:finca/modules/login_page/login_page.dart';
import 'package:finca/services/storage_service.dart';
import 'package:finca/utils/global_ui.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
    super.initState();
  }

  Future<List<SoilStudyModel>> getDataFromHive() async {
    final myDataBox = Hive.box<SoilStudyModel>('finca_pdfs_box');
    return myDataBox.values.toList();
  }

  void _asyncMethod() async {
    //ask for file and media permission too
    if (await Permission.storage.isGranted) {
      _checkNotificationPermission();
    } else {
      Permission.storage.isDenied.then((value) async {
        if (value) {
          final request = Permission.storage.request();
          final isGranted = await request.isGranted;
          log('isGranted: ${isGranted}');
          if (isGranted) {
            _checkNotificationPermission();
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No se puede continuar sin permisos de almacenamiento'),
                ),
              );
            }
          }
        }
      });
    }
    if (await Permission.notification.isGranted) {
      Future.delayed(
        const Duration(seconds: 2),
        () async {
          if (context.mounted) {
            if (await isInternetAvailable()) {
              checkAndUploadToFirebase();
            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    (UserPreferences().getUserInfo()?.uid == null) ? const LogInPage() : const HomePage(),
              ),
            );
          }
        },
      );
    } else {
      Permission.notification.isDenied.then((value) async {
        if (value) {
          final request = Permission.notification.request();
          final isGranted = await request.isGranted;
          log('isGranted: $isGranted');
          if (isGranted) {
            Future.delayed(const Duration(seconds: 2), () async {
              if (context.mounted) {
                if (await isInternetAvailable()) {
                  checkAndUploadToFirebase();
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        (UserPreferences().getUserInfo()?.uid == null) ? const LogInPage() : const HomePage(),
                  ),
                );
              }
            });
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No se puede continuar sin permisos de notificación'),
                ),
              );
            }
          }
        }
      });
    }
  }

  Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  void checkAndUploadToFirebase() async {
    List<SoilStudyModel> soilStudies = await getDataFromHive();
    for (SoilStudyModel soilStudy in soilStudies) {
      if (soilStudy.path.contains('jpg') || soilStudy.path.contains('jpeg')) {
        String url = await _uploadImage(
          File(soilStudy.path),
          'Crops',
          soilStudy.id,
          true,
        );
        FirebaseFirestore.instance
            .collection('users')
            .doc(soilStudy.uid)
            .collection('crops')
            .doc(soilStudy.id)
            .get()
            .then((value) async {
          if (value.exists) {
            value.reference.update({'farmCoordinatesImage': url});
            var keyToDelete = fincaPdfsBox.keys
                .firstWhere((key) => fincaPdfsBox.get(key)?.path == soilStudy.path, orElse: () => null);
            if (keyToDelete != null) {
              await fincaPdfsBox.delete(keyToDelete);
            }
          }
        });
      } else {
        String url = await _uploadImage(
          File(soilStudy.path),
          'Farms',
          soilStudy.id,
          false,
        );
        FirebaseFirestore.instance
            .collection('users')
            .doc(soilStudy.uid)
            .collection('farms')
            .doc(soilStudy.id)
            .get()
            .then((value) async {
          if (value.exists) {
            List<dynamic> soilStudyLinks = value.data()?['soilStudyLink'];
            if (soilStudyLinks != null) {
              if (!soilStudyLinks.contains(url)) {
                soilStudyLinks.add(url);
                value.reference.update({'soilStudyLink': soilStudyLinks});
                var keyToDelete = fincaPdfsBox.keys
                    .firstWhere((key) => fincaPdfsBox.get(key)?.path == soilStudy.path, orElse: () => null);
                if (keyToDelete != null) {
                  await fincaPdfsBox.delete(keyToDelete);
                }
              }
            } else {
              value.reference.update({
                'soilStudyLink': [url]
              });
              var keyToDelete = fincaPdfsBox.keys
                  .firstWhere((key) => fincaPdfsBox.get(key)?.path == soilStudy.path, orElse: () => null);
              if (keyToDelete != null) {
                await fincaPdfsBox.delete(keyToDelete);
              }
            }
          }
        });
      }
    }
  }

  Future<String> _uploadImage(
    File file,
    String collectionName,
    String pictureId,
    bool isImage,
  ) async {
    var firebaseImagePath = '';
    if (isImage) {
      firebaseImagePath = '$collectionName/$pictureId.jpg';
    } else {
      firebaseImagePath = '$collectionName/$pictureId.pdf';
    }
    log('firebaseImagePath: $firebaseImagePath');
    return StorageService.uploadFile(firebaseImagePath, file).then((value) {
      return value;
    });
  }

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
          child: Image.asset(Assets.splashIcon),
        ),
      ),
    );
  }

  Future<void> _checkNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      Permission.notification.request();
    }
  }
}
