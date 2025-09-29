import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/paper_list_screen.dart';
import 'screens/question_detail_screen.dart';

void main() => runApp(ExamApp());

class ExamApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/papers': (context) => PaperListScreen(),
        '/questions': (context) => QuestionDetailScreen(),
      },
    );
  }
}
