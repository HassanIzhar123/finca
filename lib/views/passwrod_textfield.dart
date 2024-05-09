import 'package:finca/assets/assets.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    this.isPasswordVisible = false,
    required this.controller,
    required this.hintText,
    required this.onChange,
    required this.onSubmitted,
    required this.onPasswordButtonClicked,
  });

  final bool isPasswordVisible;
  final TextEditingController? controller;
  final String hintText;
  final Function(String)? onChange;
  final Function(String)? onSubmitted;
  final Function(bool) onPasswordButtonClicked;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isPasswordVisible = false;

  @override
  void initState() {
    isPasswordVisible = widget.isPasswordVisible;
    super.initState();
  }

  @override
  didUpdateWidget(PasswordTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPasswordVisible != widget.isPasswordVisible) {
      isPasswordVisible = widget.isPasswordVisible;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.text,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: widget.hintText,
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
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isPasswordVisible = !widget.isPasswordVisible;
                widget.onPasswordButtonClicked(isPasswordVisible);
              });
            },
            icon: isPasswordVisible
                ? SvgPicture.asset(
                    Assets.hideEye,
                    color: AppColors.creamColor,
                    //do
                    height: 30,
                    width: 30,
                  )
                : const Icon(
                    Icons.remove_red_eye,
                    color: AppColors.creamColor,
                  ),
          ),
        ],
      ),
    );
  }
}
