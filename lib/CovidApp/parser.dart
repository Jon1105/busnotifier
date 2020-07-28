String numParse(int number) {
  if (number > 999999) {
    return '${(number / 1000000).toStringAsFixed(2)}M';
  } else if (number > 999) {
    return '${(number / 1000).toStringAsFixed(2)}K';
  } else {
    return number.toString();
  }
}