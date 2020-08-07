import 'dart:convert';
import 'dart:io';

import 'package:hkinfo/CovidHKApp/filter.dart';
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

  List details = json.decode(detailsResponse.body);
  List buildings = json.decode(buildingsResponse.body);

  // Because details[3272]['Case no.'] == '2978'
  // details.sort(
  //     (a, b) => int.parse(a['Case no.']).compareTo(int.parse(b['Case no.'])));
  Map<String, Map> count = {};
  List<String> listOfDistricts = CaseFilter.districts;
  for (int i = 0; i < listOfDistricts.length; i++) {
    {
      count[listOfDistricts[i]] = {
        'total': 0,
        'hkResident': 0,
        'nonHkResident': 0,
        'male': 0,
        'female': 0,
        'imported': 0,
        'local': 0,
      };
      count[listOfDistricts[i]]['districtNum'] = i;
    }
  }

  void increment(String field, Case cAse) {
    count['All'][field] += 1;
    cAse.districts.forEach((String district) {
      count[district][field] += 1;
    });
  }

  List<Case> cases = [];
  for (Map<String, dynamic> building in buildings) {
    try {
      for (int caseS in building['Related probable/confirmed cases']
          .split(',')
          .map(int.parse)
          .toList()) {
        Map<String, dynamic> caseDetail = details[caseS - 1];
        Map<String, dynamic> buildingDetail = building;
        assert(int.parse(caseDetail['Case no.']) == caseS);
        List<String> districts = [buildingDetail['District']];
        DateTime lastDateOfResidence;
        if (buildingDetail['Last date of residence of the case(s)'] != '') {
          lastDateOfResidence = DateFormat('d/M/yy')
              .parse(buildingDetail['Last date of residence of the case(s)']);
        }

        var date = getDate(caseDetail['Date of onset']);
        String status = getStatus(date);
        Case cAse = Case(
            caseNum: caseS,
            reportDate: DateFormat('d/M/yy').parse(caseDetail['Report date']),
            districts: districts,
            buildings: [buildingDetail['Building name']],
            age: caseDetail['Age'],
            male: caseDetail['Gender'] == 'M',
            onsetStatus: status,
            onsetDate: (status == 'Known') ? date : null,
            classification: caseDetail['Case classification*'],
            hkResident: caseDetail['HK/Non-HK resident'] == 'HK resident',
            lastDatesOfResidence:
                (lastDateOfResidence == null) ? [] : [lastDateOfResidence]);
        cases.add(cAse);
      }
    } on FormatException catch (_) {
      // building['Related probable/confirmed cases] == 'string'
      continue;
    }
  }
  cases.sort((Case a, Case b) => a.caseNum.compareTo(b.caseNum));
  // // [i] initialized at 1 to skip first case
  for (int i = 1; i < cases.length; i++) {
    if (cases[i].caseNum == cases[i - 1].caseNum) {
      if (cases[i].buildings != cases[i - 1].buildings) {
        cases[i].buildings.addAll(cases[i - 1].buildings);
      }
      if (cases[i].districts != cases[i - 1].districts) {
        cases[i].districts.addAll(cases[i - 1].districts);
      }
      if (cases[i].lastDatesOfResidence != cases[i - 1].lastDatesOfResidence) {
        cases[i].lastDatesOfResidence.addAll(cases[i - 1].lastDatesOfResidence);
      }
      cases.removeAt(i - 1);
      continue;
    }
    increment('total', cases[i]);
    if (cases[i].hkResident) {
      increment('hkResident', cases[i]);
    } else {
      increment('nonHkResident', cases[i]);
    }

    if (cases[i].male) {
      increment('male', cases[i]);
    } else {
      increment('female', cases[i]);
    }

    if (cases[i].classification == 'Imported case' ||
        cases[i].classification ==
            'Epidemiologically linked with imported case') {
      increment('imported', cases[i]);
    } else if (cases[i].classification == 'Local case' ||
        cases[i].classification == 'Epidemiologically linked with local case' ||
        cases[i].classification == 'Possibly local case' ||
        cases[i].classification ==
            'Epidemiologically linked with possibly local case') {
      increment('local', cases[i]);
    } else
      throw UnimplementedError();
  }
  count['All']['total'] = cases.length;

  // !!! Add each district here and total in 'count'
  return {'cases': cases, 'error': null, 'count': count};
}

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
