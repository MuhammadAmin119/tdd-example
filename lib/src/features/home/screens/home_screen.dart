import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home page', style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18)),
      ),
    );
  }
}
