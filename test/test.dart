void main() {
  getN().then((value) => print(value));
  String? s = null;

  //getN().then((value) => print(value));
  print(s);
  // double t = 127000;
  // double d = 127000;
  // for (int i = 0; i < 5; i++) {
  //   d = d + .1 * d;
  //
  //   t += d;
  // }
  // print(t);
}

Future getN() async {
  Duration d = Duration(seconds: 2);
  Future.delayed(d);
  //print('ali');
  return 'ali';
}
