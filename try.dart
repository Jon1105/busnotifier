const String dartPath = 'C:\\src\\flutter\\bin\\cache\\dart-sdk\\bin\\dart.exe';

main(List<String> args) {
  // Map m = ['h', 'v'].asMap();
  // ! Cannot modify unmodifiable map
  Map m = {0: '4', 1: '0', 2: '4'};

  m[0] = '9999';
  print(myFunc(n: true));
}

bool myFunc({bool n = false}) => !n;
