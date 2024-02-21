import 'package:finca/assets/assets.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/farms_screen/pages/step_one_new_farm_screen.dart';
import 'package:finca/modules/farms_screen/views/farm_item.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
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
                    const Expanded(
                      child: Text(
                        AppStrings.addYourProperties,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: AppColors.darkGrey,
                          fontFamily: "Rubik",
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => const StepOneNewFarmScreen()));
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
                    // Expanded(
                    //   child: ListView.builder(
                    //     shrinkWrap: true,
                    //     itemBuilder: (context, index) {
                    //       return FarmItem(
                    //         farmModel: FarmModel(
                    //             title: "Hey",
                    //             description: "hi",
                    //             location: "pak",
                    //             image:
                    //                 "data:image/jpeg;base64,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"),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
