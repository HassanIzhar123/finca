import 'package:finca/assets/assets.dart';
import 'package:finca/enums/sowing_enum.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/modules/farms_screen/pages/step_three_new_farm_screen.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/views/step_progress_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CropItem extends StatelessWidget {
  const CropItem({
    super.key,
    required this.crop,
    required this.index,
    required this.isSelected,
    required this.isCropDeleting,
    required this.onDeleteCrop,
    required this.onSelectCrop,
  });

  final Function(Crop crop) onDeleteCrop;
  final Function(int index) onSelectCrop;
  final int index;
  final bool isCropDeleting;
  final bool isSelected;
  final Crop crop;
  final _stepsText = const ["Sowing", "In Progress", "Harvest"];

  final _stepCircleRadius = 5.0;

  final _stepProgressViewHeight = 60.0;

  final Color _activeColor = AppColors.greenColor;

  final Color _inactiveColor = Colors.grey;

  final TextStyle _stepStyle = const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelectCrop(index);
      },
      child: Container(
        margin: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10,
          ),
          color: AppColors.lightGrey,
          border: Border.all(
            color: isSelected ? AppColors.greenColor : AppColors.lightGrey,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: crop.farmCoordinatesImage.isNotEmpty
                      ? SizedBox(
                          height: 100.0,
                          width: 100.0,
                          child: BlurHash(
                            hash: 'LEHLk~WB2yk8pyo0adR*.7kCMdnj',
                            image: crop.farmCoordinatesImage,
                            imageFit: BoxFit.cover,
                            decodingHeight: 100,
                            decodingWidth: 100,
                          ),
                        )
                      : SvgPicture.asset(
                          Assets.appIcon,
                          height: 100.0,
                          width: 100.0,
                          fit: BoxFit.fill,
                        ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        padding: const EdgeInsets.only(
                          top: 10,
                          // bottom: 10,
                        ),
                        child: Text(
                          crop.cropName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkGrey,
                            fontFamily: Assets.rubik,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: Text(
                          crop.farmName,
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
                          left: 10,
                          top: 10,
                        ),
                        height: 25,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          children: crop.varieties.map((variety) => VarietyView(varietyName: variety)).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            StepProgressView(
              _stepsText,
              (SowingEnum.values.indexOf(crop.sowing)) + 1,
              _stepProgressViewHeight,
              MediaQuery.of(context).size.width,
              _stepCircleRadius,
              _activeColor,
              _inactiveColor,
              _stepStyle,
              decoration: const BoxDecoration(color: AppColors.lightGrey),
              padding: const EdgeInsets.only(
                // top: 48.0,
                left: 24.0,
                right: 24.0,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(Assets.calendar),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              DateFormat("dd/MMM/yyyy").format(crop.seedTime),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.darkGrey,
                                fontFamily: Assets.rubik,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: const BoxDecoration(color: AppColors.darkGrey),
                          height: 0.5,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: isCropDeleting
                              ? null
                              : () {
                                  onDeleteCrop(crop);
                                },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.delete,
                                colorFilter: const ColorFilter.mode(AppColors.red, BlendMode.srcIn),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                Assets.eliminate,
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
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
