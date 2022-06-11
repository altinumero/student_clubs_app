import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_clubs_app/screens/profile.dart';

import '../home/main_club_page.dart';
import '../utils/colors.dart';
import 'login.dart';

class CreateEventReport extends StatefulWidget {
  @override
  State<CreateEventReport> createState() => _CreateEventReportState();
}

class _CreateEventReportState extends State<CreateEventReport> {
  var usertypedata;

  List eventReportsListOfTheClub;

  var clubnameforevent;

  var urltobeadded;

  var clubnamefortext;

  var urldata;

  var clubnamedata;

  File _pickedImage;

  DocumentReference docRef;
  void _pickImage() async {
    final pickedImageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple, Colors.blue])),
      child: Scaffold(
        backgroundColor: Appcolors.transparent,
        appBar: AppBar(
          backgroundColor: Appcolors.mainColor,
          centerTitle: true,
          title: Text("Create Event Report"),
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainClubPage()));
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                FirebaseAuth.instance.currentUser().then((firebaseUser) {
                  if (firebaseUser == null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile()));
                  }
                });
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(30),
          child: ListView(
            children: [
              FutureBuilder(
                  future: Future.wait([getClubNameOfPresident()]),
                  builder: (context, snapshot) {
                    clubnamedata = snapshot.data[0];

                    debugPrint('clubbb: ' + clubnamedata.toString());

                    return buildElevatedButton(
                        "Add Report", Appcolors.joinColor, () async {
                      /*Firestore.instance
                          .collection("clubs")
                          .document(clubnamedata)
                          .updateData();*/
                    });
                  })
              //Template indirme kısmı olacak
              //upload etme kısmı olacak
              //upload yapan kişi hangi kulübün başkanıysa report o kulübe ait olacak
              //o kulübün advisorı bu sayede raporları görecek
            ],
          ),
        ),
      ),
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
      onPressed: onClicked,
      child: Text(text),
    );
  }

  Future<String> getCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    return user.uid;
  }

  Future<String> getClubNameOfPresident() async {
    var currentUser = await getCurrentUser();
    var collection = await Firestore.instance.collection('clubs');
    var querySnapshot = await collection
        .where('ClubPresident'.toString(), isEqualTo: currentUser.toString())
        .getDocuments();

    for (var snapshot in querySnapshot.documents) {
      clubnameforevent = snapshot.data["ClubName"];
    }
    //log('dattaaa: $clubnameforevent');

    return clubnameforevent;
  }

  buildEventReportList() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
  }

  Future<String> getCurrentUserType() async {
    final uid = await getCurrentUser();

    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var userType = snapshot.data[
        'userType']; //you can get any field value you want by writing the exact fieldName in the data[fieldName]

    return userType;
  }

  Future<String> getPresidentUsersClubName() async {
    var currentUser = await getCurrentUser(); //id
    var currentUserType = await getCurrentUserType();

    var collection = await Firestore.instance.collection('clubs');
    var querySnapshot = await collection
        .where('ClubPresident'.toString(), isEqualTo: currentUser.toString())
        .getDocuments();

    for (var snapshot in querySnapshot.documents) {
      clubnamefortext = snapshot.data["ClubName"];
    }

    return clubnamefortext;
  }
} //end
