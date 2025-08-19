import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/theme.dart';

class PinPutWidget extends StatefulWidget {
  final void Function(String)? onCompleted;
  final String? Function(String?)? validator;
  final TextEditingController pinCodeController;
  const PinPutWidget({
    super.key,
    required this.onCompleted,
    required this.validator,
    required this.pinCodeController,
  });

  @override
  State<PinPutWidget> createState() => _PinputExampleState();
}

class _PinputExampleState extends State<PinPutWidget> {
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  void _handleCompleted(String pin) {
    if (widget.onCompleted != null) {
      widget.onCompleted!(pin);
    }
  }

  String? _validatePin(String? value) {
    return widget.validator!(value);
  }

  @override
  void dispose() {
    widget.pinCodeController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 80.w,
      height: 56.h,
      textStyle: const TextStyle(
        fontSize: 22,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
            color: colors(context)
                .hintTextColor!
                .withOpacity(AppConstants.hintColorBorderOpacity)),
        borderRadius: BorderRadius.circular(13),
      ),
    );

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Pinput(
              preFilledWidget: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    width: 16,
                    height: 1,
                  ),
                ],
              ),
              controller: widget.pinCodeController,
              focusNode: focusNode,
              defaultPinTheme: defaultPinTheme,
              separatorBuilder: (index) => const SizedBox(width: 16),
              validator: _validatePin,
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: _handleCompleted,
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    width: 16,
                    height: 1,
                    color: colors(context).primaryColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colors(context).primaryColor!,
                  ),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
