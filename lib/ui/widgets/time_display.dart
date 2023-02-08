import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timezone_contacts/data/app_state_manager.dart';

class TimeDisplay extends StatelessWidget {
  final DateTime time;
  final double fontSize;

  const TimeDisplay({
    super.key,
    required this.time,
    this.fontSize = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateManager>(
      builder: (context, appStateManager, child) {
        final in24HoursFormat = appStateManager.timeIn24HoursFormat;

        if (in24HoursFormat) {
          return Center(
            child: buildClock(in24HoursFormat),
          );
        } else {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildClock(in24HoursFormat),
                const SizedBox(width: 3.0),
                buildAmPmIndicator(),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildClock(bool time24Hours) {
    String timeString;

    if (time24Hours) {
      timeString = DateFormat('HH:mm').format(time);
    } else {
      timeString = DateFormat('hh:mm').format(time);
    }

    return Text(
      timeString,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  }

  Widget buildAmPmIndicator() {
    final String labelAmPm = DateFormat('a', Platform.localeName).format(time);

    final hour = int.parse(DateFormat('H').format(time));

    final isPm = hour >= 12;

    final indicatorFontSize = fontSize / 2.5;

    if (isPm) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: indicatorFontSize),
          Text(
            labelAmPm,
            style: TextStyle(
              fontSize: indicatorFontSize,
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            labelAmPm,
            style: TextStyle(
              fontSize: indicatorFontSize,
            ),
          ),
          SizedBox(height: indicatorFontSize),
        ],
      );
    }
  }
}
