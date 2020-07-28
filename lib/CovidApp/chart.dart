import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'country.dart';
import 'day.dart';

class CovidChart extends StatelessWidget {
  final List<Day> data;
  final Country country;
  CovidChart(this.data, this.country);

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.blueGrey.withOpacity(0.5),
              tooltipPadding: EdgeInsets.all(7),
              getTooltipItems: (List<LineBarSpot> myList) {
                return [
                  LineTooltipItem(
                      'C: ${myList[0].y.toInt()}', TextStyle(fontWeight: FontWeight.bold)),
                  LineTooltipItem('R: ${myList[1].y.toInt()}', TextStyle()),
                  LineTooltipItem('D: ${myList[2].y.toInt()}', TextStyle())
                ];
              }),
        ),
        lineBarsData: [
          LineChartBarData(
              colors: [Colors.redAccent[700]],
              barWidth: 4,
              isCurved: true,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              spots: data
                  .map<FlSpot>(
                      (Day day) => FlSpot(day.index.toDouble(), day.totalDeaths.toDouble()))
                  .toList()),
          LineChartBarData(
              colors: [Colors.greenAccent],
              barWidth: 4,
              isCurved: true,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              spots: data
                  .map<FlSpot>(
                      (Day day) => FlSpot(day.index.toDouble(), day.totalRecovered.toDouble()))
                  .toList()),
          LineChartBarData(
              colors: [Colors.blue],
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              spots: data
                  .map<FlSpot>((Day day) => FlSpot(day.index.toDouble(), day.totalCases.toDouble()))
                  .toList())
        ],
        titlesData: FlTitlesData(
            leftTitles: SideTitles(
                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                getTitles: (double cases) {
                  if (cases == 0) {
                    return '0';
                  } else if (cases % 1000 == 0) {
                    return '${cases ~/ 1000}k';
                  } else {
                    return '';
                  }
                },
                showTitles: true),
            bottomTitles: SideTitles(
                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                getTitles: (double index) {
                  if (index % 60 == 0) {
                    return DateFormat('d/M')
                        .format(country.startDate.add(Duration(days: index.toInt())));
                  } else {
                    return '';
                  }
                },
                showTitles: true)),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(
          show: false,
        )));
  }
}
