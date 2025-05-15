import 'package:flutter/material.dart';
import 'package:mybible/my_bible.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyBible(),
      theme: ThemeData(fontFamily: 'Merriweather'),
    );
  }
}
