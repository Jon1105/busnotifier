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
      this.totalCases,
      this.totalDeaths,
      this.totalRecovered,
      this.newCases,
      this.newDeaths,
      this.newRecovered});
}
