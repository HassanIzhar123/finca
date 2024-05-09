import 'package:finca/assets/assets.dart';
import 'package:finca/enums/sowing_enum.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/farms_screen/views/cultivation_item.dart';
import 'package:finca/modules/farms_screen/views/crop_item.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/views/step_progress_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FarmItem extends StatelessWidget {
  const FarmItem({
    super.key,
    required this.index,
    required this.itemSize,
    required this.farmModel,
    required this.onDeleteTapped,
    required this.onEditTapped,
  });

  final int index, itemSize;
  final FarmModel farmModel;
  final Function(FarmModel farmModel) onDeleteTapped;
  final Function(FarmModel farmModel) onEditTapped;
  final _stepCircleRadius = 5.0;
  final _stepProgressViewHeight = 60.0;
  final Color _activeColor = AppColors.greenColor;
  final Color _inactiveColor = Colors.grey;
  final TextStyle _stepStyle = const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold);

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: farmModel.crop?.farmCoordinatesImage != null ||
                            (farmModel.crop?.farmCoordinatesImage.isNotEmpty ?? false)
                        ? SizedBox(
                            height: 100.0,
                            width: 100.0,
                            child: BlurHash(
                              hash: 'LEHLk~WB2yk8pyo0adR*.7kCMdnj',
                              image: farmModel.crop?.farmCoordinatesImage,
                              imageFit: BoxFit.cover,
                              decodingHeight: 100,
                              decodingWidth: 100,
                            ),
                          )
                        : Image.asset(
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
                            '-',
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
              IconButton(
                onPressed: () {
                  onEditTapped.call(farmModel);
                },
                icon: const Icon(
                  Icons.edit,
                  size: 15,
                ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    itemCount: farmModel.crop?.cropNames.length ?? 0,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return CultivationItem(
                        cultivationName: farmModel.crop?.cropNames[index] ?? 'Not Found',
                      );
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
                CropVarietyItem(varieties: farmModel.crop?.varieties ?? []),
                const SizedBox(
                  height: 15.0,
                ),
                StepProgressView(
                  AppStrings.stepsText,
                  (SowingEnum.values.indexOf(farmModel.crop?.sowing ?? SowingEnum.sowing)) + 1,
                  _stepProgressViewHeight,
                  MediaQuery.of(context).size.width,
                  _stepCircleRadius,
                  _activeColor,
                  _inactiveColor,
                  _stepStyle,
                  decoration: const BoxDecoration(color: AppColors.lightGrey),
                  padding: EdgeInsets.zero,
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

class CropVarietyItem extends StatelessWidget {
  const CropVarietyItem({super.key, required this.varieties});

  final List<String> varieties;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: ListView.builder(
        itemCount: varieties.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return CultivationItem(
            cultivationName: varieties[index],
          );
        },
      ),
    );
    // return Container(
    //   margin: const EdgeInsets.only(right: 5),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(10),
    //     color: AppColors.purple,
    //   ),
    //   padding: const EdgeInsets.only(
    //     left: 10,
    //     right: 10,
    //   ),
    //   child: Text(
    //     cropName,
    //     style: TextStyle(
    //       fontSize: 11,
    //       fontWeight: FontWeight.w500,
    //       color: AppColors.white,
    //       fontFamily: Assets.rubik,
    //     ),
    //   ),
    // );
  }
}
