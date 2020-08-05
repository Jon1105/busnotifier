import 'package:flutter/material.dart';
import 'package:hkinfo/CovidApp/country.dart';
import 'package:hkinfo/CovidHKApp/caseParse.dart';
import 'package:hkinfo/CovidHKApp/bottomSheet.dart';
import 'package:hkinfo/CovidHKApp/filter.dart';
import 'package:hkinfo/CovidHKApp/case.dart';
import 'package:intl/intl.dart';

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
  List<Case> cases;
  // bool ascending = true;
  CaseFilter filter;
  ScrollController _scrollController = ScrollController();
  List<Function> values = [
    CaseParse.caseNum,
    CaseParse.reportDate,
    CaseParse.district
  ];
  List<Function> possibilities = [
    CaseParse.caseNum,
    CaseParse.reportDate,
    CaseParse.district,
    CaseParse.building,
    CaseParse.age,
    CaseParse.male,
    CaseParse.onset,
    CaseParse.lastDateOfResidence,
    CaseParse.classification,
    CaseParse.hkResident
  ];

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateData();
  }

  void updateData() {
    if (mounted) {
      setState(() {
        loading = true;
      });
      widget.country.moreInfoDataGetter().then((Map<String, dynamic> rdata) {
        if (mounted)
          setState(() {
            data = rdata;
            filter = CaseFilter(rdata['cases']);
            print('passed');
            // No filters applied yet
            cases = filter.cases;
            loading = false;
          });
      });
    }
  }

  void goToTop() {
    // _scrollController.jumpTo(ascending ? 0 : _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
        filter.ascending ? 0 : _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('${widget.country.name} Cases'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: Navigator.of(context).pop),
        actions: [
          IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: loading
                  ? null
                  : () {
                      _scaffoldKey.currentState.showBottomSheet(
                          (BuildContext _) => DistrictCasesBottomSheet(data));
                    }),
          IconButton(
              icon: Icon(Icons.refresh), onPressed: loading ? null : updateData)
        ],
      ),
      body: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: (loading)
            ? Center(child: CircularProgressIndicator())
            : (data['error'] != null)
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(data['errorMsg']),
                        RaisedButton(
                            onPressed: updateData,
                            child: Text('Try again'),
                            elevation: 0)
                      ],
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      // Filter Section
                      Expanded(
                        flex: 6,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(colors: [
                                Colors.lightGreenAccent,
                                Colors.lightBlueAccent
                              ])),
                          child: Column(
                            children: <Widget>[
                              Center(
                                  child: Text('Filters',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5)),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text('Case Range'),
                                  Expanded(
                                    child: RangeSlider(
                                        values: filter.range,
                                        onChanged: (RangeValues nValues) =>
                                            setState(
                                                () => filter.range = nValues),
                                        min: filter.min,
                                        max: filter.max,
                                        divisions:
                                            (filter.max - filter.min).toInt(),
                                        labels: RangeLabels(
                                            filter.range.start
                                                .toInt()
                                                .toString(),
                                            filter.range.end
                                                .toInt()
                                                .toString())),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: TextField(
                                      controller: _searchController,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                          hintText: 'search', isDense: true),
                                    ),
                                  ),
                                  Spacer(),
                                  Text('Last 14 days'),
                                  Checkbox(
                                      value: filter.fourTeenDaysAgo,
                                      onChanged: (bool val) => setState(
                                          () => filter.fourTeenDaysAgo = val))
                                ],
                              ),
                              Row(
                                children: <Widget>[],
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(cases.length.toString() + ' items'),
                                  IconButton(
                                      onPressed: () => setState(() {
                                            _searchController.text = '';
                                            filter.resetFilter();
                                            cases = filter.getCases();
                                          }),
                                      icon: Icon(Icons.clear)),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () => setState(() {
                                      filter.textSearch =
                                          _searchController.text;
                                      cases = filter.getCases();
                                    }),
                                    icon: Icon(Icons.search,
                                        color: Theme.of(context).accentColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(values.length, (i) => i)
                                .map((int idx) {
                              int flex;
                              int total = 0;
                              values.forEach((val) {
                                if (val == CaseParse.building)
                                  total += 4;
                                // else if (val == CaseParse.age ||
                                //     val == CaseParse.caseNum)
                                //   total += 1;
                                // else if (val == CaseParse.onset )
                                else
                                  total += 2;
                              });
                              if (values[idx] == CaseParse.building)
                                flex = 4;
                              // else if (values[idx] == CaseParse.age ||
                              //     values[idx] == CaseParse.caseNum)
                              //   flex = 1;
                              else
                                flex = 2;
                              double width =
                                  (MediaQuery.of(context).size.width *
                                          0.8 /
                                          total) *
                                      flex;
                              return SizedBox(
                                height: 40,
                                child: DropdownButtonHideUnderline(
                                  // alignedDropdown: true,
                                  child: DropdownButton(
                                    dropdownColor: Colors.white,
                                    isDense: true,
                                    // underline: Container(),
                                    value: values[idx],
                                    items: possibilities
                                        .map(
                                            (Function func) => DropdownMenuItem(
                                                value: func,
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxWidth: width),
                                                  child: Text(
                                                    func(null, true),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )))
                                        .toList(),
                                    onChanged: (func) {
                                      setState(() => values[idx] = func);
                                    },
                                  ),
                                ),
                              );
                            }).toList()),
                      ),
                      Expanded(
                        flex: 12,
                        child: Stack(
                          children: <Widget>[
                            Scrollbar(
                              isAlwaysShown: true,
                              controller: _scrollController,
                              child: ListView.builder(
                                  controller: _scrollController,
                                  itemExtent: 60,
                                  reverse: !filter.ascending,
                                  itemCount: cases.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return SizedBox(
                                      // height: 20,
                                      child: FlatButton(
                                        onPressed: () => showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                Dialog(
                                                  child: Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Center(
                                                          child: Text(
                                                            'Case ${cases[i].caseNum}',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Text(
                                                            'Report Date: ${DateFormat('yyyy-MM-dd').format(cases[i].reportDate)}'),
                                                        Text(
                                                            'Districts: ${cases[i].district}'),
                                                        Text(
                                                            'Building: ${cases[i].building}'),
                                                        Text(
                                                            'Age: ${cases[i].age}'),
                                                        Text(
                                                            'Gender: ${cases[i].male ? 'male' : 'female'}'),
                                                        Text(
                                                            'Onset Date: ${cases[i].onsetDate != null ? DateFormat('yyyy-MM-dd').format(cases[i].onsetDate) : cases[i].onsetStatus}'),
                                                        Text(
                                                            'Classification: ${cases[i].classification}'),
                                                        Text(
                                                            'Residency: ${cases[i].hkResident ? 'HK resident' : 'Non Resident'}'),
                                                        Text(
                                                            'Last Date of Residence: ${cases[i].lastDateofResidence != null ? DateFormat('yyyy-MM-dd').format(cases[i].lastDateofResidence) : '...'}'),
                                                      ],
                                                    ),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                )),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: values.map((Function func) {
                                            int flex;
                                            if (func == CaseParse.building)
                                              flex = 4;
                                            // else if (func == CaseParse.age ||
                                            //     func == CaseParse.caseNum)
                                            //   flex = 1;
                                            else
                                              flex = 2;
                                            return Expanded(
                                                flex: flex,
                                                child: Text(
                                                  func(cases[i]),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                ));
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                    color: Theme.of(context).iconTheme.color,
                                    onPressed: goToTop,
                                    icon: Icon(Icons.keyboard_arrow_up)),
                                IconButton(
                                  // elevation: 0,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      filter.ascending = !filter.ascending;
                                    });
                                    goToTop();
                                  },
                                  icon: Icon(filter.ascending
                                      ? Icons.arrow_drop_down
                                      : Icons.arrow_drop_up),
                                )
                              ],
                            )),
                          ],
                        ),
                      )
                    ],
                  ),
      ),
    );
  }
}

class FlexText extends StatelessWidget {
  final String data;
  final int flex;
  final TextStyle style;
  final TextOverflow overflow;
  FlexText(this.data,
      {this.flex, this.style, this.overflow = TextOverflow.clip});
  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Text(data, style: style, overflow: overflow), flex: flex);
  }
}
