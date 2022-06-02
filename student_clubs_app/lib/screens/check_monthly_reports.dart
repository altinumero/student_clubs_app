import 'package:flutter/material.dart';

import '../utils/colors.dart';

class CheckMonthlyReports extends StatefulWidget {
  const CheckMonthlyReports({Key? key}) : super(key: key);

  @override
  State<CheckMonthlyReports> createState() => _CheckMonthlyReportsState();
}

class _CheckMonthlyReportsState extends State<CheckMonthlyReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.mainColor,
        centerTitle: true,
        title: Text("Check Monthly Reports"),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed:
                () {}, //Burada eğer kullanıcı giriş yapmışsa profil sayfasına yoksa logine gidecek
          ),
        ],
      ),
    );
  }
}
