import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:student_clubs_app/screens/profile.dart';

import '../home/main_club_page.dart';
import '../utils/colors.dart';
import 'login.dart';

class CreateEventReport extends StatefulWidget {
  @override
  State<CreateEventReport> createState() => _CreateEventReportState();
}

class _CreateEventReportState extends State<CreateEventReport> {
  TextEditingController eventReportDescriptionController =
      TextEditingController();
  var selectedEvent;
  String selectEvent = "Select Event";
  var clubnamefortext;
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
          child: FutureBuilder(
              future: getPresidentUsersClubName(),
              builder: (context, snapshot) {
                return StreamBuilder(
                    stream: Firestore.instance
                        .collection('events')
                        .where("EventOwnerClub", isEqualTo: snapshot.data)
                        .where("approvedBySKS", isEqualTo: "true")
                        .snapshots(),
                    builder: (context, streamSnapshot) {
                      if (streamSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final documents = streamSnapshot.data.documents;
                      return ListView(
                        children: [
                          sizedBox(8),
                          buildEventOwnerField(documents),
                          sizedBox(8),
                          buildEventReportDescriptionField(),
                          sizedBox(8),
                          buildElevatedButton(
                              "Create Event Report", Appcolors.joinColor, () {
                            Firestore.instance
                                .collection('clubs')
                                .document(snapshot.data)
                                .updateData({
                              "EventReports": FieldValue.arrayUnion([
                                {
                                  'eventname':
                                      selectedEvent["EventName"].toString(),
                                  'eventdes':
                                      eventReportDescriptionController.text
                                }
                              ])
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainClubPage()));
                            Fluttertoast.showToast(
                              msg: "Created!",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                            );
                          })
                        ],
                      );
                    });
              }),
        ),
      ),
    );
  }

  Future<String> getCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    return user.uid;
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

    var collection = await Firestore.instance.collection('clubs');
    var querySnapshot = await collection
        .where('ClubPresident'.toString(), isEqualTo: currentUser.toString())
        .getDocuments();

    for (var snapshot in querySnapshot.documents) {
      clubnamefortext = snapshot.data["ClubName"];
    }

    return clubnamefortext;
  }

  sizedBox(double i) {
    return SizedBox(height: i);
  }

  buildEventReportDescriptionField() {
    return TextFormField(
      maxLines: null,
      keyboardType: TextInputType.multiline,
      controller: eventReportDescriptionController,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Appcolors.darkBlueColor)),
          hintText: "Event Report Description",
          prefixIcon: Icon(Icons.drive_file_rename_outline)),
      validator: (value) {},
    );
  }

  buildEventOwnerField(advisorDocuments) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Appcolors.transparent,
          border: Border.all(color: Appcolors.darkBlueColor)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SearchableDropdown.single(
          items: advisorDocuments
              .map<DropdownMenuItem<DocumentSnapshot>>(buildMenuItem)
              .toList(),
          value: selectedEvent,
          hint: selectEvent,
          searchHint: "Select one",
          onChanged: (value) {
            setState(() {
              selectedEvent = value;
              selectEvent = selectedEvent["EventName"].toString();
            });
          },
          isExpanded: true,
        ),
      ),
    );
  }

  DropdownMenuItem<DocumentSnapshot> buildMenuItem(DocumentSnapshot item) {
    return DropdownMenuItem(
      value: item,
      child: Text(
        item["EventName"],
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
} //end
