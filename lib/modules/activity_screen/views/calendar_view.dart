import 'dart:developer';

import 'package:finca/modules/activity_screen/models/activity_model.dart';
import 'package:finca/views/table_calender.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_colors.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({
    super.key,
    required this.isNoteBookSelected,
    required this.focusedDay,
    required this.activities,
    required this.calendarFilteredActivities,
    required this.onFocusedDayChanged,
    required this.onCalendarTap,
    required this.onNotebookTap,
  });

  final bool isNoteBookSelected;
  final DateTime focusedDay;
  final List<ActivityModel> activities;
  final List<ActivityModel> calendarFilteredActivities;
  final Function(DateTime dateTime) onFocusedDayChanged;
  final VoidCallback onCalendarTap;
  final VoidCallback onNotebookTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalender(
          focusedDay: focusedDay,
          events: activities,
          isNoteBookSelected: isNoteBookSelected,
          onCalendarTap: () {
            onCalendarTap();
          },
          onNotebookTap: () {
            onNotebookTap();
          },
          onFocusedDayChanged: (focusedDay) {
            onFocusedDayChanged(focusedDay);
          },
        ),
        calendarFilteredActivities.isEmpty
            ? const Center(
                child: Text('No activities found'),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: calendarFilteredActivities.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    color: calendarFilteredActivities[index].isAllDay ? AppColors.lightGreen : Colors.white,
                    child: ListTile(
                      title: Text(calendarFilteredActivities[index].isAllDay
                          ? 'Every ${DateFormat('EEEE').format(calendarFilteredActivities[index].startDate)}'
                          : '${DateFormat('hh:mm a').format(calendarFilteredActivities[index].startDate)} ${calendarFilteredActivities[index].activityType}'),
                      subtitle: Text('${calendarFilteredActivities[index].details}'),
                    ),
                  );
                },
              )
      ],
    );
  }
}
