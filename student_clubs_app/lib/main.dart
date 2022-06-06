import 'package:flutter/material.dart';
import 'package:student_clubs_app/home/main_club_page.dart';

void main() async{

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Clubs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainClubPage(),
    );
  }
}


