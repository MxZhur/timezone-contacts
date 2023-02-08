import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone_contacts/ui/widgets/time_display.dart';

class TimezoneSelectScreen extends StatelessWidget {
  final Function(String value) onSelect;

  const TimezoneSelectScreen({
    super.key,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    var locations = tz.timeZoneDatabase.locations.values.toList();

    locations.sort(
      (a, b) => a.currentTimeZone.offset.compareTo(b.currentTimeZone.offset),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Time Zone'),
      ),
      body: StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 5)),
        builder: (context, snapshot) {
          return ListView.separated(
            itemBuilder: (context, index) {
              final location = locations[index];

              return buildLocationItem(context, location);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 5.0);
            },
            itemCount: locations.length,
          );
        },
      ),
    );
  }

  Widget buildLocationItem(BuildContext context, tz.Location location) {
    final DateTime displayTime = tz.TZDateTime.now(location);

    var slashPos = location.name.lastIndexOf('/');
    String locationGroupName =
        (slashPos != -1) ? location.name.substring(0, slashPos) : location.name;
    locationGroupName = locationGroupName.replaceAll('_', ' ');

    String locationName = (slashPos != -1)
        ? location.name.substring(slashPos + 1)
        : location.name;
    locationName = locationName.replaceAll('_', ' ');

    final timezoneOffset =
        location.currentTimeZone.offset / Duration.millisecondsPerHour;

    final offsetDiffHours = timezoneOffset.abs().floor();
    final offsetDiffMinutes =
        ((timezoneOffset.abs() - offsetDiffHours) * 60).floor();

    String sign;

    if (timezoneOffset < 0) {
      sign = '-';
    } else {
      sign = '+';
    }

    final offsetText = 'GMT'
        '$sign${offsetDiffHours.toString()}'
        ':'
        '${offsetDiffMinutes.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: () {
        onSelect(location.name);

        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
      child: Card(
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locationName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Opacity(
                    opacity: 0.8,
                    child: Text(
                      locationGroupName,
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Opacity(
                    opacity: 0.8,
                    child: Text(
                      offsetText,
                    ),
                  ),
                ],
              ),
              TimeDisplay(
                time: displayTime,
                fontSize: 25.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
