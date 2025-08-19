// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ExamTimerWidget extends StatefulWidget {
  final int duration;
  final Function(bool) startTimer;
  final Function(bool) pauseTimer;
  final Function(bool) onTimerEnded;
  final Function(String) onTimerChanged;

  const ExamTimerWidget({
    super.key,
    required this.duration,
    required this.startTimer,
    required this.pauseTimer,
    required this.onTimerEnded,
    required this.onTimerChanged,
  });

  @override
  ExamTimerWidgetState createState() => ExamTimerWidgetState();
}

class ExamTimerWidgetState extends State<ExamTimerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Duration> _timerAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: widget.duration),
    );

    _timerAnimation = Tween<Duration>(
      begin: Duration(minutes: widget.duration),
      end: Duration.zero,
    ).animate(_controller)
      ..addListener(() {
        if (_controller.isCompleted) {
          widget.onTimerEnded(true);
        }
      });
    startTimer();
  }

  void startTimer() {
    widget.startTimer(true);
    _controller.forward();
  }

  void pauseTimer() {
    widget.pauseTimer(true);
    _controller.stop();
  }

  void getCurrentTime() {
    String time = '';
    int min = _timerAnimation.value.inMinutes;
    int sec = _timerAnimation.value.inSeconds % 60;
    if (min == 0) {
      time = '$sec seconds';
    } else if (sec == 0) {
      time = '$min minutes';
    } else {
      time = '$min minutes $sec seconds';
    }

    widget.onTimerChanged(time);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Theme.of(context).primaryColor.withOpacity(0.1),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final timeRemaining = _timerAnimation.value;
          final minutes = timeRemaining.inMinutes;
          final seconds = timeRemaining.inSeconds % 60;

          return Text(
            '$minutes:${seconds.toString().padLeft(2, '0')}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).primaryColor,
                ),
          );
        },
      ),
    );
  }
}
