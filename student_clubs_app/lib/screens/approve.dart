import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_clubs_app/screens/profile.dart';

import '../home/main_club_page.dart';
import '../utils/colors.dart';
import 'event_detail.dart';
import 'login.dart';

class Approve extends StatefulWidget {
  const Approve({Key key}) : super(key: key);

  @override
  State<Approve> createState() => _ApproveState();
}

class _ApproveState extends State<Approve> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
          title: Text("Approve Event"),
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
        body: ListView(physics: const BouncingScrollPhysics(), children: [
          FutureBuilder(
              future: getAdvisorUsersClubName(),
              builder: (context, snapshot) {
                return StreamBuilder(
                    stream: Firestore.instance
                        .collection('events')
                        .where("EventOwnerClub",
                            isEqualTo: snapshot.data.toString())
                        .snapshots(),
                    builder: (context, streamSnapshot) {
                      if (streamSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final documents = streamSnapshot.data.documents;
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: streamSnapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(6),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Appcolors.textColor
                                              .withOpacity(0.2),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3))
                                    ]),
                                child: ListTile(
                                  title: Text(documents[index]["EventName"]),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EventDetail(
                                              eventownerdata: documents[index]
                                                  ["EventOwnerClub"],
                                              eventnamedata: documents[index]
                                                  ['EventName'],
                                              eventlocationdata:
                                                  documents[index]
                                                      ['EventLocation'],
                                              eventdescriptiondata:
                                                  documents[index]
                                                      ['EventDescription'])),
                                    );
                                  },
                                  trailing: ElevatedButton(
                                    child: Text("Tıkla"),
                                    style: ElevatedButton.styleFrom(
                                        primary: Appcolors.darkBlueColor),
                                    onPressed: () {
                                      Fluttertoast.showToast(
                                        msg: "Leaved!",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          });
                    });
              }),
        ]),
      ),
    );
  }

  Future<String> getCurrentUser() async {
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

  Future<String> getAdvisorUsersClubName() async {
    var currentUser = await getCurrentUser(); //id

    var collection = await Firestore.instance.collection('clubs');
    var querySnapshot = await collection
        .where('Advisor', isEqualTo: currentUser)
        .getDocuments();

    for (var snapshot in querySnapshot.documents) {
      clubnamefortext = snapshot.data["ClubName"];
      log(clubnamefortext);
    }
    return clubnamefortext;
  }
}
