import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_clubs_app/screens/profile.dart';

import '../utils/colors.dart';
import 'login.dart';

class CreateEvent extends StatelessWidget {
  CreateEvent({Key key}) : super(key: key);
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventPlaceController = TextEditingController();
  TextEditingController eventOwnerController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  String eventName;
  String eventPlace;
  String eventOwner;
  String eventDescription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Appcolors.mainColor,
        centerTitle: true,
        title: Text("Create Event"),
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
        padding: EdgeInsets.all(30.0),
        child: ListView(
          children: [
            buildEventNameField(),
            sizedBox(16),
            buildEventOwnerField(),
            sizedBox(16),
            buildEventPlaceField(),
            sizedBox(16),
            buildEventDescriptionField(),
            sizedBox(16),
            buildElevatedButton("Create", Appcolors.joinColor, () {})
          ],
        ),
      ),
    );
  }

  sizedBox(double i) {
    return SizedBox(height: i);
  }

  buildEventNameField() {
    return TextFormField(
      controller: eventNameController,
      decoration: InputDecoration(
          hintText: "Event Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.drive_file_rename_outline)),
      validator: (value) {},
    );
  }

  buildEventPlaceField() {
    return TextFormField(
      controller: eventPlaceController,
      decoration: InputDecoration(
          hintText: "Event Place",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.place)),
      validator: (value) {},
    );
  }

  buildEventOwnerField() {
    return TextFormField(
      controller: eventOwnerController,
      decoration: InputDecoration(
          hintText: "Event Owner",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.perm_contact_cal_rounded)),
      validator: (value) {},
    );
  }

  buildEventDescriptionField() {
    return TextFormField(
      controller: eventDescriptionController,
      decoration: InputDecoration(
          hintText: "Event Description",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.description)),
      validator: (value) {},
    );
  }

  buildElevatedButton(String text, Color color, VoidCallback onClicked) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        onPrimary: Appcolors.textColor,
        primary: color,
        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 12),
      ),
      onPressed: onClicked, //logout için veritabanı fonksiyonu
      child: Text(text),
    );
  }
}
