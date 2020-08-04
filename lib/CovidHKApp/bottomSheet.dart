import 'package:flutter/material.dart';
import 'package:hkinfo/CovidHKApp/case.dart';
import 'package:hkinfo/CovidApp/parser.dart';

class DistrictCasesBottomSheet extends StatefulWidget {
  final Map<String, dynamic> data;
  DistrictCasesBottomSheet(this.data);

  @override
  _DistrictCasesBottomSheetState createState() =>
      _DistrictCasesBottomSheetState();
}

class _DistrictCasesBottomSheetState extends State<DistrictCasesBottomSheet> {
  Map<String, Map<String, int>> districtData;
  // ! Can be ['title', 'total', 'hkResident', 'nonHkResident', 'male', 'female', 'imported', 'importedLinked', 'local', 'localLinked', 'possiblyLocal', 'possiblyLocalLinked']
  static const List<String> possibilities = [
    'total',
    'hkResident',
    'nonHkResident',
    'male',
    'female',
    'imported',
    'importedLinked',
    'local',
    'localLinked',
    // 'possiblyLocal',
    // 'possiblyLocalLinked'
  ];
  // List<DropdownMenuItem> possibilityItems = ;
  Map<int, String> districtValues = {0: 'title', 1: 'total', 2: 'local'};

  Map<String, Map<String, int>> getTotalDataByDistrict() {
    Map<String, Map<String, int>> map = {'Total': Map()};
    void incrementFieldAndTotal(String field, Case cAse) {
      for (String district in cAse.districts) {
        try {
          map[district][field] += 1;
        } catch (_) {
          map[district][field] = 1;
        }
      }
      try {
        map['Total'][field] += 1;
      } catch (_) {
        map['Total'][field] = 1;
      }
    }

    for (Case cAse in widget.data['cases']) {
      if (!map.containsKey(cAse.district)) map[cAse.district] = Map();
      incrementFieldAndTotal('total', cAse);
      if (cAse.hkResident)
        incrementFieldAndTotal('hkResident', cAse);
      else
        incrementFieldAndTotal('nonHkResident', cAse);

      if (cAse.male)
        incrementFieldAndTotal('male', cAse);
      else
        incrementFieldAndTotal('female', cAse);

      if (cAse.classification == 'Imported case')
        incrementFieldAndTotal('imported', cAse);
      else if (cAse.classification ==
          'Epidemiologically linked with imported case')
        incrementFieldAndTotal('importedLinked', cAse);
      else if (cAse.classification == 'Local case')
        incrementFieldAndTotal('local', cAse);
      else if (cAse.classification ==
          'Epidemiologically linked with local case')
        incrementFieldAndTotal('localLinked', cAse);
      else if (cAse.classification == 'Possibly local case')
        incrementFieldAndTotal('possiblyLocal', cAse);
      else if (cAse.classification ==
          'Epidemiologically linked with possibly local case')
        incrementFieldAndTotal('possiblyLocalLinked', cAse);
      else
        throw Exception('Case classification not accounted for');
    }
    // set num

    for (String district in map.keys) {
      switch (district) {
        case 'Islands':
          map[district]['districtNum'] = 1;
          break;
        case 'Kwai Tsing':
          map[district]['districtNum'] = 2;
          break;
        case 'North':
          map[district]['districtNum'] = 3;
          break;
        case 'Sai Kung':
          map[district]['districtNum'] = 4;
          break;
        case 'Sha Tin':
          map[district]['districtNum'] = 5;
          break;
        case 'Tai Po':
          map[district]['districtNum'] = 6;
          break;
        case 'Tsuen Wan':
          map[district]['districtNum'] = 7;
          break;
        case 'Tuen Mun':
          map[district]['districtNum'] = 8;
          break;
        case 'Yuen Long':
          map[district]['districtNum'] = 9;
          break;
        case 'Kowloon CIty':
          map[district]['districtNum'] = 10;
          break;
        case 'Kwun Tong':
          map[district]['districtNum'] = 11;
          break;
        case 'Sham Shui Po':
          map[district]['districtNum'] = 12;
          break;
        case 'Wong Tai SIn':
          map[district]['districtNum'] = 13;
          break;
        case 'Yau Tsim Mong':
          map[district]['districtNum'] = 14;
          break;
        case 'Central & Western':
          map[district]['districtNum'] = 15;
          break;
        case 'Eastern':
          map[district]['districtNum'] = 16;
          break;
        case 'Southern':
          map[district]['districtNum'] = 17;
          break;
        case 'Wan Chai':
          map[district]['districtNum'] = 18;
          break;
        default:
      }
    }

    return map;
  }

  @override
  void initState() {
    super.initState();
    districtData = getTotalDataByDistrict();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: MediaQuery.of(context).size.height * 0.63,
        margin: EdgeInsets.all(10),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10)
            .copyWith(bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Image(image: AssetImage('assets/HK-districts.png')),
            ),
            FittedBox(
              child: Row(
                children: districtValues.keys
                    .map((int i) => Column(
                          crossAxisAlignment: (i == 0)
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                                (i == 0)
                                    ? Text(
                                        beautify(districtValues[i]),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      )
                                    : Container(
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            dropdownColor: Colors.white,
                                            isDense: true,
                                            isExpanded: false,
                                            value: districtValues[i],
                                            items:
                                                possibilities.map((String key) {
                                              return DropdownMenuItem(
                                                  child: ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 56),
                                                    child: Text(beautify(key),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1),
                                                  ),
                                                  value: key);
                                            }).toList(),
                                            onChanged: (key) {
                                              assert(key.runtimeType == String);
                                              setState(() {
                                                districtValues.update(
                                                    i, (value) => key);
                                              });
                                              print(districtValues);
                                            },
                                          ),
                                        ),
                                      )
                              ] +
                              districtData.keys.map((String district) {
                                return (i != 0)
                                    ? Text((districtData[district]
                                                [districtValues[i]] ??
                                            '0')
                                        .toString())
                                    : Text(
                                        (district != 'Total')
                                            ? district +
                                                ' (${districtData[district]['districtNum']})'
                                            : district,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1);
                              }).toList(),
                        ))
                    .toList(),
              ),
            ),
          ],
        ));
  }
}
