import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone_contacts/data/app_state_manager.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<AppStateManager>(
        builder: (context, appStateManager, child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Dark Mode'),
                  Switch(
                    value: appStateManager.darkMode,
                    onChanged: (value) {
                      appStateManager.setDarkMode(value);
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('24-hour time format'),
                  Switch(
                    value: appStateManager.timeIn24HoursFormat,
                    onChanged: (value) {
                      appStateManager.setTimeIn24HoursFormat(value);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
