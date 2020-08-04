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
  static String caseNum([Case cAse, name = false]) {
    if (name) return 'Case Number';
    return cAse.caseNum.toString();
  }

  static String reportDate([Case cAse, name = false]) {
    if (name) return 'Report Date';
    return DateFormat('MM/dd/yy').format(cAse.reportDate);
  }

  static String district([Case cAse, name = false]) {
    if (name) return 'Districts';
    return cAse.district;
  }

  static String building([Case cAse, name = false]) {
    if (name) return 'Building';
    return cAse.building;
  }

  static String age([Case cAse, name = false]) {
    if (name) return 'Age';
    return cAse.age.toString();
  }

  static String male([Case cAse, name = false]) {
    if (name) return 'Gender';
    return cAse.male ? 'male' : 'female';
  }

  static String onset([Case cAse, name = false]) {
    if (name) return 'Onset Date';
    if (cAse.onsetStatus == 'Known')
      return DateFormat('MM/dd/yy').format(cAse.onsetDate);
    else
      return cAse.onsetStatus;
    // switch (cAse.onsetStatus) {
    //   case 'Known':
    //     return DateFormat('MMMd').format(cAse.onsetDate);
    //   case 'Unknown':
    //     return '';
    //   default:
    //     return cAse.onsetStatus;
    // }
  }

  static String lastDateOfResidence([Case cAse, name = false]) {
    if (name) return 'Last Date of Residence';
    return (cAse.lastDateofResidence == null)
        ? ''
        : DateFormat('MMMd').format(cAse.lastDateofResidence);
  }

  static String classification([Case cAse, name = false]) {
    if (name) return 'Kind';
    if (cAse.classification.contains('Epidemiologically linked with'))
      return cAse.classification.replaceAll('Epidemiologically l', 'L');
    return cAse.classification;
  }

  static String hkResident([Case cAse, name = false]) {
    if (name) return 'Residency';
    return cAse.hkResident ? 'Resident' : 'Non-Resident';
  }
}
