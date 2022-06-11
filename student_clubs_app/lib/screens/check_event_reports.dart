import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_clubs_app/screens/profile.dart';

import '../home/main_club_page.dart';
import '../utils/colors.dart';
import 'login.dart';

class CheckEventReports extends StatefulWidget {
  const CheckEventReports({Key key}) : super(key: key);

  @override
  State<CheckEventReports> createState() => _CheckEventReportsState();
}

class _CheckEventReportsState extends State<CheckEventReports> {
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
          title: Text("Check Event Reports"),
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
        body: StreamBuilder(
          stream: Firestore.instance.collection("clubs").snapshots(),
          builder: (context, streamSnapshot) {
            return ListView.builder(
              itemCount: streamSnapshot.data.documents.length,
              itemBuilder: (context, index) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          streamSnapshot.data.documents['EventReports'][index]
                              ['eventdes'],
                          style:
                              TextStyle(fontSize: 20, color: Colors.red[500]),
                        )
                      ]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
