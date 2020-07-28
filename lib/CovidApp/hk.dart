import 'country.dart';
import 'day.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

final Country hk = Country('Hong Kong', hkTotalData, () async {
  var data = await hkTotalData();
  return hkNewData(data);
}, 'assets/HK_flag.svg', startDate: DateTime(2020, 1, 8));

Future<List<Day>> hkTotalData() async {
  String url =
      'https://api.data.gov.hk/v2/filter?q=%7B%22resource%22%3A%22http%3A%2F%2Fwww.chp.gov.hk%2Ffiles%2Fmisc%2Flatest_situation_of_reported_cases_covid_19_eng.csv%22%2C%22section%22%3A1%2C%22format%22%3A%22json%22%7D';

  http.Response response = await http.get(url);
  if (response.statusCode != 200) {
    return null;
  }
  List mapDays = json.decode(response.body);
  return List.generate(
      mapDays.length,
      (int index) => Day(DateFormat('d/M/yyyy').parse(mapDays[index]['As of date']),
          totalCases: mapDays[index]['Number of confirmed cases'],
          totalDeaths: mapDays[index]['Number of death cases'],
          totalRecovered: mapDays[index]['Number of discharge cases'],
          index: index));

  // return mapDays.map((day) {
  //   return Day(
  //     DateFormat('d/M/yyyy').parse(day['As of date']),
  //     totalCases: day['Number of confirmed cases'],
  //     totalDeaths: day['Number of death cases'],
  //   );
  // }).toList();
}

List<Day> hkNewData(List<Day> data) {
  return List.generate(data.length, (index) {
    Day day = data[index];
    return Day(day.day,
        index: day.index,
        newCases: (day.index == 0) ? day.totalCases : day.totalCases - data[index - 1].totalCases,
        newDeaths:
            (day.index == 0) ? day.totalDeaths : day.totalDeaths - data[index - 1].totalDeaths,
        newRecovered: (day.index == 0)
            ? day.totalRecovered
            : day.totalRecovered - data[index - 1].totalRecovered,
        totalCases: day.totalCases,
        totalDeaths: day.totalDeaths,
        totalRecovered: day.totalRecovered);
  });
}
