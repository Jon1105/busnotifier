import 'package:flutter/material.dart';
import 'package:hkinfo/CovidApp/parser.dart';

class DistrictCasesBottomSheet extends StatefulWidget {
  final Map<String, Map> districtData;
  DistrictCasesBottomSheet(this.districtData);

  @override
  _DistrictCasesBottomSheetState createState() =>
      _DistrictCasesBottomSheetState();
}

class _DistrictCasesBottomSheetState extends State<DistrictCasesBottomSheet> {
  Map<int, String> districtValues = {0: 'title', 1: 'total', 2: 'local'};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(10),
        padding:
            EdgeInsets.symmetric(vertical: 5, horizontal: 10).copyWith(top: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // FlatButton(
            //     onPressed: Navigator.of(context).pop,
            //     child: Icon(Icons.keyboard_arrow_down)),
            Expanded(
              child: Image(image: AssetImage('assets/HK-districts.png')),
            ),
            Expanded(
              child: FittedBox(
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
                                              items: widget
                                                  .districtData['Southern'].keys
                                                  .map<
                                                      DropdownMenuItem<
                                                          String>>((key) {
                                                assert(
                                                    key.runtimeType == String);
                                                return DropdownMenuItem<String>(
                                                    child: ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth: 56),
                                                      child: Text(beautify(key),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .subtitle2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1),
                                                    ),
                                                    value: key);
                                              }).toList(),
                                              onChanged: (key) {
                                                assert(
                                                    key.runtimeType == String);
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
                                widget.districtData.keys.map((String district) {
                                  return (i != 0)
                                      ? Text((widget.districtData[district]
                                                  [districtValues[i]] ??
                                              '0')
                                          .toString())
                                      : Text(
                                          (district != 'All')
                                              ? district +
                                                  ' (${widget.districtData[district]['districtNum']})'
                                              : district,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1);
                                }).toList(),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ));
  }
}
