import 'package:flutter/material.dart';
import 'package:hkinfo/CovidApp/country.dart';
import 'package:hkinfo/CovidHKApp/caseParse.dart';
import 'package:hkinfo/CovidHKApp/bottomSheet.dart';
import 'package:hkinfo/CovidHKApp/filter.dart';
import 'package:hkinfo/CovidHKApp/case.dart';

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
    setState(() {
      loading = true;
    });
    widget.country
        .moreInfoDataGetter()
        .then((Map<String, dynamic> rdata) => setState(() {
              data = rdata;
              filter = CaseFilter(rdata['cases']);
              print('passed');
              // No filters applied yet
              cases = filter.cases;
              loading = false;
            }));
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
      body: (loading)
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
                      child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.amberAccent[200],
                        ),
                        child: Column(
                          children: <Widget>[
                            Center(
                                child: Text('Filters',
                                    style:
                                        Theme.of(context).textTheme.headline5)),
                            // Row(
                            //   mainAxisSize: MainAxisSize.max,
                            //   children: <Widget>[
                            Text('Case Range'),
                            RangeSlider(
                                values: filter.range,
                                onChanged: (RangeValues nValues) =>
                                    setState(() => filter.range = nValues),
                                min: filter.min,
                                max: filter.max,
                                divisions: (filter.max - filter.min).toInt(),
                                labels: RangeLabels(
                                    filter.range.start.toInt().toString(),
                                    filter.range.end.toInt().toString())),
                            //   ],
                            // ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextField(
                                controller: _searchController,
                                maxLines: 1,
                                decoration: InputDecoration(hintText: 'search'),
                              ),
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
                                    filter.textSearch = _searchController.text;
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

                    Stack(
                      children: <Widget>[
                        Container(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                          child: AspectRatio(
                            aspectRatio: 0.8,
                            child: Scrollbar(
                              isAlwaysShown: true,
                              controller: _scrollController,
                              child: ListView.builder(
                                  controller: _scrollController,
                                  itemExtent: 60,
                                  reverse: !filter.ascending,
                                  itemCount: cases.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: values.map((Function func) {
                                        if (func == CaseParse.building) {
                                          return Expanded(
                                              flex: 3,
                                              child: Text(
                                                func(cases[i]),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                              ));
                                        } else {
                                          return Expanded(
                                            flex: 2,
                                            child: Center(
                                                child: Tooltip(
                                              child: Text(func(cases[i])),
                                              message:
                                                  CaseParse.building(cases[i]),
                                            )),
                                          );
                                        }
                                      }).toList(),
                                    );
                                  }),
                            ),
                          ),
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
                  ],
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
