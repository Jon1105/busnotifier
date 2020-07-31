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
