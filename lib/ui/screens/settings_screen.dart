import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone_contacts/data/app_cache.dart';
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
                  DropdownButton<int>(
                    value: appStateManager.darkMode,
                    onChanged: (int? value) {
                      if (value == null) {
                        return;
                      }
                      appStateManager.setDarkMode(value);
                    },
                    items: const [
                      DropdownMenuItem<int>(
                        value: DarkMode.system,
                        child: Text('System'),
                      ),
                      DropdownMenuItem<int>(
                        value: DarkMode.off,
                        child: Text('Off'),
                      ),
                      DropdownMenuItem<int>(
                        value: DarkMode.on,
                        child: Text('On'),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('12/24-hour time format'),

                  DropdownButton<int>(
                    value: appStateManager.timeIn24HoursFormat,
                    onChanged: (int? value) {
                      if (value == null) {
                        return;
                      }
                      appStateManager.setTimeIn24HoursFormat(value);
                    },
                    items: const [
                      DropdownMenuItem<int>(
                        value: In24HoursFormatSetting.system,
                        child: Text('System'),
                      ),
                      DropdownMenuItem<int>(
                        value: In24HoursFormatSetting.off,
                        child: Text('12 hours'),
                      ),
                      DropdownMenuItem<int>(
                        value: In24HoursFormatSetting.on,
                        child: Text('24 hours'),
                      ),
                    ],
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
