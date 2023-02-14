import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

import './app_cache.dart';

class AppStateManager extends ChangeNotifier {
  DateTime? _referenceTime;
  tz.Location? _referenceTimeZone;
  int _darkMode = DarkMode.system;
  int _timeIn24HoursFormat = In24HoursFormatSetting.system;

  final _appCache = AppCache();

  // Property getters.
  DateTime? get referenceTime => _referenceTime;
  tz.Location? get referenceTimeZone => _referenceTimeZone;
  int get darkMode => _darkMode;
  int get timeIn24HoursFormat => _timeIn24HoursFormat;

  // Initializes the app
  Future<void> initializeApp() async {
    tzdata.initializeTimeZones();

    // Check if the user is logged in
    _referenceTimeZone = await _appCache.referenceTimeZone();
    _darkMode = await _appCache.darkMode();
    _timeIn24HoursFormat = await _appCache.timeIn24HoursFormat();
  }

  void setReferenceTime(DateTime datetime) async {
    _referenceTime = datetime;
    notifyListeners();
  }

  void resetReferenceTime() async {
    _referenceTime = null;
    notifyListeners();
  }

  void setReferenceTimeZone(tz.Location timeZone) async {
    _referenceTimeZone = timeZone;
    await _appCache.setReferenceTimeZone(timeZone);
    notifyListeners();
  }

  void resetReferenceTimeZone() async {
    _referenceTimeZone = null;
    await _appCache.setReferenceTimeZone(null);
    notifyListeners();
  }

  void setDarkMode(int mode) async {
    _darkMode = mode;
    await _appCache.setDarkMode(mode);
    notifyListeners();
  }

  void setTimeIn24HoursFormat(int mode) async {
    _timeIn24HoursFormat = mode;
    await _appCache.setTimeIn24HoursFormat(mode);
    notifyListeners();
  }
}
