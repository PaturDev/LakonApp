
import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';

class LakonApp extends StatelessWidget {
  const LakonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LAKONAPP',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF35563C),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
