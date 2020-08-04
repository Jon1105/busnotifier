import 'package:flutter/foundation.dart';

class Case {
  //! Subtract 1 from from case number
  int caseNum;
  DateTime reportDate;
  List<String> districts; // 0 - 3151 inclusive
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
      @required this.districts,
      @required this.building,
      @required this.age,
      @required this.male,
      @required this.onsetStatus,
      this.onsetDate,
      @required this.classification,
      @required this.hkResident,
      this.lastDateofResidence}) {
    this.district = this.districts.join(', ');
  }

  // For reading to and from cache

  static Case fromMap(Map<String, dynamic> map) {
    return Case(
        caseNum: map['caseNum'],
        reportDate: DateTime.parse(map['reportDate']),
        districts: map['districts'],
        building: map['building'],
        age: map['age'],
        male: map['male'],
        onsetStatus: map['onsetStatus'],
        onsetDate: map['onsetDate'],
        classification: map['classification'],
        hkResident: map['hkResident'],
        lastDateofResidence: DateTime.parse(map['lastDateofResidence']));
  }

  Map<String, dynamic> toMap() {
    return {
      'caseNum': this.caseNum,
      'reportDate': this.reportDate.toIso8601String(),
      'districts': this.districts,
      'building': this.building,
      'age': this.age,
      'male': this.male,
      'onsetStatus': this.onsetStatus,
      'onsetDate': this.onsetDate.toIso8601String(),
      'classification': this.classification,
      'hkResident': this.hkResident,
      'lastDateofResidence': this.lastDateofResidence.toIso8601String()
    };
  }
}
