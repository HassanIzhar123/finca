import 'dart:developer';

import 'package:finca/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TableCalender extends StatefulWidget {
  const TableCalender({Key? key}) : super(key: key);

  @override
  State<TableCalender> createState() => _TableCalenderState();
}

class _TableCalenderState extends State<TableCalender> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  DateTime _focusedDay = DateTime.now();

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      _rangeStart = null;
      _rangeEnd = null;
    });
    // Call your callback function here to notify when a date is selected
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 18),
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          _CalendarHeader(
            focusedDay: _focusedDay,
            onLeftArrowTap: () {
              setState(() {
                _focusedDay = _focusedDay.subtract(const Duration(days: 30));
              });
            },
            onRightArrowTap: () {
              setState(() {
                _focusedDay = _focusedDay.add(const Duration(days: 30));
              });
            },
          ),
          const SizedBox(height: 12),
          TableCalendar<DateTime>(
            daysOfWeekHeight: 42,
            rowHeight: 42,
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            weekendDays: const [],
            selectedDayPredicate: (date) {
              return date.day == _focusedDay.day && date.month == _focusedDay.month && date.year == _focusedDay.year;
            },
            sixWeekMonthsEnforced: true,
            headerVisible: false,
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: (_) => [DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)],
            // Use your function to load events here
            onDaySelected: _onDaySelected,
            pageAnimationCurve: Curves.ease,
            pageAnimationDuration: const Duration(milliseconds: 500),
            availableGestures: AvailableGestures.horizontalSwipe,
            onCalendarCreated: (_) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                setState(() {});
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (_, day, focusedDay) => Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.brown,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    day.day.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              todayBuilder: (_, day, focusedDay) => Center(
                child: Text(
                  '${day.day}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              markerBuilder: (_, day, events) {
                log(events.toString() + " events" + day.toString());
                if (events.isNotEmpty && events.contains(day.toUtc())) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red, // Customize the color of the dot as needed
                          shape: BoxShape.circle,
                        ),
                        height: 6,
                        width: 6,
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
  });

  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: Text(
              headerText,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          const Spacer(),
          CupertinoButton(
            minSize: 0,
            padding: EdgeInsets.zero,
            onPressed: onLeftArrowTap,
            child: const Icon(Icons.chevron_left),
          ),
          CupertinoButton(
            minSize: 0,
            padding: EdgeInsets.zero,
            onPressed: onRightArrowTap,
            child: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

final kFirstDay = DateTime(2023);
final kLastDay = DateTime(2033, 1, 0);

// class TableCalender extends StatefulWidget {
//   const TableCalender({super.key});
//
//   @override
//   State<TableCalender> createState() => _TableCalenderState();
// }
//
// class _TableCalenderState extends State<TableCalender> {
//   final CalendarFormat _calendarFormat = CalendarFormat.month;
//   final _rangeSelectionMode = RangeSelectionMode.toggledOff;
//   DateTime? _rangeStart;
//   DateTime? _rangeEnd;
//
//   DateTime _focusedDay = DateTime.now();
//
//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     setState(() {
//       _focusedDay = focusedDay;
//       _rangeStart = null;
//       _rangeEnd = null;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 18),
//       margin: const EdgeInsets.only(bottom: 30),
//       child: Column(
//         children: [
//           _CalendarHeader(
//             focusedDay: _focusedDay,
//             onLeftArrowTap: () {
//               setState(() {
//                 _focusedDay = _focusedDay.subtract(const Duration(days: 30));
//               });
//             },
//             onRightArrowTap: () {
//               setState(() {
//                 _focusedDay = _focusedDay.add(const Duration(days: 30));
//               });
//             },
//           ),
//           const SizedBox(height: 12),
//           TableCalendar<DateTime>(
//             daysOfWeekHeight: 42,
//             rowHeight: 42,
//             firstDay: kFirstDay,
//             lastDay: kLastDay,
//             focusedDay: _focusedDay,
//             weekendDays: const [],
//             selectedDayPredicate: (date) {
//               return date.day == _focusedDay.day && date.month == _focusedDay.month && date.year == _focusedDay.year;
//             },
//             sixWeekMonthsEnforced: true,
//             headerVisible: false,
//             rangeStartDay: _rangeStart,
//             rangeEndDay: _rangeEnd,
//             calendarFormat: _calendarFormat,
//             rangeSelectionMode: _rangeSelectionMode,
//             eventLoader: (_) => [],
//             onDaySelected: _onDaySelected,
//             pageAnimationCurve: Curves.ease,
//             pageAnimationDuration: const Duration(milliseconds: 500),
//             availableGestures: AvailableGestures.horizontalSwipe,
//             onCalendarCreated: (_) {
//               WidgetsBinding.instance!.addPostFrameCallback((_) {
//                 setState(() {});
//               });
//             },
//             onPageChanged: (focusedDay) {
//               setState(() {
//                 _focusedDay = focusedDay;
//               });
//             },
//             calendarBuilders: CalendarBuilders(
//               selectedBuilder: (_, day, focusedDay) => Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: const BoxDecoration(
//                   color: AppColors.lightGreen,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Text(
//                     day.day.toString(),
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//               todayBuilder: (_, day, focusedDay) => Center(
//                 child: Text(
//                   '${day.day}',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//               markerBuilder: (_, day, events) {
//                 return const SizedBox.shrink();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _CalendarHeader extends StatelessWidget {
//   const _CalendarHeader({
//     required this.focusedDay,
//     required this.onLeftArrowTap,
//     required this.onRightArrowTap,
//   });
//
//   final DateTime focusedDay;
//   final VoidCallback onLeftArrowTap;
//   final VoidCallback onRightArrowTap;
//
//   @override
//   Widget build(BuildContext context) {
//     final headerText = DateFormat.yMMM().format(focusedDay);
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         vertical: 8,
//       ),
//       child: Row(
//         children: [
//           const SizedBox(width: 10),
//           SizedBox(
//             width: 120,
//             child: Text(
//               headerText,
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//           const Spacer(),
//           CupertinoButton(
//             minSize: 0,
//             padding: EdgeInsets.zero,
//             onPressed: onLeftArrowTap,
//             child: const Icon(Icons.chevron_left),
//           ),
//           CupertinoButton(
//             minSize: 0,
//             padding: EdgeInsets.zero,
//             onPressed: onRightArrowTap,
//             child: const Icon(Icons.chevron_right),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// final kFirstDay = DateTime(2023);
// final kLastDay = DateTime(2033, 1, 0);
