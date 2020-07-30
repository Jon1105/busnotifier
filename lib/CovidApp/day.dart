import 'package:flutter/foundation.dart';

class Day {
  DateTime day;
  int totalCases;
  int totalDeaths;
  int totalRecovered;
  int newCases;
  int newDeaths;
  int newRecovered;
  int index;
  Day(this.day,
      {@required this.index,
      @required this.totalCases,
      @required this.totalDeaths,
      this.totalRecovered,
      @required this.newCases,
      @required this.newDeaths,
      this.newRecovered});
}
