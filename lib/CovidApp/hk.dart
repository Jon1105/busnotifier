import 'package:hkinfo/CovidApp/day.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';

Future<Map<String, dynamic>> hkDataGetter() async {
  String url =
      'https://api.data.gov.hk/v2/filter?q=%7B%22resource%22%3A%22http%3A%2F%2Fwww.chp.gov.hk%2Ffiles%2Fmisc%2Flatest_situation_of_reported_cases_covid_19_eng.csv%22%2C%22section%22%3A1%2C%22format%22%3A%22json%22%7D';

  http.Response response;
  try {
    response = await http.get(url);
    if (response.statusCode != 200) {
      return {
        'errorMsg': 'Something went wrong.',
        'error': 0,
        'statusCode': response.statusCode
      };
    }
  } on SocketException catch (error) {
    return {'errorMsg': 'No internet Connection', 'error': error};
  } catch (error) {
    return {'error': error};
  }
  List mapDays = json.decode(response.body);
  List<Day> returnList = [];
  int maxNewCases = 0;
  int maxNewDeaths = 0;
  int maxNewRecovered = 0;
  for (int i = 0; i < mapDays.length; i++) {
    int newCases = (i == 0)
        ? mapDays[i]['Number of confirmed cases']
        : mapDays[i]['Number of confirmed cases'] - mapDays[i - 1]['Number of confirmed cases'];
    int newDeaths = (i == 0)
        ? mapDays[i]['Number of death cases']
        : mapDays[i]['Number of death cases'] - mapDays[i - 1]['Number of death cases'];
    int newRecovered = (i == 0)
        ? mapDays[i]['Number of discharge cases']
        : mapDays[i]['Number of discharge cases'] - mapDays[i - 1]['Number of discharge cases'];
    returnList.add(Day(
      DateFormat('d/M/yyyy').parse(mapDays[i]['As of date']),
      index: i,
      totalCases: mapDays[i]['Number of confirmed cases'],
      totalDeaths: mapDays[i]['Number of death cases'],
      totalRecovered: mapDays[i]['Number of discharge cases'],
      newCases: newCases,
      newDeaths: newDeaths,
      newRecovered: newRecovered,
    ));
    if (newCases > maxNewCases) {
      maxNewCases = newCases;
    }
    if (newDeaths > maxNewDeaths) {
      maxNewDeaths = newDeaths;
    }
    if (newRecovered > maxNewRecovered) {
      maxNewRecovered = newRecovered;
    }
  }

  return {
    'data': returnList,
    'maxNewCases': maxNewCases,
    'maxNewDeaths': maxNewDeaths,
    'error': null
  };
}
