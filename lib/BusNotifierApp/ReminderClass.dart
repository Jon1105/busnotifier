import 'package:hkinfo/BusNotifierApp/stopClass.dart';

class Reminder {
  DateTime time;
  List<Stop> stops;
  // Stop stop;
  int notificationId;
  Reminder(this.time, this.stops, this.notificationId) {
    assert(
        this.time != null || this.stops != null || this.notificationId != null,
        'Arguments cannot be null');
  }

  static Reminder fromMap(Map<String, dynamic> reminderMap) {
    return Reminder(
        DateTime.parse(reminderMap['Time']),
        reminderMap['Stops']
            .map<Stop>((mapStop) => Stop.fromMap(mapStop))
            .toList(),
        reminderMap['NotificationID']);
  }

  Map<String, dynamic> toMap() {
    return {
      "Time": this.time.toIso8601String(),
      "Stops": this.stops.map((Stop stop) => stop.toMap()).toList(),
      // "Stop": this.stop.toMap(),
      "NotificationID": this.notificationId,
    };
  }
}
