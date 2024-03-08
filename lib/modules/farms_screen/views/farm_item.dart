import 'package:finca/assets/assets.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/farms_screen/views/CultivationItem.dart';
import 'package:finca/modules/farms_screen/views/crop_item.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FarmItem extends StatelessWidget {
  const FarmItem({
    super.key,
    required this.index,
    required this.itemSize,
    required this.farmModel,
    required this.onDeleteTapped,
  });

  final int index, itemSize;
  final FarmModel farmModel;
  final Function(FarmModel farmModel) onDeleteTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: index != itemSize ? 10 : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.lightGrey,
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: Image.asset(
                  Assets.mapIcon,
                  height: 100.0,
                  width: 100.0,
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    child: Text(
                      farmModel.farmName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.darkGrey,
                        fontFamily: Assets.rubik,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    child: Text(
                      farmModel.description.isEmpty ? '-' : farmModel.description,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGrey,
                        fontFamily: Assets.rubik,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.darkGrey,
                      ),
                      Text(
                        farmModel.location.isNotEmpty ? farmModel.location : '-',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.darkGrey,
                          fontFamily: Assets.rubik,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 15,
              left: 25,
              right: 25,
              bottom: 15,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Crop 1",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkGrey,
                    fontFamily: Assets.rubik,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 20,
                  child: ListView.builder(
                    itemCount: 2,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      // return CropItem(cropName: "Variety $index");
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Cultivation 2',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkGrey,
                    fontFamily: Assets.rubik,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 20,
                  child: ListView.builder(
                    itemCount: 2,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return CultivationItem(
                        cultivationName: 'Variety $index',
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Container(
                  height: .5,
                  color: AppColors.secondarySilver,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          Assets.share,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          AppStrings.share,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.darkGrey,
                            fontFamily: Assets.rubik,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        onDeleteTapped(farmModel);
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            Assets.delete,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            AppStrings.delete,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.red,
                              fontFamily: Assets.rubik,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
