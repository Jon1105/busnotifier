import 'package:hkinfo/CovidApp/chart.dart';
import 'package:flutter/material.dart';
import 'package:hkinfo/CovidApp/country.dart';
import 'package:hkinfo/CovidApp/parser.dart';
import 'package:hkinfo/CovidApp/countries.dart';
import 'package:hkinfo/CovidApp/countrySearch.dart';

class CovidTracker extends StatefulWidget {
  @override
  _CovidTrackerState createState() => _CovidTrackerState();
}

class _CovidTrackerState extends State<CovidTracker> {
  Country country = countries[0];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.directions_bus, color: Colors.deepOrange),
            onPressed: Navigator.of(context).pop),
        // elevation: 0,
        title: Text('${country.name} Covid'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                var cntry = await showSearch(context: context, delegate: CountrySearch(countries));
                if (cntry != null) {
                  setState(() => country = cntry);
                }
              })
        ],
      ),
      body: FutureBuilder(
        future: country.dataGetter(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          BoxDecoration boxDeco = BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            //     boxShadow: [
            //   BoxShadow(offset: Offset(0.5, 3), color: Colors.black.withOpacity(0.3), blurRadius: 2)
            // ]
          );
          const EdgeInsets padding = EdgeInsets.all(15);
          const EdgeInsets margin = EdgeInsets.all(10);

          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: <Widget>[
                // SizedBox(height: 8),

                // Chart
                CovidChart(snapshot.data, country, boxDeco),
                // Stats
                Container(
                    margin: margin,
                    padding: padding,
                    decoration: boxDeco.copyWith(
                        // boxShadow: [BoxShadow(offset: Offset(0, 3), color: Colors.grey[300])],
                        gradient: LinearGradient(
                            colors: [Colors.orange[300], Theme.of(context).accentColor],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Column(
                      children: <Widget>[
                        Row(children: <Widget>[
                          Flexible(
                              fit: FlexFit.tight,
                              child: Center(
                                child: Text('Confirmed',
                                    style:
                                        TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                              )),
                          (country.hasRecovered)
                              ? Flexible(
                                  fit: FlexFit.tight,
                                  child: Center(
                                    child: Text('Recovered',
                                        style: TextStyle(
                                            color: Colors.green[300], fontWeight: FontWeight.bold)),
                                  ))
                              : Container(),
                          Flexible(
                              fit: FlexFit.tight,
                              child: Center(
                                child: Text('Deaths',
                                    style: TextStyle(
                                        color: Colors.redAccent[700], fontWeight: FontWeight.bold)),
                              )),
                        ]),
                        Text('Total'),
                        Row(children: <Widget>[
                          Flexible(
                              child: Center(
                                child: Text(numParse(snapshot.data['data'].last.totalCases),
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25)),
                              ),
                              fit: FlexFit.tight),
                          (country.hasRecovered)
                              ? Flexible(
                                  child: Center(
                                    child: Text(
                                      numParse(snapshot.data['data'].last.totalRecovered),
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                                    ),
                                  ),
                                  fit: FlexFit.tight)
                              : Container(),
                          Flexible(
                              child: Center(
                                child: Text(
                                  numParse(snapshot.data['data'].last.totalDeaths),
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
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
                                child: Text(numParse(snapshot.data['data'].last.newCases),
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25)),
                              ),
                              fit: FlexFit.tight),
                          (country.hasRecovered)
                              ? Flexible(
                                  child: Center(
                                    child: Text(
                                      numParse(snapshot.data['data'].last.newRecovered),
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                                    ),
                                  ),
                                  fit: FlexFit.tight)
                              : Container(),
                          Flexible(
                              child: Center(
                                child: Text(
                                  numParse(snapshot.data['data'].last.newDeaths),
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                                ),
                              ),
                              fit: FlexFit.tight),
                        ]),
                      ],
                    )),
                Spacer(),
                Container(
                  width: double.infinity,
                  margin: margin,
                  padding: EdgeInsets.all(3),
                  decoration: boxDeco.copyWith(
                    // boxShadow: [BoxShadow(offset: Offset(0, 3), color: Colors.grey[300])],
                    color: Colors.blueGrey[200].withOpacity(0.5),
                  ),
                  child: Center(
                      child: Text('Last updated : ${checkDate(snapshot.data['data'].last.day)}')),
                ),
              ],
            );
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight,
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
