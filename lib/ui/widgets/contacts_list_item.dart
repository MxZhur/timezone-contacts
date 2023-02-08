import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timezone_contacts/data/app_state_manager.dart';
import 'package:timezone_contacts/data/models/contact.dart';
import 'package:timezone_contacts/data/repositories/repository.dart';
import 'package:timezone_contacts/misc/functions.dart';
import 'package:timezone_contacts/ui/screens/contact_form_screen.dart';
import './timezone_diff_label.dart';
import './time_display.dart';

class ContactsListItem extends StatelessWidget {
  final Contact contact;
  final tz.Location? referenceTimeZone;

  const ContactsListItem({
    super.key,
    required this.contact,
    this.referenceTimeZone,
  });

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<Repository>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Slidable(
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                label: 'Delete',
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                onPressed: (context) {
                  repository.deleteContact(contact);
                },
              ),
            ],
          ),
          child: Card(
            elevation: 3.0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactFormScreen(contact: contact),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildContactInfo(context),
                    const SizedBox(
                      width: 10,
                    ),
                    buildContactTime(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildContactInfo(BuildContext context) {
    var contactLocation = tz.getLocation(contact.timezone);

    return Expanded(
      child: Row(
        children: [
          (contact.image != null && contact.image!.isNotEmpty)
              ? CircleAvatar(
                  backgroundImage: Image.file(
                    File(contact.image!),
                    fit: BoxFit.cover,
                  ).image,
                )
              : CircleAvatar(
                  backgroundColor: stringToHslColor(contact.name),
                  foregroundColor: Colors.white,
                  child: Text(
                    contact.name[0],
                  ),
                ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3.0),
                Text(
                  contactLocation.name,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContactTime(BuildContext context) {
    var contactLocation = tz.getLocation(contact.timezone);

    return Consumer<AppStateManager>(
      builder: (context, appStateManager, child) {
        DateTime displayTime;

        if (appStateManager.referenceTime == null) {
          displayTime = tz.TZDateTime.now(contactLocation);
        } else {
          displayTime = tz.TZDateTime.from(
              appStateManager.referenceTime!, contactLocation);
        }

        return Column(
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

                var newDateTimeInContactTZ = tz.TZDateTime(
                  contactLocation,
                  displayTime.year,
                  displayTime.month,
                  displayTime.day,
                  newTime.hour,
                  newTime.minute,
                ).toLocal();

                final DateTime newDateTime = DateTime(
                  displayTime.year,
                  displayTime.month,
                  displayTime.day,
                  newDateTimeInContactTZ.hour,
                  newDateTimeInContactTZ.minute,
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
                  initialDate: DateTime(
                    displayTime.year,
                    displayTime.month,
                    displayTime.day,
                  ),
                  firstDate: DateTime.utc(2000),
                  lastDate: DateTime.utc(2099),
                );

                if (newDate == null) {
                  return;
                }

                var newDateTimeInContactTZ = tz.TZDateTime(
                  contactLocation,
                  newDate.year,
                  newDate.month,
                  newDate.day,
                  displayTime.hour,
                  displayTime.minute,
                ).toLocal();

                final DateTime newDateTime = DateTime(
                  newDateTimeInContactTZ.year,
                  newDateTimeInContactTZ.month,
                  newDateTimeInContactTZ.day,
                  newDateTimeInContactTZ.hour,
                  newDateTimeInContactTZ.minute,
                );

                appStateManager.setReferenceTime(newDateTime);
              },
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  DateFormat.MMMd(Platform.localeName).format(displayTime),
                ),
              ),
            ),
            TimeZoneDiffLabel(
              timezoneA: referenceTimeZone!,
              timezoneB: contactLocation,
            ),
          ],
        );
      },
    );
  }
}
