import 'package:flutter/material.dart';
import 'demo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExpandableText Demo',
      theme: ThemeData(colorSchemeSeed: Colors.blueAccent, useMaterial3: false),
      home: const DemoPage(),
    );
  }
}
