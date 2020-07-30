const List<String> countriesWithRecovered = ['Hong Kong'];

class Country {
  String name;
  String flagPath;
  Function dataGetter;
  DateTime startDate;
  Country(
    this.name,
    this.dataGetter,
    this.startDate, {
    this.flagPath,
  });

  bool get hasRecovered {
    if (countriesWithRecovered.contains(this.name)) {
      return true;
    }
    return false;
  }
}
