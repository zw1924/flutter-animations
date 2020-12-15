import 'package:flutter/material.dart';
import 'package:ninja_trips/screens/home.dart';
import 'package:ninja_trips/screens/star_river.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ninja Trips',
      home: LayoutBuilder(builder: (BuildContext context, BoxConstraints con) {
          return  ZWStarRiver(width: con.maxWidth, height: con.maxHeight,);
      },),
    );
  }
}
