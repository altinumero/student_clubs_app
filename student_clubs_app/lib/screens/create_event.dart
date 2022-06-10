import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_clubs_app/screens/events_list.dart';
import 'package:student_clubs_app/screens/profile.dart';

import '../home/main_club_page.dart';
import '../utils/colors.dart';
import 'login.dart';

class CreateEvent extends StatefulWidget {
  CreateEvent({Key key}) : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  Map<String, String> mydata;
  var clubnameforevent;
  TextEditingController eventNameController = TextEditingController();

  TextEditingController eventPlaceController = TextEditingController();

  TextEditingController eventOwnerController = TextEditingController();

  TextEditingController eventDescriptionController = TextEditingController();

  String eventName;

  String eventPlace;

  String eventOwner;

  String eventDescription;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
          title: Text("Create Event"),
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
          padding: EdgeInsets.all(30.0),
          child: ListView(
            children: [
              buildEventNameField(),
              sizedBox(16),
              buildEventPlaceField(),
              sizedBox(16),
              buildEventDescriptionField(),
              sizedBox(16),
              buildElevatedButton("Create", Appcolors.joinColor, () {
                // çalışacak method butona basınca
              })
            ],
          ),
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
      onPressed: () {
        uploadFileandSendData();
      }, //logout için veritabanı fonksiyonu
      child: Text(text),
    );
  }

  void uploadFileandSendData() async {
    var currentUser = await getCurrentUser();
    var collection = await Firestore.instance.collection('clubs');
    var querySnapshot = await collection
        .where('ClubPresident'.toString(), isEqualTo: currentUser.toString())
        .getDocuments();

    for (var snapshot in querySnapshot.documents) {
      clubnameforevent = snapshot.data["ClubName"];
    }
    log('dattaaa: $clubnameforevent');
    //clubnameforevent = mydata["ClubName"];
    /* Firestore.instance.collection("clubs").where("ClubPresident", isEqualTo: currentUser).
    getDocuments()
        .then((querysnapshot) {
      querysnapshot.documents.forEach((document) {
        print("doc club name: " + document["ClubName"]);
        clubnameforevent =document["ClubName"];
      });

    });*/
    print(clubnameforevent.toString());
    var forID = DateTime.now().toString();
    final map = <String, String>{
      "EventName": eventNameController.text,
      "EventDescription": eventDescriptionController.text,
      "EventLocation": eventPlaceController.text,
      "EventOwnerClub": clubnameforevent.toString(),
    };
    Firestore.instance
        .collection("events")
        .document(eventNameController.text)
        .setData(map);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EventsList()));
    Fluttertoast.showToast(
      msg: "Event Created!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
    // bu urli yarattığımız kulubün imageUrl fieldina yapıştırmalıyız submit yaparken
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user.uid;
  }

  /*
   String getClubNameForEvent(){

     var currentUser = getCurrentUser();
      Firestore.instance.collection("clubs").where("ClubPresident", isEqualTo: currentUser).getDocuments()
         .then((querysnapshot) {
       querysnapshot.documents.forEach((document) {
         print("doc club name: " + document["ClubName"]);
         clubnameforevent =document.data["ClubName"];
       });

     });
print("clubnameforevemt" + clubnameforevent);
    return clubnameforevent;
   }

*/

} //end
