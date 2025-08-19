import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/gen/assets.gen.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class TimerProgressBar extends StatefulWidget {
  final Key? timerKey;
  final Function()? onReset;
  final Function()? onEnd;
  final int duration;
  const TimerProgressBar({
    super.key,
    this.timerKey,
    this.onReset,
    this.onEnd,
    this.duration = 60,
  });

  @override
  State<TimerProgressBar> createState() => TimerProgressBarState();
}

class TimerProgressBarState extends State<TimerProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    )
      ..addStatusListener((status) {
        if (_controller.status == AnimationStatus.dismissed) {
          widget.onEnd?.call();
        }
      })
      ..addListener(() {
        setState(() {});
      });

    _startTimer();

    super.initState();
  }

  void _startTimer() {
    _controller.reset();
    _controller.reverse(from: 1.0);
  }

  void _restartTimer() {
    _controller.reset();
    widget.onReset?.call();
    _startTimer();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h)
          .copyWith(right: 5.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(40.r),
        ),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 5,
            child: LinearProgressIndicator(
              minHeight: 12.h,
              borderRadius: BorderRadius.circular(6.r),
              backgroundColor: Colors.transparent,
              color: AppStaticColor.primaryColor,
              value: _controller.value,
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32.r),
                color: context.color.surface,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (widget.duration * _controller.value).toStringAsFixed(0),
                    style: AppTextStyle(context)
                        .bodyTextSmall
                        .copyWith(fontSize: 12.sp),
                  ),
                  4.pw,
                  SvgPicture.asset(
                    Assets.svg.timer,
                    width: 16,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void resetTimer() {
    _restartTimer();
  }
}
