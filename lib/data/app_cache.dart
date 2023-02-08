import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/standalone.dart' as tz;

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

  Future<bool> darkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kDarkMode) ?? false;
  }

  Future<void> setDarkMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kDarkMode, enabled);
  }

  Future<bool> timeIn24HoursFormat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kTimeIn24HoursFormat) ?? false;
  }

  Future<void> setTimeIn24HoursFormat(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kTimeIn24HoursFormat, enabled);
  }
}
