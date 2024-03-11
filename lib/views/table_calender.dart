import 'package:finca/assets/assets.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class TableCalender extends StatefulWidget {
  const TableCalender({
    super.key,
    required this.focusedDay,
    required this.isNoteBookSelected,
    required this.onCalendarTap,
    required this.onNotebookTap,
    required this.onFocusedDayChanged, // New callback
  });

  final DateTime focusedDay;
  final bool isNoteBookSelected;
  final VoidCallback onCalendarTap;
  final VoidCallback onNotebookTap;
  final void Function(DateTime focusedDay) onFocusedDayChanged; // New callback signature

  @override
  State<TableCalender> createState() => _TableCalenderState();
}

class _TableCalenderState extends State<TableCalender> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late ValueNotifier<DateTime> _focusedDayNotifier; // New

  @override
  void initState() {
    super.initState();
    _focusedDayNotifier = ValueNotifier<DateTime>(widget.focusedDay);
  }

  @override
  void dispose() {
    _focusedDayNotifier.dispose(); // Dispose the ValueNotifier
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDayNotifier.value = focusedDay;
      _rangeStart = null;
      _rangeEnd = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _focusedDayNotifier,
      builder: (context, focusedDay, child) {
        widget.onFocusedDayChanged(focusedDay);
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          // padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 18),
          margin: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              _CalendarHeader(
                isNoteBookSelected: widget.isNoteBookSelected,
                focusedDay: focusedDay,
                onLeftArrowTap: () {
                  setState(() {
                    _focusedDayNotifier.value = _focusedDayNotifier.value.subtract(const Duration(days: 30));
                  });
                },
                onRightArrowTap: () {
                  setState(() {
                    _focusedDayNotifier.value = _focusedDayNotifier.value.add(const Duration(days: 30));
                  });
                },
                onCalendarTap: () {
                  widget.onCalendarTap();
                },
                onNotebookTap: () {
                  widget.onNotebookTap();
                },
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TableCalendar<DateTime>(
                  daysOfWeekHeight: 42,
                  rowHeight: 42,
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: focusedDay,
                  weekendDays: const [],
                  selectedDayPredicate: (date) {
                    return date.day == focusedDay.day && date.month == focusedDay.month && date.year == focusedDay.year;
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
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {});
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDayNotifier.value = focusedDay;
                    });
                  },
                  calendarBuilders: CalendarBuilders(
                    selectedBuilder: (_, day, focusedDay) => Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColors.lightGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          day.day.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
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
                    markerBuilder: (context, day, events) {
                      day = DateTime(day.year, day.month, day.day);
                      if (events.isNotEmpty && events.contains(day)) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.green,
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
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.isNoteBookSelected,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onCalendarTap,
    required this.onNotebookTap,
  });

  final bool isNoteBookSelected;
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onCalendarTap;
  final VoidCallback onNotebookTap;

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SizedBox(width: 10),
            Text(
              headerText,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 10),
            CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.zero,
              onPressed: onLeftArrowTap,
              child: const Icon(
                Icons.chevron_left,
                color: Color(0xFF333333),
              ),
            ),
            CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.zero,
              onPressed: onRightArrowTap,
              child: const Icon(
                Icons.chevron_right,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
        Row(
          children: [
            CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.zero,
              onPressed: onCalendarTap,
              child: SvgPicture.asset(
                Assets.calendarIcon,
                color: !isNoteBookSelected ? AppColors.greenColor : const Color(0xFF797979),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.zero,
              onPressed: onNotebookTap,
              child: SvgPicture.asset(
                Assets.notebookIcon,
                color: isNoteBookSelected ? AppColors.greenColor : const Color(0xFF797979),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

final kFirstDay = DateTime(2023);
final kLastDay = DateTime(2033, 1, 0);
