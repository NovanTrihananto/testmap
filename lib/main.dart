import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Peta Bahaya',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),  // Mulai dari homepage
    );
  }
}
