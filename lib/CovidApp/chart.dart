import 'package:hkinfo/CovidApp/parser.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:hkinfo/CovidApp/country.dart';
import 'package:hkinfo/CovidApp/day.dart';

class CovidChart extends StatefulWidget {
  final Map<String, dynamic> data;
  final Country country;
  final BoxDecoration boxDeco;
  CovidChart(this.data, this.country, this.boxDeco);

  @override
  _CovidChartState createState() => _CovidChartState();
}

class _CovidChartState extends State<CovidChart> {
  bool showingNew = false;
  bool deathScale = false;
  List<LineChartBarData> lineBarsData = [];

  LineChartBarData barData(String type, Color color) {
    int newValue;
    int totalValue;
    return LineChartBarData(
        colors: [color],
        barWidth: 2,
        isCurved: true,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        spots: widget.data['data'].map<FlSpot>((Day day) {
          if (type == 'c') {
            newValue = day.newCases;
            totalValue = day.totalCases;
          } else if (type == 'r') {
            newValue = day.newRecovered;
            totalValue = day.totalRecovered;
          } else if (type == 'd') {
            newValue = day.newDeaths;
            totalValue = day.totalDeaths;
          } else {
            throw Exception();
          }
          if (deathScale) {
            if (showingNew) {
              print(widget.data['maxNewDeaths']);
              if (newValue <= widget.data['maxNewDeaths'] && newValue >= 0) {
                return FlSpot(day.index.toDouble(), newValue.toDouble());
              } else
                return FlSpot.nullSpot;
            } else {
              if (totalValue <= widget.data['data'].last.totalDeaths &&
                  totalValue >= 0) {
                return FlSpot(day.index.toDouble(), totalValue.toDouble());
              } else
                return FlSpot.nullSpot;
            }
          } else {
            if (showingNew) {
              if (newValue <= widget.data['maxNewCases'] && newValue >= 0) {
                return FlSpot(day.index.toDouble(), newValue.toDouble());
              } else
                return FlSpot.nullSpot;
            } else {
              if (totalValue <= widget.data['data'].last.totalCases &&
                  totalValue >= 0) {
                return FlSpot(day.index.toDouble(), totalValue.toDouble());
              } else
                return FlSpot.nullSpot;
            }
          }
        }).toList());
  }

  List<LineChartBarData> getBarData() {
    List<LineChartBarData> list = [];
    if (widget.country.hasRecovered) {
      list.add(barData('r', Color(0xFF37e6d4)));
    }
    list.addAll([
      barData('d', Colors.redAccent[700]),
      barData('c', Colors.blue),
    ]);
    return list;
  }

  List<LineTooltipItem> getToolTipItems(List<LineBarSpot> spots) {
    var list = [LineTooltipItem('C: ${spots[0].y.toInt()}', TextStyle())];
    if (widget.country.hasRecovered) {
      list.add(LineTooltipItem('R: ${spots[1].y.toInt()}', TextStyle()));
    }
    list.add(LineTooltipItem(
        'D: ${spots[spots.length - 1].y.toInt()}', TextStyle()));
    return list;
  }

  String getTitles(int max, double cases, String suffix, [int multiplier = 1]) {
    if (cases == 0) {
      return '0';
    } else if (cases % max == 0) {
      if (suffix == '') {
        return cases.toInt().toString();
      }
      return ((cases ~/ max) * multiplier).toString() + suffix;
    } else if (cases == max) {
      return numParse(cases.toInt());
    } else {
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    lineBarsData = getBarData();
  }

  @override
  Widget build(BuildContext context) {
    String title1 = (showingNew) ? 'New' : 'Total';
    String title2 = (deathScale)
        ? 'Deaths'
        : 'Cases'; //(widget.country.hasRecovered) ? 'Cases & Recovered' : 'Cases';

    return Container(
        margin:
            EdgeInsets.symmetric(vertical: 5, horizontal: 10).copyWith(top: 0),
        padding: EdgeInsets.all(15),
        decoration: widget.boxDeco.copyWith(
            gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.deepOrange[300]],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter)),
        child: Column(children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.loop, color: Colors.white),
                  onPressed: () => setState(() {
                        showingNew = !showingNew;
                        lineBarsData = getBarData();
                      })),
              Text(title1 + ' ' + title2,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white)),
              IconButton(
                  color: Colors.white,
                  icon: (deathScale)
                      ? Icon(Icons.airline_seat_flat)
                      : Icon(Icons.airline_seat_flat_angled),
                  onPressed: null
                  // () {
                  //   setState(() {
                  //     deathScale = !deathScale;
                  //     lineBarsData = getBarData();
                  //   });
                  // }
                  ),
            ],
          ),
          AspectRatio(
              aspectRatio: 1.5,
              child: LineChart(LineChartData(
                  minY: 0,
                  maxY: (showingNew)
                      ? (deathScale)
                          ? widget.data['maxNewDeaths'].toDouble()
                          : null
                      // : widget.data['maxNewCases'].toDouble()
                      : (deathScale)
                          ? widget.data['data'].last.totalDeaths.toDouble()
                          : null,
                  // : widget.data['data'].last.totalCases.toDouble(),
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.blueGrey.withOpacity(0.5),
                        tooltipPadding: EdgeInsets.all(7),
                        getTooltipItems: getToolTipItems),
                  ),
                  lineBarsData: lineBarsData,
                  titlesData: FlTitlesData(
                      leftTitles: SideTitles(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                          getTitles: (double cases) {
                            int max;
                            if (deathScale) {
                              max = (showingNew)
                                  ? widget.data['maxNewDeaths']
                                  : widget.data['data'].last.totalDeaths;
                            } else {
                              max = (showingNew)
                                  ? widget.data['maxNewCases']
                                  : widget.data['data'].last.totalCases;
                            }
                            if (max > 1200000) {
                              return getTitles(1000000, cases, 'm');
                            } else if (max > 120000) {
                              return getTitles(100000, cases, 'k', 100);
                            } else if (max > 12000) {
                              return getTitles(10000, cases, 'k', 10);
                            } else if (max > 1200) {
                              return getTitles(1000, cases, 'k');
                            } else if (max > 120) {
                              return getTitles(100, cases, '');
                            } else if (max > 12) {
                              return getTitles(10, cases, '');
                            } else
                              return getTitles(0, cases, '');
                          },
                          showTitles: true),
                      bottomTitles: SideTitles(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11),
                          getTitles: (double index) {
                            if ((index % 60) == 0) {
                              return DateFormat('MMMd').format(widget
                                  .country.startDate
                                  .add(Duration(days: index.toInt())));
                            } else {
                              return '';
                            }
                          },
                          showTitles: true)),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(
                    show: false,
                  ))))
        ]));
  }
}
