import 'package:flutter/material.dart';
import 'package:interview/screens/home.dart';

void main() {
  runApp(MyApp());
}
String title="The Interview";
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: title),
    );
  }
}


