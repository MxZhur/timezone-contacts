import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/standalone.dart' as tz;

class In24HoursFormatSetting {
  static const off = 0;
  static const on = 1;
  static const system = 2;
}

class DarkMode {
  static const off = 0;
  static const on = 1;
  static const system = 2;
}

class AppCache {
  static const kReferenceTimeZone = 'refTimeZone';
  static const kDarkMode = 'darkMode';
  static const kTimeIn24HoursFormat = 'time24Hours';

  Future<tz.Location?> referenceTimeZone() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedValue = prefs.getString(kReferenceTimeZone);

    if (cachedValue == null) {
      return null;
    } else {
      return tz.getLocation(cachedValue);
    }
  }

  Future<void> setReferenceTimeZone(tz.Location? timeZone) async {
    final prefs = await SharedPreferences.getInstance();

    if (timeZone == null) {
      await prefs.remove(kReferenceTimeZone);
    } else {
      await prefs.setString(kReferenceTimeZone, timeZone.name);
    }
  }

  Future<int> darkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(kDarkMode) ?? DarkMode.system;
  }

  Future<void> setDarkMode(int mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kDarkMode, mode);
  }

  Future<int> timeIn24HoursFormat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(kTimeIn24HoursFormat) ?? In24HoursFormatSetting.system;
  }

  Future<void> setTimeIn24HoursFormat(int mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kTimeIn24HoursFormat, mode);
  }
}
