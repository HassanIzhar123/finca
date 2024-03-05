import 'package:finca/assets/assets.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.showName = true,
    this.name,
    required this.hintText,
    this.borderColor = AppColors.creamColor,
    this.multiLine = false,
    this.icon,
    this.iconOnLeft = true,
    this.isCalendarPicker = false,
    this.controller,
    this.onChange,
    this.onSubmitted,
  });

  final bool iconOnLeft;
  final bool isCalendarPicker;
  final TextEditingController? controller;
  final bool showName;
  final Color borderColor;
  final String? name;
  final String hintText;
  final bool multiLine;
  final String? icon;
  final Function(String)? onChange;
  final Function(String)? onSubmitted;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return textFieldContainer(widget.name, widget.hintText, multiLine: widget.multiLine);
  }

  Widget textFieldContainer(
    String? name,
    String hintText, {
    bool multiLine = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.showName
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGrey,
                      fontFamily: Assets.rubik,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              )
            : const SizedBox(),
        Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
            border: Border.fromBorderSide(
              BorderSide(
                color: AppColors.creamColor,
                width: 2.0,
              ),
            ),
          ),
          padding: EdgeInsets.only(
            right: !widget.iconOnLeft ? 10.0 : 0.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.icon != null && widget.iconOnLeft
                  ? Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: SvgPicture.asset(
                        widget.icon!,
                      ),
                    )
                  : const SizedBox(),
              Expanded(
                child: !widget.isCalendarPicker
                    ? TextField(
                        controller: widget.controller,
                        maxLines: multiLine ? 5 : null,
                        textInputAction: TextInputAction.send,
                        keyboardType: multiLine ? TextInputType.multiline : null,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: hintText,
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: Assets.rubik,
                            fontWeight: FontWeight.w400,
                            color: AppColors.creamColor,
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          if (widget.onChange != null) {
                            widget.onChange!(value);
                          }
                        },
                        onSubmitted: (value) {
                          widget.onSubmitted?.call(value);
                        },
                      )
                    : GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: 14,
                            bottom: 13,
                            left: 10,
                            right: 10,
                          ),
                          child: Text(
                            DateFormat('dd-MM-yyyy').format(selectedDate),
                          ),
                        ),
                      ),
              ),
              widget.icon != null && !widget.iconOnLeft
                  ? Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: SvgPicture.asset(
                        widget.icon!,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
