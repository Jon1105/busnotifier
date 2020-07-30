import 'package:hkinfo/CovidApp/day.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

Future<Map<String, dynamic>> owidDataGetter(String name) async {
  String url = 'https://covid.ourworldindata.org/data/owid-covid-data.json';
  http.Response response = await http.get(url);
  if (response.statusCode != 200) {
    throw Exception('Failed http request\nError: ${response.statusCode}');
  }
  var data = json.decode(response.body);
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
      return {'data': myList, 'maxNewCases': maxNewCases, 'maxNewDeaths': maxNewDeaths};
    }
  }
  throw Exception('Invalid Country');
}
