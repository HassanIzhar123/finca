import 'package:finca/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ActivityTile extends StatelessWidget {
  const ActivityTile({
    super.key,
    required this.hasActivity,
    required this.time,
    required this.activityName,
    required this.activityDetail,
  });

  final bool hasActivity;
  final String time;
  final String activityName;
  final String activityDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 20,
        right: 20,
      ),
      child: Row(
        children: [
          Text(
            time,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          hasActivity
              ? const SizedBox(
                  height: 30,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activityName,
                      style: const TextStyle(
                        color: AppColors.secondarySilver,
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      activityDetail,
                      style: const TextStyle(
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
