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
            if (streamSnapshot.hasError) {
              return Text('Something went wrong');
            }

            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: streamSnapshot.data.documents.length,
              itemBuilder: (context, index) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: streamSnapshot
                                .data.documents[index]['EventReports'].length,
                            itemBuilder: (context, index2) {
                              if((streamSnapshot
                                  .data.documents[index]['EventReports'])==null){
                               return  Text("no reports");
                              }
                              else{ return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Appcolors.transparent,
                                      border: Border.all(
                                          color: Appcolors.darkBlueColor)),
                                  child: ListTile(
                                    leading: Icon(Icons.file_copy_outlined),
                                    title: Text(
                                      "Report Of :" +
                                          streamSnapshot
                                              .data
                                              .documents[index]['EventReports']
                                                  [index2]["eventname"]
                                              .toString(),
                                    ),
                                    subtitle: Text(
                                      streamSnapshot
                                          .data
                                          .documents[index]['EventReports']
                                              [index2]["eventdes"]
                                          .toString(),
                                    ),
                                  ),
                                ),
                              );}
                            })
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
