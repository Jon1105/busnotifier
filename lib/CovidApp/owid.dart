import 'package:flutter/material.dart';
import 'package:hkinfo/CovidApp/day.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<Map<String, dynamic>> owidDataGetter(String name,
    [bool override = false]) async {
  // Currently only works for hk time
  File file = await _cacheFile;

  const TimeOfDay time = TimeOfDay(hour: 17, minute: 15);
  DateTime now = DateTime.now();
  DateTime nextUpdate =
      DateTime(now.year, now.month, now.day, time.hour, time.minute);
  if (!isAfter(TimeOfDay.now(), time))
    nextUpdate = nextUpdate.add(Duration(days: 1));

  if (file.lastModifiedSync().isBefore(nextUpdate)) {}
  Map<String, dynamic> data;

  ///
  String contents = await file.readAsString();
  if ((file.lastModifiedSync().isBefore(nextUpdate) &&
          now.isAfter(nextUpdate)) ||
      contents == '' ||
      contents == null ||
      override) {
    String url = 'https://covid.ourworldindata.org/data/owid-covid-data.json';
    http.Response response;
    try {
      response = await http.get(url);
      if (response.statusCode != 200) {
        return {
          'errorMsg': 'Something went wrong',
          'error': 0,
          'statusCode': response.statusCode
        };
      }
    } on SocketException catch (error) {
      return {'errorMsg': 'No internet Connection', 'error': error};
    } catch (error) {
      return {
        'error': error,
        'errorMsg': 'Something went wrong',
      };
    }
    file.writeAsString(response.body);
    data = json.decode(response.body);
  } else {
    data = json.decode(contents);
  }
  List<Day> myList = [];
  int maxNewCases = 0;
  int maxNewDeaths = 0;
  for (var value in data.values) {
    if (value['location'] == name) {
      for (int i = 0; i < value['data'].length; i++) {
        int newCases = value['data'][i]['new_cases'].toInt();
        int newDeaths = value['data'][i]['new_deaths'].toInt();
        myList.add(Day(
          DateFormat('yy-M-d').parse(value['data'][i]['date']),
          index: i,
          newCases: newCases,
          newDeaths: newDeaths,
          totalCases: value['data'][i]['total_cases'].toInt(),
          totalDeaths: value['data'][i]['total_deaths'].toInt(),
        ));
        if (newCases > maxNewCases) {
          maxNewCases = newCases;
        }
        if (newDeaths > maxNewDeaths) {
          maxNewDeaths = newDeaths;
        }
      }
      return {
        'data': myList,
        'maxNewCases': maxNewCases,
        'maxNewDeaths': maxNewDeaths,
        'error': null
      };
    }
  }
  throw Exception('Invalid Country');
}

Future<File> get _cacheFile async {
  Directory directory = await getApplicationDocumentsDirectory();
  File file = File('${directory.path}/owid-cache-data.json');
  if (!await file.exists()) await file.create();
  return file;
}

// Future<Map<String, dynamic>> readCache() async {
//   File file = await _cacheFile;
//   return json.decode(await file.readAsString());
// }

/// Checks if time1 is after time2
bool isAfter(TimeOfDay time1, TimeOfDay time2) =>
    (time1.hour + time1.minute / 60) > (time2.hour + time2.minute / 60);
