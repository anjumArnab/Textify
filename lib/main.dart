import 'package:flutter/material.dart';
import '../views/homepage.dart';

void main() {
  runApp(const Textify());
}

class Textify extends StatelessWidget {
  const Textify({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Textify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Homepage()
    );
  }
}
