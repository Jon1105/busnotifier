import 'package:flutter/material.dart';
import 'package:hkinfo/BusNotifierApp/stopClass.dart';

class StopsSearch extends SearchDelegate<Stop> {
  final List<Map<String, String>> allStops;
  StopsSearch(this.allStops);

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
    List<Map<String, String>> stops = (query != '')
        ? allStops.where((Map<String, String> stop) {
            return (stop['name'].toLowerCase().contains(query.toLowerCase()) ||
                stop['route'].toLowerCase().startsWith(query.toLowerCase()));
          }).toList()
        : [];
    return (stops.isEmpty)
        ? Center(child: Text('No stops'))
        : ListView.builder(
            itemCount: stops.length,
            itemBuilder: (BuildContext context, int index) {
              Map stopMap = stops[index];
              Stop stop = Stop.fromMap(stopMap);
              return ListTile(
                onTap: () {
                  close(context, stop);
                },
                title: Text(stop.name),
                subtitle: Text(stop.route +
                    ' ' +
                    ((stop.inbound) ? 'Inbound' : 'Outbound') +
                    ' to ' +
                    stop.destination),
                // subtitle: Text('On route ${stop.route} to ${stop.destination}'),
              );
            });
  }
}
