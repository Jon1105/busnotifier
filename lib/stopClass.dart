class Stop {
  String id;
  String name;
  String route;
  bool inbound;
  String destination;
  Stop(this.id, this.name, this.route, String strDir, this.destination) {
    inbound = (strDir == 'I') ? true : false;
  }
}

// class Stop {
//   String shortName;
//   String id;
//   Stop(this.shortName, this.id);
//   static List<Stop> getStops() {
//     return <Stop>[
//       Stop('Stanley Beach Road', '002279'),
//       Stop('Central', '001032'),
//       Stop('School', '002545'),
//       Stop('Wah Yan College', '002487'),
//       Stop('Queen Elizabeth', '002485')
//     ];
//   }
// }
