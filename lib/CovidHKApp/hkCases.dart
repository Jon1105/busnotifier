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
            cases = rdata['cases'];
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
        data: Theme.of(context).copyWith(canvasColor: Colors.black),
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
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
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(colors: [
                                  Colors.lightGreenAccent,
                                  Colors.lightBlueAccent
                                ])),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Center(
                                    child: Text('Filters',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5)),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text('Districts : '),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 6),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.grey.withOpacity(0.5)),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          dropdownColor: Colors.white,
                                          value: filter.district,
                                          isDense: true,
                                          onChanged: (String district) =>
                                              setState(() =>
                                                  filter.district = district),
                                          items: CaseFilter.districts
                                              .map((String district) =>
                                                  DropdownMenuItem(
                                                    value: district,
                                                    child: Text(
                                                      district,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text('Case Types : '),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 6),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.grey.withOpacity(0.5)),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          dropdownColor: Colors.white,
                                          value: filter.caseClassification,
                                          isDense: true,
                                          onChanged: (String classification) =>
                                              setState(() =>
                                                  filter.caseClassification =
                                                      classification),
                                          items: CaseFilter.caseTypes
                                              .map((String caseType) =>
                                                  DropdownMenuItem(
                                                    value: caseType,
                                                    child: Text(
                                                      caseType,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('Last 14 days only'),
                                    SizedBox(
                                      height: 40,
                                      child: Checkbox(
                                          value: filter.fourTeenDaysAgo,
                                          onChanged: (bool val) => setState(
                                              () => filter.fourTeenDaysAgo =
                                                  val)),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                  child: TextField(
                                    controller: _searchController,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        hintText: 'Search', isDense: true),
                                  ),
                                ),
                                // Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(cases.length.toString() + ' items'),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        _searchController.text = '';
                                        filter.resetFilter();
                                        cases = filter.getCases();
                                      }),
                                      child: Icon(Icons.clear),
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        filter.textSearch =
                                            _searchController.text;
                                        cases = filter.getCases();
                                      }),
                                      child: Icon(Icons.search),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(values.length, (i) => i)
                                .map((int idx) {
                              int flex;
                              int total = 0;
                              values.forEach((val) {
                                if (val == CaseParse.building)
                                  total += 4;
                                else
                                  total += 2;
                              });
                              if (values[idx] == CaseParse.building)
                                flex = 4;
                              else
                                flex = 2;
                              double width =
                                  ((MediaQuery.of(context).size.width *
                                              0.8 /
                                              total) *
                                          flex) -
                                      16 / total * flex;
                              return SizedBox(
                                height: 40,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    dropdownColor: Colors.white,
                                    isDense: true,
                                    // underline: Container(),
                                    value: values[idx],
                                    selectedItemBuilder:
                                        (BuildContext context) {
                                      return CaseParse.possibilities
                                          .map((Function func) =>
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: width),
                                                child: Text(
                                                  func(null, true),
                                                  maxLines: 1,
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList();
                                    },
                                    items: CaseParse.possibilities
                                        .map(
                                            (Function func) => DropdownMenuItem(
                                                value: func,
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxWidth: width),
                                                  child: Text(
                                                    func(null, true),
                                                    maxLines: 3,
                                                    style:
                                                        TextStyle(fontSize: 14),
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

                        // Expanded(
                        //   flex: 12,
                        //   child: Scrollbar(
                        //     child: SingleChildScrollView(
                        //       child: DataTable(
                        //           columnSpacing: 10,
                        //           columns:
                        //               values.map<DataColumn>((Function func) {
                        //             return DataColumn(
                        //                 numeric: func == CaseParse.age ||
                        //                     func == CaseParse.caseNum,
                        //                 label: Text(func(null, true)));
                        //           }).toList(),
                        //           rows: cases.map<DataRow>((Case cAse) {
                        //             return DataRow(
                        //                 cells: values
                        //                     .map<DataCell>((Function func) {
                        //               return DataCell(Text(func(cAse)));
                        //             }).toList());
                        //           }).toList()),
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          flex: 12,
                          child: Stack(
                            children: <Widget>[
                              Scrollbar(
                                isAlwaysShown: true,
                                controller: _scrollController,
                                child: ListView.builder(
                                    controller: _scrollController,
                                    itemExtent:
                                        values.contains(CaseParse.building)
                                            ? 60
                                            : 40,
                                    reverse: !filter.ascending,
                                    itemCount: cases.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return Column(
                                        children: <Widget>[
                                          SizedBox(
                                            // height: 20,
                                            child: GestureDetector(
                                              onTap: () => showBottomSheet(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        Container(
                                                  padding: EdgeInsets.all(10),
                                                  color: Colors.brown,
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
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children:
                                                    values.map((Function func) {
                                                  int flex;
                                                  if (func ==
                                                      CaseParse.building)
                                                    flex = 4;
                                                  // else if (func == CaseParse.age ||
                                                  //     func == CaseParse.caseNum)
                                                  //   flex = 1;
                                                  else
                                                    flex = 2;
                                                  var data = func(cases[i]);
                                                  return Expanded(
                                                      flex: flex,
                                                      child: Text(
                                                        data,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w200),
                                                        textAlign:
                                                            (int.tryParse(
                                                                        data) !=
                                                                    null)
                                                                ? TextAlign
                                                                    .center
                                                                : null,
                                                      ));
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                          Divider()
                                        ],
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
                        ),
                      ],
                    ),
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
