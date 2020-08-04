import 'package:hkinfo/BusNotifierApp/stopClass.dart';

class Reminder {
  DateTime time;
  Stop stop;
  int notificationId;
  Reminder(this.time, this.stop, this.notificationId);

  static Reminder fromMap(Map<String, dynamic> reminderMap) {
    return Reminder(DateTime.parse(reminderMap['Time']),
        Stop.fromMap(reminderMap['Stop']), reminderMap['NotificationID']);
  }

  Map<String, dynamic> toMap() {
    return {
      "Time": this.time.toIso8601String(),
      "Stop": this.stop.toMap(),
      "NotificationID": this.notificationId,
    };
  }
}
