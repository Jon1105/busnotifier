import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:hkinfo/CovidHKApp/case.dart';
import 'package:intl/intl.dart';

Future<Map<String, dynamic>> hkMoreData() async {
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

  // Because details[3272]['Case no.'] == '2978'
  details.sort(
      (a, b) => int.parse(a['Case no.']).compareTo(int.parse(b['Case no.'])));

  // for each case registered in the buildings data
  List<Map<String, dynamic>> caseNums = [];
  for (Map<String, dynamic> building in buildings) {
    try {
      for (int cAse in building['Related probable/confirmed cases']
          .split(',')
          .map(int.parse)
          .toList()) {
        caseNums.add({'num': cAse, 'buildingDetail': building});
      }
    } on FormatException catch (_) {
      continue;
    }
  }

  caseNums.sort((Map case1, Map case2) => case1['num'].compareTo(case2['num']));

  // List<Case> cases = List.generate(caseNums.length, (index) => null);
  List<Case> cases = [];
  int i = 0;
  for (Map<String, dynamic> caseMap in caseNums) {
    // for (int i = 0; i < caseNums.length; i++) {
    if (caseNums[i]['num'] == null) {
      continue;
    }
    Map<String, dynamic> caseDetail = details[caseMap['num'] - 1];
    Map<String, dynamic> buildingDetail = caseMap['buildingDetail'];
    assert(int.parse(caseDetail['Case no.']) == caseMap['num']);
    int caseNum = int.parse(caseDetail['Case no.']);
    List<String> districts = [buildingDetail['District']];
    DateTime lastDateOfResidence;
    if (buildingDetail['Last date of residence of the case(s)'] != '') {
      lastDateOfResidence = DateFormat('d/M/yy')
          .parse(buildingDetail['Last date of residence of the case(s)']);
    }

    // if (i != 0) {
    //   if (caseNum == cases.last.caseNum) {
    //     districts.addAll(cases.last.districts);
    //     cases.removeLast();
    //   }
    // }

    var date = getDate(caseDetail['Date of onset']);
    String status = getStatus(date);
    cases.add(
      Case(
          caseNum: caseNum,
          reportDate: DateFormat('d/M/yy').parse(caseDetail['Report date']),
          districts: districts,
          building: buildingDetail['Building name'],
          age: caseDetail['Age'],
          male: caseDetail['Gender'] == 'M',
          onsetStatus: status,
          onsetDate: (status == 'Known') ? date : null,
          classification: caseDetail['Case classification*'],
          hkResident: caseDetail['HK/Non-HK resident'] == 'HK resident',
          lastDateofResidence: lastDateOfResidence),
    );
    i++;
  }

  // bruteForce
  cases.sort((Case a, Case b) => a.caseNum.compareTo(b.caseNum));
  return {'cases': cases, 'error': null};

// return {'error': Error};
}

//

String getStatus(dynamic value) {
  if (value.runtimeType == DateTime) {
    return 'Known';
  } else
    return value;
}

dynamic getDate(String value) {
  assert(value != null);
  try {
    return DateFormat('M/d/yy').parse(value);
  } on FormatException catch (_) {
    if (value == 'Asymptomatic' || value == 'Pending')
      return value;
    else
      return 'Unknown';
  }
}

// main(List<String> args) async {
//   print('Start');
//   Map val = await dataGetter();
//   print('Done');
//   print(val['cases'].last);
// }
