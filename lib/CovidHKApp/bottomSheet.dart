import 'package:flutter/material.dart';
import 'package:hkinfo/CovidHKApp/case.dart';
import 'package:hkinfo/CovidApp/parser.dart';
import 'package:hkinfo/CovidHKApp/filter.dart';

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
      map[district]['districtNum'] = CaseFilter.districts.indexOf(district);
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
