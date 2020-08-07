import 'package:intl/intl.dart';
import 'package:hkinfo/CovidHKApp/case.dart';

class CaseParse {
  Case cAse;
  CaseParse(this.cAse);
  static String caseNum([Case cAse, name = false]) {
    if (name) return 'Case Number';
    return cAse.caseNum.toString();
  }

  static String reportDate([Case cAse, name = false]) {
    if (name) return 'Report Date';
    return DateFormat('MM/dd/yy').format(cAse.reportDate);
  }

  static String districts([Case cAse, name = false]) {
    if (name) return 'Districts';
    return cAse.districts.join(' | ');
  }

  static String buildings([Case cAse, name = false]) {
    if (name) return 'Building';
    return cAse.buildings.join(' | ');
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
  }

  static String lastDatesOfResidence([Case cAse, name = false]) {
    if (name) return 'Last Date of Residence';
    if (cAse.lastDatesOfResidence != null)
      return cAse.lastDatesOfResidence
          .map((DateTime date) {
            if (date == null) return null;
            // else
            //   return date.toString();
            return DateFormat('MM/dd/yy').format(date);
          })
          .toList()
          .join(' | ');
    else
      return '...';
  }

  static String classification([Case cAse, name = false]) {
    if (name) return 'Kind';
    if (cAse.classification.contains('Epidemiologically linked with'))
      return cAse.classification.replaceAll('Epidemiologically l', 'L');
    return cAse.classification;
  }

  static String hkResident([Case cAse, name = false]) {
    if (name) return 'Residency';
    return cAse.hkResident ? 'HK-Resident' : 'Non HK-Resident';
  }

  static List<Function> get possibilities {
    return [
      CaseParse.caseNum,
      CaseParse.reportDate,
      CaseParse.districts,
      CaseParse.buildings,
      CaseParse.age,
      CaseParse.male,
      CaseParse.onset,
      CaseParse.lastDatesOfResidence,
      CaseParse.classification,
      CaseParse.hkResident
    ];
  }
}
