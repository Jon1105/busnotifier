import 'package:flutter/material.dart';
import 'package:hkinfo/CovidHKApp/case.dart';

class CaseFilter {
  List<Case> cases;

  // filters
  RangeValues range;
  RangeValues dateRange;
  String textSearch;
  int maxDaysAgo;
  bool ascending = true;
  bool imported;
  bool local;
  //
  double max;
  double min;
  //

  DateTime firstDay = DateTime(2020, 7, 5);
  CaseFilter(this.cases) {
    this.max = this.cases.last.caseNum.toDouble();
    this.min = this.cases[0].caseNum.toDouble();
    resetFilter();
  }

  void caseNumRange(RangeValues range) {
    this.range = range;
  }

  List<Case> getCases() {
    List<Case> nCases = this.cases;
    if (!(this.range.start == this.min && this.range.end == this.max)) {
      nCases = nCases.where((Case cAse) {
        return cAse.caseNum >= this.range.start &&
            cAse.caseNum <= this.range.end;
      }).toList();
    }

    // Search

    if (textSearch != null) {
      nCases = nCases.where((Case cAse) {
        return (cAse.district
                .toLowerCase()
                .contains(this.textSearch.trim().toLowerCase()) ||
            cAse.building
                .toLowerCase()
                .contains(this.textSearch.trim().toLowerCase()) ||
            cAse.caseNum
                .toString()
                .contains(this.textSearch.trim().toLowerCase()));
      }).toList();
    }

    //
    // {
    //   DateTime now = DateTime.now();
    //   DateTime twoWeeksAgo = now.subtract(Duration(days: 14));
    //   nCases = nCases.where((Case cAse) {}).toList();
    // }
    return nCases;
  }

  void resetFilter() {
    this.range = RangeValues(this.min, this.max);
    this.dateRange;
    this.textSearch = '';
  }
}
