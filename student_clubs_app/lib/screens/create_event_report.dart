import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_clubs_app/screens/profile.dart';

import '../utils/colors.dart';
import 'login.dart';

class CreateEventReport extends StatelessWidget {
  const CreateEventReport({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.mainColor,
        centerTitle: true,
        title: Text("Create Event Report"),
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
      body: Padding(
        padding: EdgeInsets.all(30),
        child: ListView(
          children: [
            //Template indirme kısmı olacak
            //upload etme kısmı olacak
            //upload yapan kişi hangi kulübün başkanıysa report o kulübe ait olacak
            //o kulübün advisorı bu sayede raporları görecek
          ],
        ),
      ),
    );
  }
}
