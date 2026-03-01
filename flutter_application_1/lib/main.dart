import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.teal,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 100,
            color: Colors.white,
            child: Text("Container 1"),
          ),
          SizedBox(width: 30),
          Container(
            height: 100,
            color: Colors.red,
            child: Text("Container 2"),
          ),
          Container(
            height: 100,
            color: Colors.green,
            child: Text("Container 3"),
          )
        ],
      )
    ),
  );
  }
}