import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:soom/constants/app_string.dart';
import 'package:soom/style/color_manger.dart';
import 'package:soom/style/text_style.dart';

class TimerDownDate extends StatefulWidget {
  final String time;
  const TimerDownDate({Key? key, required this.time}) : super(key: key);

  @override
  State<TimerDownDate> createState() => _TimerDownDateState();
}

class _TimerDownDateState extends State<TimerDownDate> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: TimerCountdown(
            timeTextStyle:const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: AppString.fontName ,
              color: ColorManger.productTitle,
              fontSize: 16,
            ),
            endTime: DateTime.parse(widget.time),
            enableDescriptions: false,
            format: CountDownTimerFormat.hoursMinutesSeconds,
          ),
        ));
  }
}
