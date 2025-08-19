import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/theme.dart';

import '../generated/l10n.dart';

class CustomFormWidget extends StatelessWidget {
  const CustomFormWidget({
    super.key,
    this.hint = '',
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.label,
    this.suffixIcon,
    this.prefix,
    this.maxLength,
    this.onChanged,
    this.focusNode,
    this.readOnly = false,
    this.fillColor,
  });
  final String? hint;
  final String? label;
  final TextEditingController controller;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines, maxLength;
  final Widget? suffixIcon, prefix;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final bool readOnly;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      maxLength: maxLength,
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      textAlignVertical: TextAlignVertical.center,
      obscureText: obscureText!,
      onChanged: onChanged,
      decoration: InputDecoration(
        fillColor: fillColor,
        counterText: '',
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
        label: label != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label!,
                    style: TextStyle(
                      // color: AppStaticColor.labelColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  if (validator != null)
                    Text(
                      "*",
                      style: TextStyle(
                        color: AppStaticColor.redColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                ],
              )
            : null,
        hintText: hint,
        hintStyle: TextStyle(
            fontSize: 16.sp,
            color: colors(context).hintTextColor,
            fontWeight: FontWeight.w300),
        suffixIcon: suffixIcon,
        prefixIcon: prefix,
      ),
      style: TextStyle(fontSize: 16.sp),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}

validatorWithMessage(
    {required String message,
    String? value,
    bool isEmail = false,
    BuildContext? context}) {
  if (value == null || value.isEmpty) {
    return message;
  }
  if (isEmail &&
      !RegExp(AppConstants.kTextValidatorEmailRegex).hasMatch(value)) {
    return S.of(context!).validation;
  }
  return null;
}
