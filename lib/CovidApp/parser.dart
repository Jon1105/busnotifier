String numParse(int number) {
  if (number == null) {
    throw Exception('num is null');
  }
  if (number > 999999) {
    return '${(number / 1000000).toStringAsFixed(2)}m';
  } else if (number > 999) {
    return '${(number / 1000).toStringAsFixed(2)}k';
  } else {
    return number.toString();
  }
}

String stringParse(String string, [bool lowerCase = false]) {
  if (lowerCase) {
    string = string.toLowerCase();
  }
  return string.replaceAll(' ', '_');
}

String beautify(String string) {
  // ----- ----- ----- ----- ----- -----
  if (string == 'title') return 'District';
  // ----- ----- ----- ----- ----- -----
  List<String> word = List();
  for (int i = 0; i < string.length; i++) {
    word.add(isUpper(string[i]) ? ' ' + string[i] : string[i]);
  }

  return firstUpper(word.join('').trim());
}

bool isUpper(String char) {
  assert(char.length == 1);
  return char.toUpperCase() == char;
}

String firstUpper(String string) {
  return string[0].toUpperCase() + string.substring(1);
}

// String numComma(double number) {
//   String s = number.toString();
  
// }