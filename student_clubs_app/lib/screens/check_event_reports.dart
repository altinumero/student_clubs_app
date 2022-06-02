import 'package:flutter/material.dart';

import '../utils/colors.dart';

class CheckEventReports extends StatefulWidget {
  const CheckEventReports({Key? key}) : super(key: key);

  @override
  State<CheckEventReports> createState() => _CheckEventReportsState();
}

class _CheckEventReportsState extends State<CheckEventReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.mainColor,
        centerTitle: true,
        title: Text("Check Event Reports"),
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
