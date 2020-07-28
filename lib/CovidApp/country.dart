class Country {
  String name;
  String flagPath;
  Function totalDataGetter;
  Function newDataGetter;
  DateTime startDate;
  Country(this.name, this.totalDataGetter, this.newDataGetter, this.flagPath, {this.startDate});
}
