import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'pickStop.dart';
import 'stopClass.dart';
import 'ReminderClass.dart';
import 'stops.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List<Reminder> reminders = [];

  Future<File> get _remindersFile async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/reminders.json');
    bool fileExists = await file.exists();
    if (!fileExists) {
      await file.create();
      await file.writeAsString(json.encode({"reminders": []}));
    }
    return file;
  }

  Future<List<Reminder>> readReminders() async {
    // try {
    final file = await _remindersFile;
    String contents = await file.readAsString();
    Map dartContent = json.decode(contents);
    reminders = [];
    for (Map mapReminder in dartContent['reminders']) {
      reminders.add(Reminder.fromMap(mapReminder));
    }
    return reminders;
  }

  Map mapFromReminder(Reminder reminder) {
    return {
      "Time": reminder.time.toIso8601String(),
      "Stop": {
        'id': reminder.stop.id,
        'name': reminder.stop.name,
        'route': reminder.stop.route,
        'inbound': reminder.stop.inbound,
        'destination': reminder.stop.destination
      },
      "NotificationID": reminder.notificationId,
    };
  }

  List<Map> remindersToMaps(List<Reminder> reminders) {
    return reminders.map((Reminder listReminder) {
      return mapFromReminder(listReminder);
    }).toList();
  }

  Future<void> writeReminder(Reminder reminder) async {
    scheduleNotification(reminder);
    print('Reminder Id ${reminder.notificationId}');
    List<Reminder> reminders = await readReminders();
    reminders.add(reminder);
    List<Map> mapReminders = remindersToMaps(reminders);
    final file = await _remindersFile;
    file.writeAsString(json.encode({"reminders": mapReminders}));
  }

  Future<void> deleteReminder(int index) async {
    final file = await _remindersFile;
    reminders = await readReminders();
    try {
      await flutterLocalNotificationsPlugin
          .cancel(reminders.elementAt(index).notificationId);
    } catch (_) {
      print('No notification scheduled');
    }
    reminders.removeAt(index);
    file.writeAsString(json.encode({"reminders": remindersToMaps(reminders)}));
  }

  void createReminder(BuildContext context) {
    DateTime now = DateTime.now();

    DateTime dayPick = now;
    TimeOfDay timePick = TimeOfDay(hour: 16, minute: 30);
    Stop stop;

    String message = '';

    showDialog(
        context: context,
        // can tap outside to dismiss
        barrierDismissible: true,
        builder: (BuildContext context) => AlertDialog(
              contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 2),
              title: Text('Add a reminder'),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              RaisedButton(
                                child: Text('Pick Date'),
                                onPressed: () async {
                                  var result = await showDatePicker(
                                      context: context,
                                      initialDate: now,
                                      firstDate: now,
                                      lastDate: now.add(Duration(days: 30)));
                                  if (result != null) {
                                    setState(() {
                                      dayPick = result;
                                    });
                                  }
                                },
                              ),
                              Text(
                                DateFormat('EEEE dd').format(dayPick),
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 14),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              RaisedButton(
                                child: Text('Pick Time'),
                                onPressed: () async {
                                  var result = await showTimePicker(
                                      context: context, initialTime: timePick);
                                  if (result != null) {
                                    setState(() {
                                      timePick = result;
                                    });
                                  }
                                },
                              ),
                              Text('${timePick.hour}:${timePick.minute}',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14))
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          var result = await showSearch(
                              context: context, delegate: StopsSearch(stops));
                          if (result != null) {
                            setState(() {
                              stop = result;
                              message = '';
                            });
                          }
                        },
                        child: Text('Pick stop'),
                      ),
                      (stop != null)
                          ? Text(
                              stop.route +
                                  ' ' +
                                  ((stop.inbound) ? 'Inbound' : 'Outbound') +
                                  ': ' +
                                  stop.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 14))
                          : Text('No stop selected',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 14)),
                      (message != '')
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.warning, color: Colors.red),
                                Text(
                                  message,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            onPressed: Navigator.of(context).pop,
                            child: Text('Cancel',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),
                          ),
                          FlatButton(
                            onPressed: () async {
                              DateTime returnDate = DateTime(
                                  dayPick.year,
                                  dayPick.month,
                                  dayPick.day,
                                  timePick.hour,
                                  timePick.minute);
                              if (stop == null) {
                                setState(() {
                                  message = 'Select a stop';
                                });
                              } else if (returnDate.isBefore(now)) {
                                setState(() {
                                  message = 'Invalid Date time';
                                });
                              } else {
                                Navigator.of(context).pop();
                                print('Writing Reminder');

                                print(returnDate);
                                await writeReminder(Reminder(returnDate, stop,
                                    Random().nextInt(pow(10, 6))));
                                updateReminders();
                              }
                            },
                            child: Text('Add',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ],
                  );
                },
              ),
            ));
  }

  void updateReminders() {
    readReminders().then((List<Reminder> readReminders) {
      setState(() {
        reminders = readReminders;
      });
      DateTime now = DateTime.now();
      for (int i = 0; i < reminders.length; i++) {
        if (reminders[i].time.isBefore(now)) {
          deleteReminder(i);
        }
      }
    });
  }

  Future<void> refreshReminders() async {
    List<Reminder> nReminders = await readReminders();
    setState(() {
      reminders = nReminders;
    });
  }
  // ? Keep This
  // void showNotification() async {
  //   var android = AndroidNotificationDetails(
  //     '01234',
  //     'Instant Notifications',
  //     'Notifies the user when Button Pressed',
  //   );
  //   var iOS = IOSNotificationDetails();
  //   var platform = NotificationDetails(android, iOS);
  //   await flutterLocalNotificationsPlugin.show(
  //       0, 'Bus Notifier', 'The bus will arrive in some time', platform);
  // }

  void scheduleNotification(Reminder reminder) async {
    var android = AndroidNotificationDetails(
      '43210',
      'Bus Scheduled Notifications',
      'Notifies the user at each reminder',
      priority: Priority.High,
      importance: Importance.Max,
    );
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.schedule(
        reminder.notificationId,
        'Bus ${reminder.stop.route} at ${reminder.stop.name}',
        'To ${reminder.stop.destination}',
        reminder.time,
        platform,
        androidAllowWhileIdle: false,
        payload: json.encode(mapFromReminder(reminder)));
  }

  @override
  void initState() {
    super.initState();
    // Reminder Functionality
    updateReminders();
    print(reminders);

    // Notifications
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();

    var initSettings = InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<List<TimeOfDay>> getTimes(Stop stop) async {
    String url =
        'https://rt.data.gov.hk/v1/transport/citybus-nwfb/eta/CTB/${stop.id}/${stop.route}';

    http.Response response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to load time data from API');
    }

    List data = json.decode(response.body)['data'];

    List<TimeOfDay> returnList = [];

    for (var map in data) {
      String dir = (stop.inbound) ? 'I' : 'O';
      if (map['dir'] == dir) {
        returnList.add(TimeOfDay.fromDateTime(DateTime.parse(map['eta'])));
      }
    }
    return returnList;
  }

  Future<void> onSelectNotification(String payload) {
    Reminder reminder = Reminder.fromMap(json.decode(payload));
    getTimes(reminder.stop).then((List<TimeOfDay> times) {
      bool isValid = times.isNotEmpty;
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                  'Arrival times for bus ${reminder.stop.route} ${(reminder.stop.inbound) ? 'Inbound' : 'Outbound'}'),
              content: (isValid)
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children:
                          [Text('Going towards ${reminder.stop.destination}')] +
                              times.map((TimeOfDay time) {
                                return Text(time.toString());
                              }).toList(),
                    )
                  : Text('Invalid reminder'),
              actions: <Widget>[
                FlatButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop())
              ],
            );
          });
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: null,
        ),
        title: Row(
          children: <Widget>[
            Text('Bus Notifier'),
            Spacer(),
            Icon(Icons.directions_bus)
          ],
        ),
        elevation: 0,
        // actions: <Widget>[Icon(Icons.directions_bus)],
        // centerTitle: true,
      ),
      //  ***************************************
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: refreshReminders,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight,
              child: ListView(
                children: List.generate(
                  reminders.length,
                  (index) => Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    child: Card(
                      color: Colors.white,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 90,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    reminders[index].stop.name,
                                    // overflow: TextOverflow.fade,
                                  ),
                                  Text(
                                    DateFormat("EEEE dd 'at' hh:mm a")
                                        .format(reminders[index].time),
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.directions_bus,
                                            size: 13, color: Colors.grey),
                                        Text(
                                            reminders[index].stop.route +
                                                ' towards ' +
                                                reminders[index]
                                                    .stop
                                                    .destination,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: AnalogClock(
                                decoration: BoxDecoration(
                                  // color: Colors.grey[50],
                                  shape: BoxShape.circle,
                                  // border: Border.all(
                                  //     width: 0.5, color: Colors.grey[600])
                                ),
                                hourHandColor: Colors.black87,
                                minuteHandColor: Colors.black54,
                                width: 50,
                                showDigitalClock: false,
                                showSecondHand: false,
                                showNumbers: false,
                                datetime: reminders[index].time,
                                showTicks: false,
                              ),
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                      ),
                      // // Using intl package to format
                      // title: Text(DateFormat("EEEE dd 'at' hh:mm a")
                      //     .format(reminders[index].time)),
                      // subtitle: Text('Bus ' + reminders[index].stop.route),
                    ),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (DismissDirection direction) async {
                      await deleteReminder(index);
                      print('Reminder removed');
                      updateReminders();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // ****************************************
      floatingActionButton: FloatingActionButton(
          onPressed: () => createReminder(context), child: Icon(Icons.add)),
    );
  }
}
