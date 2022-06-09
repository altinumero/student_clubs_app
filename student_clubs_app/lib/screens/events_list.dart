import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_clubs_app/screens/club_detail.dart';
import 'package:student_clubs_app/screens/event_detail.dart';
import 'package:student_clubs_app/screens/profile.dart';
import 'package:student_clubs_app/utils/colors.dart';

import '../home/main_club_page.dart';
import 'login.dart';

class EventsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
      BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.purple])
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Appcolors.mainColor,
          centerTitle: true,
          title: Text("Events List"),
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
        body: Container(

          child: StreamBuilder(
            stream: Firestore.instance.collection('events').snapshots(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
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
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(6),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
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
                      title: Text(documents[index]['EventName']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventDetail(
                                eventownerdata:documents[index]["EventOwnerClub"],
                                  eventnamedata: documents[index]['EventName'],
                                  eventlocationdata: documents[index]
                                  ['EventLocation'],
                                  eventdescriptiondata: documents[index]
                                  ['EventDescription']

                              )
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

