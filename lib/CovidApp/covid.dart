import 'package:busnotifier/CovidApp/chart.dart';
import 'package:flutter/material.dart';
import 'country.dart';
import 'parser.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CovidTracker extends StatelessWidget {
  final Country country;
  CovidTracker(this.country);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Row(
            children: <Widget>[
              Text('${country.name} Covid Tracker'),
              Spacer(),
              Container(
                color: Colors.black,
                child: SvgPicture.asset(country.flagPath),
                height: 40,
                width: 60,
              )
            ],
          )),
      body: FutureBuilder(
        future: country.totalDataGetter(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          BoxDecoration boxDeco = BoxDecoration(borderRadius: BorderRadius.circular(30));
          const EdgeInsets padding = EdgeInsets.all(15);
          const EdgeInsets margin = EdgeInsets.all(10);

          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: <Widget>[
                // SizedBox(height: 8),
                // Chart
                Container(
                  margin: margin,
                  padding: padding,
                  decoration: boxDeco.copyWith(
                      gradient: LinearGradient(
                          colors: [Colors.deepPurple, Colors.purple],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter)),
                  child: Column(
                    children: <Widget>[
                      Text('Total Cases & Deaths',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white)),
                      AspectRatio(aspectRatio: 1.5, child: CovidChart(snapshot.data, country)),
                    ],
                  ),
                ),
                // Stats
                Container(
                    margin: margin.copyWith(top: 0),
                    padding: padding,
                    decoration: boxDeco.copyWith(
                        // boxShadow: [BoxShadow(offset: Offset(0, 3), color: Colors.grey[300])],
                        gradient: LinearGradient(
                            colors: [Colors.grey[200], Colors.grey[300]],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Confirmed',
                                    style: TextStyle(
                                        color: Colors.blue, fontWeight: FontWeight.bold))),
                            Align(
                                alignment: Alignment.center,
                                child: Text('Recovered',
                                    style: TextStyle(
                                        color: Colors.green[300], fontWeight: FontWeight.bold))),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Text('Dead',
                                    style: TextStyle(
                                        color: Colors.redAccent[700],
                                        fontWeight: FontWeight.bold))),
                          ],
                        ),
                        Text('Total'),
                        Stack(
                          // mainAxisSize: MainAxisSize.max,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(numParse(snapshot.data.last.totalCases),
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(numParse(snapshot.data.last.totalRecovered),
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(numParse(snapshot.data.last.totalDeaths),
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                            )
                          ],
                        ),
                        // Divider(),
                        SizedBox(height: 10),
                        Text('New'),
                        Stack(
                          // mainAxisSize: MainAxisSize.max,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  numParse(snapshot.data[snapshot.data.length - 1].totalCases -
                                      snapshot.data[snapshot.data.length - 2].totalCases),
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                numParse(snapshot.data[snapshot.data.length - 1].totalRecovered -
                                    snapshot.data[snapshot.data.length - 2].totalRecovered),
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                numParse(snapshot.data[snapshot.data.length - 1].totalDeaths -
                                    snapshot.data[snapshot.data.length - 2].totalDeaths),
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                            )
                          ],
                        )
                      ],
                    )),
                // Container(
                //   margin: margin.copyWith(top: 0),
                //   padding: padding,
                //   decoration: boxDeco.copyWith(gradient: Linear),
                //   child: Row(
                //     mainAxisSize: MainAxisSize.max,
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: <Widget>[
                //       Column(
                //         children: <Widget>[
                //           Text('New Cases', style: TextStyle(color: Colors.blue)),
                //           Text(
                //               (snapshot.data[snapshot.data.length - 1].totalCases -
                //                       snapshot.data[snapshot.data.length - 2].totalCases)
                //                   .toString(),
                //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))
                //         ],
                //       ),
                //       Column(
                //         children: <Widget>[
                //           Text('New Recovered', style: TextStyle(color: Colors.green[300])),
                //           Text(
                //             (snapshot.data[snapshot.data.length - 1].totalRecovered -
                //                     snapshot.data[snapshot.data.length - 2].totalRecovered)
                //                 .toString(),
                //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                //           )
                //         ],
                //       ),
                //       Column(
                //         children: <Widget>[
                //           Text('New Deaths', style: TextStyle(color: Colors.redAccent[700])),
                //           Text(
                //             (snapshot.data[snapshot.data.length - 1].totalDeaths -
                //                     snapshot.data[snapshot.data.length - 2].totalDeaths)
                //                 .toString(),
                //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                //           )
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
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
