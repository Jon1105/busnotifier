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

  static Day fromMap(Map<String, dynamic> map) {
    return Day(
      DateTime.parse(map['day']),
      index: map['index'],
      totalCases: map['totalCases'],
      totalDeaths: map['totalDeaths'],
      totalRecovered: map['totalDeaths'],
      newCases: map['newCases'],
      newDeaths: map['newDeaths'],
      newRecovered: map['newRecovered']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': this.day.toIso8601String(),
      'index': this.index,
      'totalCases': this.totalCases,
      'totalRecovered': this.totalRecovered,
      'totalDeaths': this.totalDeaths,
      'newCases': this.newCases,
      'newRecovered': this.newRecovered,
      'newDeaths': this.newDeaths
    };
  }
}
