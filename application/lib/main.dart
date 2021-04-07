import 'package:flutter/material.dart';
import 'package:sensetive/pages/home.dart';
import 'package:sensetive/pages/measure.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Starter Template',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Measure(),
    );
  }
}
