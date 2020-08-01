import 'package:flutter/material.dart';
import 'package:hkinfo/CovidApp/country.dart';
import 'package:hkinfo/CovidHKApp/caseParse.dart';
import 'case.dart';
import 'package:hkinfo/CovidApp/countries.dart';

class CasesInfo extends StatefulWidget {
  final Country country;
  CasesInfo(this.country);

  @override
  _CasesInfoState createState() => _CasesInfoState();
}

class _CasesInfoState extends State<CasesInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = true;
  Map<String, dynamic> data;
  // ------------------
  bool casesInfo = true;
  // casesInfo == true
  // ------------------
  bool ascending = true;
  ScrollController _scrollController = ScrollController();
  List<Function> values = [CaseParse.caseNum, CaseParse.age, CaseParse.district];
  // ------------------
  Map<String, Map<String, int>> districtData;
  Map<String, int> totalData;
  Map<int, String> districtValues = ['total', 'local'].asMap();

  @override
  void initState() {
    super.initState();
    updateData();
  }

  void updateData() {
    setState(() {
      loading = true;
    });
    widget.country.moreInfoDataGetter().then((Map<String, dynamic> rdata) => setState(() {
          data = rdata;
          districtData = getTotalDataByDistrict();
          totalData = getTotalData();
          loading = false;
        }));
  }

  void goToTop() {
    _scrollController.jumpTo(ascending ? 0 : _scrollController.position.maxScrollExtent);
  }

  Map<String, int> getTotalData() {
    Map<String, int> totalMap = {
      'total': data['cases'].length,
      'hkResident': 0,
      'nonHKResident': 0,
      'male': 0,
      'female': 0,
      'imported': 0,
      'epidemiologicallyLinkedImported': 0,
      'local': 0,
      'epidemiologicallyLinkedLocal': 0,
      'possiblyLocal': 0,
      'epidemiologicallyLinkedPossiblyLocal': 0,
    };
    for (Case cAse in data['cases']) {
      if (cAse.hkResident)
        totalMap['hkResident'] += 1;
      else
        totalMap['nonHKResident'] += 1;

      if (cAse.male)
        totalMap['male'] += 1;
      else
        totalMap['female'] += 1;

      if (cAse.classification == 'Imported case')
        totalMap['imported'] += 1;
      else if (cAse.classification == 'Epidemiologically linked with imported case')
        totalMap['epidemiologicallyLinkedImported'] += 1;
      else if (cAse.classification == 'Local case')
        totalMap['local'] += 1;
      else if (cAse.classification == 'Epidemiologically linked with local case')
        totalMap['epidemiologicallyLinkedLocal'] += 1;
      else if (cAse.classification == 'Possibly local case')
        totalMap['possiblyLocal'] += 1;
      else if (cAse.classification == 'Epidemiologically linked with possibly local case')
        totalMap['epidemiologicallyLinkedPossiblyLocal'] += 1;
      else
        throw Exception('Case classification not aced for');
    }
    return totalMap;
  }

  Map<String, Map<String, int>> getTotalDataByDistrict() {
    Map<String, Map<String, int>> map = Map();
    for (Case cAse in data['cases']) {
      if (map.containsKey(cAse.district)) {
        map[cAse.district]['total'] += 1;
        if (cAse.hkResident)
          map[cAse.district]['hkResident'] += 1;
        else
          map[cAse.district]['nonHKResident'] += 1;
        if (cAse.male)
          map[cAse.district]['male'] += 1;
        else
          map[cAse.district]['female'] += 1;
        if (cAse.classification == 'Imported case')
          map[cAse.district]['imported'] += 1;
        else if (cAse.classification == 'Epidemiologically linked with imported case')
          map[cAse.district]['epidemiologicallyLinkedImported'] += 1;
        else if (cAse.classification == 'Local case')
          map[cAse.district]['local'] += 1;
        else if (cAse.classification == 'Epidemiologically linked with local case')
          map[cAse.district]['epidemiologicallyLinkedLocal'] += 1;
        else if (cAse.classification == 'Possibly local case')
          map[cAse.district]['possiblyLocal'] += 1;
        else if (cAse.classification == 'Epidemiologically linked with possibly local case')
          map[cAse.district]['epidemiologicallyLinkedPossiblyLocal'] += 1;
        else
          throw Exception('Case classification not accounted for');
      } else
        map[cAse.district] = {
          'total': 0,
          'hkResident': 0,
          'nonHKResident': 0,
          'male': 0,
          'female': 0,
          'imported': 0,
          'epidemiologicallyLinkedImported': 0,
          'local': 0,
          'epidemiologicallyLinkedLocal': 0,
          'possiblyLocal': 0,
          'epidemiologicallyLinkedPossiblyLocal': 0,
        };
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(casesInfo
            ? '${widget.country.name} Cases'
            : '${widget.country.name} Cases by District'),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: Navigator.of(context).pop),
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: updateData)],
      ),
      body: (loading)
          ? Center(child: CircularProgressIndicator())
          : (data['error'] != null)
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(data['errorMsg']),
                      RaisedButton(onPressed: updateData, child: Text('Try again'), elevation: 0)
                    ],
                  ),
                )
              : (casesInfo)
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text('Filters'),
                        Spacer(),
                        Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(onPressed: goToTop, child: Text('go to top')),
                            IconButton(
                              // elevation: 0,
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                setState(() {
                                  ascending = !ascending;
                                });
                                goToTop();
                              },
                              icon: Icon(ascending ? Icons.arrow_drop_down : Icons.arrow_drop_up),
                            )
                          ],
                        )),
                        Container(
                            color: Colors.blue,
                            child: AspectRatio(
                              aspectRatio: 0.75,
                              child: Scrollbar(
                                isAlwaysShown: true,
                                controller: _scrollController,
                                child: ListView.builder(
                                    controller: _scrollController,
                                    itemExtent: 60,
                                    reverse: !ascending,
                                    itemCount: data['cases'].length,
                                    itemBuilder: (BuildContext context, int i) {
                                      // assert(data['cases'][i].districts.length == 1);
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: values
                                            .map(
                                                (Function func) => FlexText(func(data['cases'][i])))
                                            .toList(),
                                      );
                                    }),
                              ),
                            )),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Text('Filters')
                          // Icon
                        ]),
                        Spacer(),
                        Container(
                            color: Colors.blue,
                            padding: EdgeInsets.all(8),
                            child: AspectRatio(
                                aspectRatio: 0.75,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  //! in empty list put dropdowns
                                  children: <Widget>[] +
                                      districtData.keys.map((String district) {
                                        // return Text('hi');
                                        return Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                                  FlexText(district,
                                                      style: Theme.of(context).textTheme.headline6,
                                                      flex: 4)
                                                ] +
                                                districtValues.keys.map((int index) {
                                                  return FlexText(
                                                      districtData[district][districtValues[index]]
                                                          .toString(),
                                                      flex: 1);
                                                }).toList());
                                      }).toList() +
                                      [
                                        Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                                  FlexText('Total',
                                                      style: Theme.of(context).textTheme.headline6,
                                                      flex: 4)
                                                ] +
                                                districtValues.keys.map((int index) {
                                                  return FlexText(
                                                      totalData[districtValues[index]].toString(),
                                                      flex: 1);
                                                }).toList())
                                      ],
                                )))
                      ],
                    ),
      floatingActionButton: FloatingActionButton(
          onPressed: loading ? null : () => setState(() => casesInfo = !casesInfo),
          child: Icon(Icons.swap_horiz)),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class FlexText extends StatelessWidget {
  final String data;
  final int flex;
  final TextStyle style;
  final TextOverflow overflow;
  FlexText(this.data, {this.flex, this.style, this.overflow = TextOverflow.clip});
  @override
  Widget build(BuildContext context) {
    return Flexible(child: Text(data, style: style, overflow: overflow), flex: flex);
  }
}
