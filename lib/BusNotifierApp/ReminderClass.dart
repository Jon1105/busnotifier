import 'package:hkinfo/BusNotifierApp/stopClass.dart';

class Reminder {
  DateTime time;
  Stop stop;
  int notificationId;
  Reminder(this.time, this.stop, this.notificationId);

  static Reminder fromMap(Map<String, dynamic> reminderMap) {
    return Reminder(
        DateTime.parse(reminderMap['Time']),
        Stop(
          reminderMap['Stop']['id'],
          reminderMap['Stop']['name'],
          reminderMap['Stop']['route'],
          (reminderMap['Stop']['inbound']) ? 'I' : 'O',
          reminderMap['Stop']['destination'],
        ),
        reminderMap['NotificationID']);
  }
}
