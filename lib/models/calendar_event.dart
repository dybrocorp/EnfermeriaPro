
class CalendarEvent {
  final String title;
  final DateTime dateTime;
  final int? alertFrequency; // In minutes: null (None), 15, or 30

  CalendarEvent({
    required this.title,
    required this.dateTime,
    this.alertFrequency,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'alertFrequency': alertFrequency,
    };
  }

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      title: json['title'],
      dateTime: DateTime.parse(json['dateTime']),
      alertFrequency: json['alertFrequency'],
    );
  }

  @override
  String toString() => title;
}
