import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:flutter/material.dart';

class FarmItem extends StatelessWidget {
  const FarmItem({super.key, required this.farmModel});

  final FarmModel farmModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.lightGrey,
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  farmModel.image,
                  height: 150.0,
                  width: 100.0,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    farmModel.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkGrey,
                      fontFamily: "Rubik",
                    ),
                  ),
                  Text(
                    farmModel.description,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkGrey,
                      fontFamily: "Rubik",
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.darkGrey,
                      ),
                      Text(
                        farmModel.location,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.darkGrey,
                          fontFamily: "Rubik",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
