import 'package:flutter/material.dart';
import 'package:timezone/standalone.dart';

class TimeZoneDiffLabel extends StatelessWidget {
  final Location timezoneA;
  final Location timezoneB;

  const TimeZoneDiffLabel({
    super.key,
    required this.timezoneA,
    required this.timezoneB,
  });

  @override
  Widget build(BuildContext context) {
    final timezoneAOffset =
        timezoneA.currentTimeZone.offset / Duration.millisecondsPerHour;
    final timezoneBOffset =
        timezoneB.currentTimeZone.offset / Duration.millisecondsPerHour;

    final offsetDiff = timezoneBOffset - timezoneAOffset;

    final offsetDiffHours = offsetDiff.abs().floor();
    final offsetDiffMinutes =
        ((offsetDiff.abs() - offsetDiffHours) * 60).floor();

    String sign;
    Color badgeColor;

    if (offsetDiff > 0) {
      sign = '+';
      badgeColor = Colors.red.shade700;
    } else if (offsetDiff < 0) {
      sign = '-';
      badgeColor = Colors.green;
    } else {
      sign = '';
      badgeColor = Colors.grey;
    }

    final text = '$sign${offsetDiffHours.toString()}'
        ':'
        '${offsetDiffMinutes.toString().padLeft(2, '0')}';

    return Chip(
      avatar: const CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(
          Icons.timer_outlined,
          color: Colors.white,
          size: 14.0,
        ),
      ),
      label: Text(text),
      labelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12.0,
      ),
      labelPadding: const EdgeInsets.only(
        top: -3.0,
        bottom: -3.0,
        left: 1.0,
        right: 3.0,
      ),
      backgroundColor: badgeColor,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
