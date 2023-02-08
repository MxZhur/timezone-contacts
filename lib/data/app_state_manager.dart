import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

import './app_cache.dart';

class AppStateManager extends ChangeNotifier {
  DateTime? _referenceTime;
  tz.Location? _referenceTimeZone;
  bool _darkMode = false;
  bool _timeIn24HoursFormat = false;

  final _appCache = AppCache();

  // Property getters.
  DateTime? get referenceTime => _referenceTime;
  tz.Location? get referenceTimeZone => _referenceTimeZone;
  bool get darkMode => _darkMode;
  bool get timeIn24HoursFormat => _timeIn24HoursFormat;

  // Initializes the app
  Future<void> initializeApp() async {
    initializeDateFormatting(Platform.localeName);
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

  void setDarkMode(bool enabled) async {
    _darkMode = enabled;
    await _appCache.setDarkMode(enabled);
    notifyListeners();
  }

  void setTimeIn24HoursFormat(bool enabled) async {
    _timeIn24HoursFormat = enabled;
    await _appCache.setTimeIn24HoursFormat(enabled);
    notifyListeners();
  }
}
