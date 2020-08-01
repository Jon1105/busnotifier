import 'package:flutter/foundation.dart';

class Case {
  //! Subtract 1 from from case number
  int caseNum;
  DateTime reportDate; // 0 - 3151 inclusive
  String district;
  String building;
  int age;
  bool male;
  String onsetStatus;
  DateTime onsetDate;
  String classification;
  bool hkResident;
  DateTime lastDateofResidence;
  Case(
      {@required this.caseNum,
      @required this.reportDate,
      @required this.district,
      @required this.building,
      @required this.age,
      @required this.male,
      @required this.onsetStatus,
      this.lastDateofResidence,
      this.onsetDate,
      @required this.classification,
      @required this.hkResident});
}
