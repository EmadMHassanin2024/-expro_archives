import 'package:expro_archives/models/decision_model.dart';
import 'package:expro_archives/views/dash_board.dart';
import 'package:flutter/material.dart';
import 'package:expro_archives/views/DraftUploadScreen.dart';

void main() {
  runApp(const ExproArchives());
}

class ExproArchives extends StatelessWidget {
  const ExproArchives({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Poppins',

        scaffoldBackgroundColor: const Color(0xffdbdbdb),
        primaryColor: Color(0xFF3E3E55),

        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: Colors.blueGrey[800],
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            color: Colors.blueGrey[800],
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            color: Colors.blueGrey[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white, // لون النصوص داخل الـ AppBar
        ),
      ),

      home: DashboardScreen(),
    );
  }
}
