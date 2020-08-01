import 'package:intl/intl.dart';
import 'package:hkinfo/CovidHKApp/case.dart';

class CaseParse {
  Case cAse;
  CaseParse(this.cAse);

  // String caseNumS() {
  //   return cAse.caseNum.toString();
  // }

  // String reportDateS() {
  //   return DateFormat('MMMd').format(cAse.reportDate);
  // }

  // String districtS() {
  //   return cAse.district;
  // }

  // String buildingS() {
  //   return cAse.building;
  // }

  // String ageS() {
  //   return cAse.age.toString();
  // }

  // String maleS() {
  //   return cAse.male ? 'male' : 'female';
  // }

  // String onsetS() {
  //   switch (cAse.onsetStatus) {
  //     case 'Known':
  //       return DateFormat('MMMd').format(cAse.onsetDate);
  //     case 'Unknown':
  //       return '';
  //     default:
  //       return cAse.onsetStatus;
  //   }
  // }

  // String lastDateOfResidenceS() {
  //   return (cAse.lastDateofResidence == null)
  //       ? ''
  //       : DateFormat('MMMd').format(cAse.lastDateofResidence);
  // }

  // String classificationS() {
  //   return cAse.classification;
  // }

  // String hkResidentS() {
  //   return cAse.hkResident ? 'Resident' : 'Non-Resident';
  // }
  static String caseNum(Case cAse) {
    return cAse.caseNum.toString();
  }

  static String reportDate(Case cAse) {
    return DateFormat('MMMd').format(cAse.reportDate);
  }

  static String district(Case cAse) {
    return cAse.district;
  }

  static String building(Case cAse) {
    return cAse.building;
  }

  static String age(Case cAse) {
    return cAse.age.toString();
  }

  static String male(Case cAse) {
    return cAse.male ? 'male' : 'female';
  }

  static String onset(Case cAse) {
    switch (cAse.onsetStatus) {
      case 'Known':
        return DateFormat('MMMd').format(cAse.onsetDate);
      case 'Unknown':
        return '';
      default:
        return cAse.onsetStatus;
    }
  }

  static String lastDateOfResidence(Case cAse) {
    return (cAse.lastDateofResidence == null)
        ? ''
        : DateFormat('MMMd').format(cAse.lastDateofResidence);
  }

  static String classification(Case cAse) {
    return cAse.classification;
  }

  static String hkResident(Case cAse) {
    return cAse.hkResident ? 'Resident' : 'Non-Resident';
  }
}
