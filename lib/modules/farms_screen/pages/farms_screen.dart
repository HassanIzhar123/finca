import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finca/assets/assets.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/modules/farms_screen/pages/step_one_new_farm_screen.dart';
import 'package:finca/modules/farms_screen/views/farm_item.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class FarmsScreen extends StatefulWidget {
  const FarmsScreen({super.key});

  @override
  State<FarmsScreen> createState() => _FarmsScreenState();
}

class _FarmsScreenState extends State<FarmsScreen> {
  List<FarmModel> farms = [];
  Stream<QuerySnapshot<Map<String, dynamic>>> farmStream = const Stream.empty();

  @override
  void initState() {
    farmStream = FirebaseFirestore.instance
        .collection('users')
        .doc(UserPreferences().getUserInfo()?.uid ?? '')
        .collection('farms')
        .snapshots();
    farmStream.listen((event) {
      farms.clear();
      farms = event.docs.map((e) {
        var data = FarmModel.fromJson(e.data());    String cropId = data.cropId;
        FirebaseFirestore.instance
            .collection('users')
            .doc(UserPreferences().getUserInfo()?.uid ?? '')
            .collection('crops')
            .doc(cropId)
            .snapshots()
            .listen((value) {
          log("croipData: ${value.data()}");
          if (value.data() != null) {
            data.crop = Crop.fromJson(value.data()!);
          } else {
            data.crop = Crop.empty();
          }
          setState(() {});
        });
        // getCrop(data.cropId).then((value) {
        //   data.crop = value;
        //   setState(() {});
        // });
        return data;
      }).toList();
      log('farms: $farms');
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.lightGreen,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 15,
                  right: 15,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppStrings.addYourProperties,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: AppColors.darkGrey,
                          fontFamily: Assets.rubik,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await openFarmForm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenColor,
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 20,
                          right: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        AppStrings.newFarm,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: Assets.rubik,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: farms.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return FarmItem(
                  index: index,
                  itemSize: farms.length,
                  farmModel: farms[index],
                  onDeleteTapped: (FarmModel farmModel) {
                    log('hi i am here');
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(UserPreferences().getUserInfo()?.uid ?? '')
                        .collection('farms')
                        .doc(farmModel.farmId)
                        .delete();
                  },
                  onEditTapped: (FarmModel farmModel) async {
                    await openFarmForm(farm: farms[index], isUpdating: true);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static Future<Crop> getCrop(String cropId) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(UserPreferences().getUserInfo()?.uid ?? '')
        .collection('crops')
        .doc(cropId)
        .get()
        .timeout(const Duration(seconds: 10))
        .then((value) {
      log('value: ${value.data()}');
      if (value.data() != null) {
        return Crop.fromJson(value.data()!);
      } else {
        return Crop.empty();
      }
    });
  }

  Future<void> openFarmForm({
    bool isUpdating = false,
    FarmModel? farm,
  }) async {
    if (await Permission.location.isGranted) {
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StepOneNewFarmScreen(
              isUpdating: isUpdating,
              farm: farm,
            ),
          ),
        );
      }
    } else {
      await Permission.location.request();
      if (await Permission.location.isGranted) {
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => StepOneNewFarmScreen(
                isUpdating: isUpdating,
                farm: farm,
              ),
            ),
          );
        }
      } else if (await Permission.location.isDenied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please allow location permission to continue'),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please allow location permission in settings to continue'),
            ),
          );
        }
      }

      log('Permission.location: ${await Permission.location.isGranted}');
    }
  }
}
