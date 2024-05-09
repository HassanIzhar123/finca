import 'package:finca/assets/assets.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
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
                colorFilter: ColorFilter.mode(
                  !isNoteBookSelected ? AppColors.greenColor : const Color(0xFF797979),
                  BlendMode.srcIn,
                ),
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
                colorFilter: ColorFilter.mode(
                  isNoteBookSelected ? AppColors.greenColor : const Color(0xFF797979),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
