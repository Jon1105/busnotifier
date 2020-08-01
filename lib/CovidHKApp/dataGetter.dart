import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:hkinfo/CovidHKApp/case.dart';
import 'package:intl/intl.dart';

Future<Map<String, dynamic>> hkMoreData() async {
  print('calling');
  const String detailsUrl =
      'https://api.data.gov.hk/v2/filter?q=%7B%22resource%22%3A%22http%3A%2F%2Fwww.chp.gov.hk%2Ffiles%2Fmisc%2Fenhanced_sur_covid_19_eng.csv%22%2C%22section%22%3A1%2C%22format%22%3A%22json%22%7D';

  const String buildingsUrl =
      'https://api.data.gov.hk/v2/filter?q=%7B%22resource%22%3A%22http%3A%2F%2Fwww.chp.gov.hk%2Ffiles%2Fmisc%2Fbuilding_list_eng.csv%22%2C%22section%22%3A1%2C%22format%22%3A%22json%22%7D';

  http.Response detailsResponse;
  http.Response buildingsResponse;

  // Internet Logic

  try {
    detailsResponse = await http.get(detailsUrl);
    buildingsResponse = await http.get(buildingsUrl);
  } on SocketException catch (error) {
    return {'errorMsg': 'No internet Connection', 'error': error};
  } catch (error) {
    return {'errorMsg': 'Something went wrong', 'error': error};
  }

  // Decoding logic

  // List<Map<String, dynamic>> details = json.decode(detailsResponse.body);
  // List<Map<String, dynamic>> buildings = json.decode(buildingsResponse.body);
  List details = json.decode(detailsResponse.body);
  List buildings = json.decode(buildingsResponse.body);

  // for each case registered in the buildings data
  List<Map<String, int>> caseNums = [];
  // for (Map<String, dynamic> building in buildings) {
  for (int i = 0; i < buildings.length; i++) {
    try {
      for (int cAse
          in buildings[i]['Related probable/confirmed cases'].split(',').map(int.parse).toList()) {
        caseNums.add({'num': cAse, 'idx': i});
      }
    } on FormatException catch (e) {}
  }
  caseNums.sort((a, b) => a['num'].compareTo(b['num']));

  List<Case> cases = [];
  // for (Map<String, int> caseMap in caseNums) {
  for (int i = 0; i < caseNums.length; i++) {
    Map<String, dynamic> caseDetail = details[caseNums[i]['num'] - 1];
    Map<String, dynamic> buildingDetail = buildings[caseNums[i]['idx']];
    assert(int.parse(caseDetail['Case no.']) == caseNums[i]['num']);
    int caseNum = int.parse(caseDetail['Case no.']);
    String district = buildingDetail['District'];
    DateTime lastDateOfResidence;
    if (buildingDetail['Last date of residence of the case(s)'] != '') {
      lastDateOfResidence =
          DateFormat('M/d/yy').parse(buildingDetail['Last date of residence of the case(s)']);
    }

    // if (i != 0) {
    //   if (caseNum == cases.last.caseNum) {
    //     districts.addAll(cases.last.districts);
    //     cases.removeLast();
    //   }
    // }

    var date = getDate(caseDetail['Date of Onset']);
    String status = getStatus(date);
    cases.add(
      Case(
          caseNum: caseNum,
          reportDate: DateFormat('M/d/yy').parse(caseDetail['Report date']),
          district: district,
          building: buildingDetail['Building name'],
          age: caseDetail['Age'],
          male: caseDetail['Gender'] == 'M',
          onsetStatus: status,
          onsetDate: (status == 'Known') ? date : null,
          classification: caseDetail['Case classification*'],
          hkResident: caseDetail['HK/Non-HK resident'] == 'HK resident',
          lastDateofResidence: lastDateOfResidence),
    );
    if (status == 'Known') {
      print(date);
      }
  }

  // bruteForce

  return {'cases': cases, 'error': null};
}

//

String getStatus(dynamic value) {
  if (value.runtimeType == DateTime) {
    return 'Known';
  } else
    return value;
}

dynamic getDate(String value) {
  try {
    return DateFormat('M/d/yy').parse(value);
  } on FormatException catch (e) {
  }
  switch (value) {
    case 'Asymptomatic':
    case 'Pending':
    case 'Unkown':
      return value;
    default:
      return 'Unknown';
  }
}

// main(List<String> args) async {
//   print('Start');
//   Map val = await dataGetter();
//   print('Done');
//   print(val['cases'].last);
// }
