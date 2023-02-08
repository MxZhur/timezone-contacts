import 'package:timezone/standalone.dart' as tz;

class Contact {
  int? id;
  final String name;
  final String? image;
  final String timezone;
  double utcOffset;

  Contact({
    this.id,
    required this.name,
    this.image,
    required this.timezone,
    this.utcOffset = 0.0,
  });

  static double timezoneToOffset(String timezone) {
    if (timezone.isEmpty) {
      return 0.0;
    }
    return tz.getLocation(timezone).currentTimeZone.offset /
        Duration.millisecondsPerHour;
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    var contact = Contact(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      timezone: json['timezone'] ?? '',
    );

    contact.utcOffset = timezoneToOffset(contact.timezone);

    return contact;
  }

  Map<String, dynamic> toJson() {
    utcOffset = timezoneToOffset(timezone);

    return {
      'id': id,
      'name': name,
      'image': image,
      'timezone': timezone,
      'utcOffset': utcOffset,
    };
  }
}
