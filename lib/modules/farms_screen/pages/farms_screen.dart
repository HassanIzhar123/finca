import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finca/assets/assets.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/modules/farms_screen/pages/map_sample.dart';
import 'package:finca/modules/farms_screen/pages/step_one_new_farm_screen.dart';
import 'package:finca/modules/farms_screen/views/farm_item.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/utils/global_ui.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:finca/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FarmsScreen extends StatefulWidget {
  const FarmsScreen({super.key});

  @override
  State<FarmsScreen> createState() => _FarmsScreenState();
}

class _FarmsScreenState extends State<FarmsScreen> {
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
                        if (await Utils().checkIfInternetIsAvailable()) {
                          if (context.mounted) {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => const StepOneNewFarmScreen()));
                          }
                        } else {
                          GlobalUI.showSnackBar('Please turn on internet!');
                        }

                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapSample()));
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
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(UserPreferences().getUserInfo()?.uid ?? '')
                  .collection('farms')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error'),
                  );
                }
                if (snapshot.data == null) {
                  return const Center(
                    child: Text('No data found'),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No data found'),
                  );
                }
                final farms = snapshot.data!.docs.map((e) {
                  final data = FarmModel.fromJson(e.data());
                  return data;
                }).toList();
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: farms.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return FarmItem(
                      index: index,
                      itemSize: farms.length,
                      farmModel: farms[index],
                      onDeleteTapped: (FarmModel farmModel) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(UserPreferences().getUserInfo()?.uid ?? '')
                            .collection('farms')
                            .doc(farmModel.farmId)
                            .delete();
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<Crop> getCrop(String cropId) async {
    final crop = await FirebaseFirestore.instance
        .collection('users')
        .doc(UserPreferences().getUserInfo()?.uid ?? '')
        .collection('crops')
        .doc(cropId)
        .get();
    return Crop.fromJson(crop.data()!);
  }
}
