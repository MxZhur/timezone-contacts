import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:timezone_contacts/data/app_state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './time_display.dart';


class MyLocalTimePanel extends StatelessWidget {
  final tz.Location? referenceTimeZone;

  const MyLocalTimePanel({
    super.key,
    this.referenceTimeZone,
  });

  void setDate(DateTime time) {}

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<AppStateManager>(
          builder: (context, appStateManager, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.labelMyLocalTime,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3.0),
                        Text(referenceTimeZone!.name),
                      ],
                    ),
                  ],
                ),
                StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 5)),
                  builder: (context, snapshot) {
                    DateTime displayTime;

                    if (appStateManager.referenceTime == null) {
                      displayTime = tz.TZDateTime.now(referenceTimeZone!);
                    } else {
                      displayTime = tz.TZDateTime.from(
                        appStateManager.referenceTime!,
                        referenceTimeZone!,
                      );
                    }

                    return Row(
                      children: [
                        if (appStateManager.referenceTime != null)
                          IconButton(
                            onPressed: () {
                              Provider.of<AppStateManager>(context,
                                      listen: false)
                                  .resetReferenceTime();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(context)!.messageRefTimeReset,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.restore),
                          ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                TimeOfDay? newTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(
                                    hour: displayTime.hour,
                                    minute: displayTime.minute,
                                  ),
                                );

                                if (newTime == null) {
                                  return;
                                }

                                final DateTime newDateTime = DateTime(
                                  displayTime.year,
                                  displayTime.month,
                                  displayTime.day,
                                  newTime.hour,
                                  newTime.minute,
                                );

                                appStateManager.setReferenceTime(newDateTime);
                              },
                              child: TimeDisplay(
                                time: displayTime,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                DateTime? newDate = await showDatePicker(
                                  context: context,
                                  initialDate: appStateManager.referenceTime ??
                                      DateTime.now(),
                                  firstDate: DateTime.utc(2000),
                                  lastDate: DateTime.utc(2099),
                                );

                                if (newDate == null) {
                                  return;
                                }

                                final DateTime newDateTime = DateTime(
                                  newDate.year,
                                  newDate.month,
                                  newDate.day,
                                  displayTime.hour,
                                  displayTime.minute,
                                );

                                appStateManager.setReferenceTime(newDateTime);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  DateFormat.MMMd(Platform.localeName)
                                      .format(displayTime),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
