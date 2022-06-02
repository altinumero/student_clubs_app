import 'package:flutter/material.dart';

import '../utils/colors.dart';

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
                () {}, //Burada eğer kullanıcı giriş yapmışsa profil sayfasına yoksa logine gidecek
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
