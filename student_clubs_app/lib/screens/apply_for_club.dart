import 'package:flutter/material.dart';

import '../utils/colors.dart';

class ApplyForClub extends StatelessWidget {
  const ApplyForClub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.mainColor,
        centerTitle: true,
        title: Text("Apply For Club"),
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
