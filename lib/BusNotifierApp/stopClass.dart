class Stop {
  String id;
  String name;
  String route;
  bool inbound;
  String destination;
  Stop(this.id, this.name, this.route, String strDir, this.destination) {
    inbound = (strDir == 'I') ? true : false;
  }

  static Stop fromMap(Map<String, String> stopMap) {
    return Stop(stopMap['id'], stopMap['name'], stopMap['route'], stopMap['direction'],
        stopMap['destination']);
  }
}
