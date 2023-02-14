import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone_contacts/data/app_cache.dart';
import 'package:timezone_contacts/data/app_state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.labelSettings,
        ),
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
                  Text(
                    AppLocalizations.of(context)!.settingsLabelTheme,
                  ),

                  DropdownButton<int>(
                    value: appStateManager.darkMode,
                    onChanged: (int? value) {
                      if (value == null) {
                        return;
                      }
                      appStateManager.setDarkMode(value);
                    },
                    items: [
                      DropdownMenuItem<int>(
                        value: DarkMode.system,
                        child: Text(
                          AppLocalizations.of(context)!.optionSystemSettings,
                        ),
                      ),
                      DropdownMenuItem<int>(
                        value: DarkMode.off,
                        child: Text(
                          AppLocalizations.of(context)!.optionLightTheme,
                        ),
                      ),
                      DropdownMenuItem<int>(
                        value: DarkMode.on,
                        child: Text(
                          AppLocalizations.of(context)!.optionDarkTheme,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.settingsLabelTimeFormat,
                  ),

                  DropdownButton<int>(
                    value: appStateManager.timeIn24HoursFormat,
                    onChanged: (int? value) {
                      if (value == null) {
                        return;
                      }
                      appStateManager.setTimeIn24HoursFormat(value);
                    },
                    items: [
                      DropdownMenuItem<int>(
                        value: In24HoursFormatSetting.system,
                        child: Text(
                          AppLocalizations.of(context)!.optionSystemSettings,
                        ),
                      ),
                      DropdownMenuItem<int>(
                        value: In24HoursFormatSetting.off,
                        child: Text(
                          AppLocalizations.of(context)!.option12Hours,
                        ),
                      ),
                      DropdownMenuItem<int>(
                        value: In24HoursFormatSetting.on,
                        child: Text(
                          AppLocalizations.of(context)!.option24Hours,
                        ),
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
