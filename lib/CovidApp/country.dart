const List<String> countriesWithRecovered = ['Hong Kong'];

class Country {
  String name;
  String flagPath;
  Function dataGetter;
  DateTime startDate;
  String source;
  Country(this.name, this.dataGetter, this.startDate, {this.source}) {
    this.source = (this.source == null) ? 'OurWorldInData.org' : this.source;
  }

  bool get hasRecovered {
    if (countriesWithRecovered.contains(this.name)) {
      return true;
    }
    return false;
  }
}
