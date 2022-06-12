import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_clubs_app/screens/profile.dart';

import '../home/main_club_page.dart';
import '../utils/colors.dart';
import 'event_detail.dart';
import 'login.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({Key key}) : super(key: key);

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  List MyEvents;
  var arr;
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
          title: Text("My Events"),
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
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: FutureBuilder(
                future: buildEventList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(6),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                    color: Appcolors.textColor.withOpacity(0.2),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3))
                              ]),
                          child: ListTile(
                            leading: ClipOval(
                              child: Material(
                                child: CircleAvatar(
                                    foregroundColor: Appcolors.textColor,
                                    child: Text("E"),
                                    backgroundColor: Appcolors.darkBlueColor),
                              ),
                            ),
                            title: Text(snapshot.data[index]),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Text("lodaing data");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildEventList() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    DocumentReference docRef =
        Firestore.instance.collection("users").document(uid);
    DocumentSnapshot doc = await docRef.get();
    MyEvents = doc.data["MyEvents"]; // events array list
    return MyEvents;
  }
}
