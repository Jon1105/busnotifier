import 'package:hkinfo/CovidHKApp/case.dart';

class CaseFilter {
  List<Case> cases;

  String textSearch;
  String district;
  bool fourTeenDaysAgo;
  bool ascending = true;
  String caseClassification;
  //

  DateTime firstDay = DateTime(2020, 7, 5);
  CaseFilter(this.cases) {
    resetFilter();
  }

  List<Case> getCases() {
    List<Case> nCases = this.cases;

    // Search

    if (textSearch != null) {
      nCases = nCases.where((Case cAse) {
        bool districts = false;
        bool buildings = false;

        for (String building in cAse.buildings) {
          if (building
                  .toLowerCase()
                  .trim()
                  .contains(textSearch.trim().toLowerCase()) ||
              this
                  .textSearch
                  .trim()
                  .toLowerCase()
                  .contains(building.trim().toLowerCase())) {
            buildings = true;
            break;
          }
        }

        for (String district in cAse.districts) {
          if (district
                  .toLowerCase()
                  .trim()
                  .contains(textSearch.trim().toLowerCase()) ||
              this
                  .textSearch
                  .trim()
                  .toLowerCase()
                  .contains(district.trim().toLowerCase())) {
            districts = true;
            break;
          }
        }

        bool caseNums = cAse.caseNum
                .toString()
                .contains(this.textSearch.trim().toLowerCase()) ||
            this
                .textSearch
                .trim()
                .toLowerCase()
                .contains(cAse.caseNum.toString());
        return districts || buildings || caseNums;
      }).toList();
    }

    if (this.fourTeenDaysAgo) {
      DateTime now = DateTime.now();
      nCases = nCases
          .where((Case cAse) => now.difference(cAse.reportDate).inDays < 15)
          .toList();
    }

    if (this.district != 'All' &&
        this.district != '' &&
        this.district != null) {
      nCases = nCases
          .where((Case cAse) => cAse.districts.contains(district))
          .toList();
    }

    if (this.caseClassification != 'All' &&
        this.caseClassification != '' &&
        this.caseClassification != null) {
      nCases = nCases
          .where((Case cAse) => cAse.classification
              .toLowerCase()
              .contains(this.caseClassification.toLowerCase()))
          .toList();
    }
    return nCases;
  }

  void resetFilter() {
    this.district = 'All';
    this.fourTeenDaysAgo = false;
    this.textSearch = '';
    this.caseClassification = 'All';
  }

  static List<String> get districts => [
        'All',
        'Islands',
        'Kwai Tsing',
        'North',
        'Sai Kung',
        'Sha Tin',
        'Tai Po',
        'Tsuen Wan',
        'Tuen Mun',
        'Yuen Long',
        'Kowloon City',
        'Kwun Tong',
        'Sham Shui Po',
        'Wong Tai Sin',
        'Yau Tsim Mong',
        'Central & Western',
        'Eastern',
        'Southern',
        'Wan Chai'
      ];
  static List<String> get caseTypes => [
        'All',
        'Local',
        'Imported',
      ];
}
