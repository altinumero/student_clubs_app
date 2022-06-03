import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_clubs_app/screens/profile.dart';

import '../utils/colors.dart';
import 'login.dart';

class ApplyForClub extends StatelessWidget {
  const ApplyForClub({Key key}) : super(key: key);

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
                () {
                  FirebaseAuth.instance.currentUser().then((firebaseUser) {
                    if (firebaseUser == null) {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login()));
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute (builder: (context) => Profile()
                          )
                      );
                    }
                  });
                }, //Burada eğer kullanıcı giriş yapmışsa profil sayfasına yoksa logine gidecek
          ),
        ],
      ),
    );
  }
}
