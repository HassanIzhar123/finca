import 'dart:developer';

import 'package:finca/modules/activity_screen/models/activity_model.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/calendar_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'ActivityTile.dart';

class NoteBookView extends StatelessWidget {
  const NoteBookView({
    super.key,
    required this.isNoteBookSelected,
    required this.focusedDay,
    required this.activities,
    required this.onCalendarTap,
    required this.onNotebookTap,
    required this.onFocusedDayChanged,
  });

  final bool isNoteBookSelected;
  final DateTime focusedDay;
  final List<ActivityModel> activities;
  final ValueChanged<DateTime> onFocusedDayChanged;
  final VoidCallback onCalendarTap;
  final VoidCallback onNotebookTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalendarHeader(
          isNoteBookSelected: isNoteBookSelected,
          focusedDay: focusedDay,
          onLeftArrowTap: () {
            DateTime tempFocusedDay = focusedDay.copyWith(month: focusedDay.month - 1);
            onFocusedDayChanged(tempFocusedDay);
          },
          onRightArrowTap: () {
            DateTime tempFocusedDay = focusedDay.copyWith(month: focusedDay.month + 1);
            onFocusedDayChanged(tempFocusedDay);
          },
          onCalendarTap: () {
            onCalendarTap();
          },
          onNotebookTap: () {
            onNotebookTap();
          },
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 170,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  Text(
                    DateFormat('EEEE dd').format(focusedDay),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CupertinoButton(
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      DateTime tempFocusedDay = focusedDay.copyWith(day: focusedDay.day - 1);
                      onFocusedDayChanged(tempFocusedDay);
                    },
                    child: const Icon(
                      Icons.chevron_left,
                      color: Color(0xFF333333),
                    ),
                  ),
                  CupertinoButton(
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      DateTime tempFocusedDay = focusedDay.copyWith(day: focusedDay.day + 1);
                      onFocusedDayChanged(tempFocusedDay);
                    },
                    child: const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 20,
                left: 40,
                right: 40,
              ),
              color: AppColors.lightGreen,
              child: const Text(
                'All Day',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: 24,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var currentHourDate = DateTime(focusedDay.year, focusedDay.month, focusedDay.day, index);
                var activity = activities.firstWhereOrNull(
                  (element) =>
                      element.startDate.year == currentHourDate.year &&
                      element.startDate.month == currentHourDate.month &&
                      element.startDate.day == currentHourDate.day &&
                      element.startDate.hour == currentHourDate.hour,
                );
                return ActivityTile(
                  hasActivity: activity == null,
                  time: DateFormat('hh:mm').format(currentHourDate),
                  activityName: activity?.activityType ?? 'Sin actividad',
                  activityDetail: activity?.details ?? 'Sin detalles',
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Color(0xff7f7f75),
                  height: 0.1,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
