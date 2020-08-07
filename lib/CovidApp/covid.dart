import 'package:hkinfo/CovidApp/chart.dart';
import 'package:flutter/material.dart';
import 'package:hkinfo/CovidApp/country.dart';
import 'package:hkinfo/CovidApp/parser.dart';
import 'package:hkinfo/CovidApp/countries.dart';
import 'package:hkinfo/CovidApp/countrySearch.dart';
import 'package:hkinfo/CovidHKApp/hkCases.dart';
import 'package:url_launcher/url_launcher.dart';

class CovidTracker extends StatefulWidget {
  @override
  _CovidTrackerState createState() => _CovidTrackerState();
}

class _CovidTrackerState extends State<CovidTracker> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Country country = countries[0]; // HK by default
  bool loading = true;
  bool reloading = false;
  Map<String, dynamic> data = {};
  BoxDecoration boxDeco =
      BoxDecoration(borderRadius: BorderRadius.circular(30));
  static const EdgeInsets padding = EdgeInsets.all(15);
  static const EdgeInsets margin =
      EdgeInsets.symmetric(vertical: 5, horizontal: 10);

  String checkDate(DateTime date) {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    if (today.isAfter(date)) {
      if (date == today.add(Duration(days: -1))) {
        return 'yesterday';
      } else
        return (today.difference(date).inDays).toString() + ' days ago';
    } else if (today.isBefore(date)) {
      if (date == today.add(Duration(days: 1))) {
        return 'tommorrow';
      } else
        return (today.difference(date).inDays).toString() + ' days from now';
    }
    return 'today';
  }

  void showBar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Don\'t know where ${country.name} is?'),
      // action: IconButton(icon: Icons(Icons.help),),
      action: SnackBarAction(
          label: 'Find out',
          onPressed: () {
            launch(
                'https://en.wikipedia.org/wiki/' + stringParse(country.name));
            _scaffoldKey.currentState
                .removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
          }),
    ));
  }

  @override
  void initState() {
    super.initState();
    updateData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showBar();
    });
  }

  void updateData([override = false]) {
    if (mounted)
      setState(() {
        loading = true;
      });
    country.dataGetter(override: override).then((Map<String, dynamic> rdata) {
      if (mounted)
        setState(() {
          data = rdata;
          loading = false;
        });
    });
  }

  void reloadData() {
    // override is always true
    if (mounted)
      setState(() {
        reloading = true;
      });
    country.dataGetter(override: true).then((Map<String, dynamic> rdata) {
      if (mounted)
        setState(() {
          data = rdata;
          reloading = false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${country.name} Covid'),
              (!loading)
                  ? Text('Last updated : ${checkDate(data['data'].last.day)}',
                      style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400))
                  : SizedBox(height: 12)
            ],
          ),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh), onPressed: reloadData),
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  var cntry = await showSearch(
                      context: context, delegate: CountrySearch(countries));
                  if (cntry != null) {
                    setState(() {
                      country = cntry;
                      reloading = false;
                    });
                    updateData(false);
                    _scaffoldKey.currentState.removeCurrentSnackBar(
                        reason: SnackBarClosedReason.dismiss);
                    showBar();
                  }
                }),
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
                    children: <Widget>[
                      reloading
                          ? LinearProgressIndicator(
                              backgroundColor: Colors.transparent)
                          : Container(height: 4),
                      CovidChart(data, country, boxDeco),
                      Container(
                          margin: margin,
                          padding: padding,
                          decoration: boxDeco.copyWith(
                              gradient: LinearGradient(
                                  colors: [
                                Colors.orange[300],
                                Theme.of(context).accentColor
                              ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter)),
                          child: Column(
                            children: <Widget>[
                              Row(children: <Widget>[
                                Flexible(
                                    fit: FlexFit.tight,
                                    child: Center(
                                      child: Text('Confirmed',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold)),
                                    )),
                                (country.hasRecovered)
                                    ? Flexible(
                                        fit: FlexFit.tight,
                                        child: Center(
                                          child: Text('Recovered',
                                              style: TextStyle(
                                                  color: Colors.green[300],
                                                  fontWeight: FontWeight.bold)),
                                        ))
                                    : Container(),
                                Flexible(
                                    fit: FlexFit.tight,
                                    child: Center(
                                      child: Text('Deaths',
                                          style: TextStyle(
                                              color: Colors.redAccent[700],
                                              fontWeight: FontWeight.bold)),
                                    )),
                              ]),
                              Text('Total'),
                              Row(children: <Widget>[
                                Flexible(
                                    child: Center(
                                      child: Tooltip(
                                        message: data['data']
                                            .last
                                            .totalCases
                                            .toString(),
                                        child: Text(
                                            numParse(
                                                data['data'].last.totalCases),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 25)),
                                      ),
                                    ),
                                    fit: FlexFit.tight),
                                (country.hasRecovered)
                                    ? Flexible(
                                        child: Center(
                                          child: Tooltip(
                                            message: data['data']
                                                .last
                                                .totalRecovered
                                                .toString(),
                                            child: Text(
                                              numParse(data['data']
                                                  .last
                                                  .totalRecovered),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 25),
                                            ),
                                          ),
                                        ),
                                        fit: FlexFit.tight)
                                    : Container(),
                                Flexible(
                                    child: Center(
                                      child: Tooltip(
                                        message: data['data']
                                            .last
                                            .totalDeaths
                                            .toString(),
                                        child: Text(
                                          numParse(
                                              data['data'].last.totalDeaths),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 25),
                                        ),
                                      ),
                                    ),
                                    fit: FlexFit.tight),
                              ]),
                              // Divider(),
                              SizedBox(height: 10),
                              Text('New'),
                              Row(children: <Widget>[
                                Flexible(
                                    child: Center(
                                      child: Tooltip(
                                        message: data['data']
                                            .last
                                            .newCases
                                            .toString(),
                                        child: Text(
                                            numParse(
                                                data['data'].last.newCases),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 25)),
                                      ),
                                    ),
                                    fit: FlexFit.tight),
                                (country.hasRecovered)
                                    ? Flexible(
                                        child: Center(
                                          child: Tooltip(
                                              message: data['data']
                                                  .last
                                                  .newRecovered
                                                  .toString(),
                                              child: Text(
                                                numParse(data['data']
                                                    .last
                                                    .newRecovered),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 25),
                                              )),
                                        ),
                                        fit: FlexFit.tight)
                                    : Container(),
                                Flexible(
                                    child: Center(
                                      child: Tooltip(
                                        message: data['data']
                                            .last
                                            .newDeaths
                                            .toString(),
                                        child: Text(
                                          numParse(data['data'].last.newDeaths),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 25),
                                        ),
                                      ),
                                    ),
                                    fit: FlexFit.tight),
                              ]),
                            ],
                          )),
                      // Spacer(),
                      (country.moreInfoDataGetter != null)
                          ? GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        CasesInfo(country),
                                    transitionDuration:
                                        Duration(milliseconds: 200),
                                    transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) =>
                                        Align(
                                            child: ScaleTransition(
                                          scale: animation,
                                          child: FadeTransition(
                                              opacity: animation, child: child),
                                        ))));
                              },
                              child: Container(
                                width: double.infinity,
                                margin: margin,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                decoration: boxDeco.copyWith(
                                  color: Colors.blueGrey[200].withOpacity(0.5),
                                ),
                                child: Center(
                                    child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('More info available'),
                                    Icon(Icons.more_horiz)
                                  ],
                                )),
                              ),
                            )
                          : Container(),
                    ],
                  ));
  }
}
