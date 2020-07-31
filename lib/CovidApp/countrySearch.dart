import 'package:flutter/material.dart';
import 'package:hkinfo/CovidApp/country.dart';

class CountrySearch extends SearchDelegate<Country> {
  final List<Country> allCountries;
  CountrySearch(this.allCountries);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Country> selectCountries = allCountries
        .where((Country selectCountry) =>
            selectCountry.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return (selectCountries.isEmpty)
        ? Center(child: Text('No Countries match'))
        : ListView.builder(
            itemCount: selectCountries.length,
            itemBuilder: (BuildContext context, int i) {
              return ListTile(
                title: Text(selectCountries[i].name),
                subtitle: (selectCountries[i].hasRecovered)
                    ? Text('From ${selectCountries[i].source} with recovery data')
                    : Text('From ${selectCountries[i].source}'),
                onTap: () => close(context, selectCountries[i]),
              );
            });
  }
}
