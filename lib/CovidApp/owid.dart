import 'package:hkinfo/CovidApp/day.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';

Future<Map<String, dynamic>> owidDataGetter(String name) async {
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
    return {'error': error, 'errorMsg': 'Something went wrong',};
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
