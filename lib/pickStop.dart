import 'package:flutter/material.dart';
import 'stopClass.dart';

class StopsSearch extends SearchDelegate<Stop> {
  final List<Map<String, String>> allStops;
  StopsSearch(this.allStops);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Map<String, String>> mapResults =
        allStops.where((Map<String, String> stopMap) {
      return stopMap['name'].toLowerCase() == query.toLowerCase();
    }).toList();
    return ListView(
      children: mapResults.map((Map<String, String> stopMap) {
        return ListTile(
          onTap: () => close(
              context,
              Stop(stopMap['id'], stopMap['name'], stopMap['route'],
                  stopMap['direction'], stopMap['destination'])),
          title: Text(stopMap['name']),
          subtitle: Column(
            children: <Widget>[
              Text('Route: ${stopMap['route']}'),
              Text('To: ${stopMap['destination']}')
            ],
          ),
        );
      }).toList(),
    );
  }

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
              Stop stop = Stop(stopMap['id'], stopMap['name'], stopMap['route'],
                  stopMap['direction'], stopMap['destination']);
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
