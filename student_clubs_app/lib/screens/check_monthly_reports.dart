import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_clubs_app/screens/profile.dart';

import '../home/main_club_page.dart';
import '../utils/colors.dart';
import 'login.dart';

class CheckMonthlyReports extends StatefulWidget {
  const CheckMonthlyReports({Key key}) : super(key: key);

  @override
  State<CheckMonthlyReports> createState() => _CheckMonthlyReportsState();
}

class _CheckMonthlyReportsState extends State<CheckMonthlyReports> {
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
          title: Text("Check Monthly Reports"),
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
                                .data.documents[index]['MonthlyReports'].length,
                            itemBuilder: (context, index2) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Appcolors.transparent,
                                      border: Border.all(
                                          color: Appcolors.darkBlueColor)),
                                  child: ListTile(
                                    leading: Icon(Icons.date_range),
                                    title: Text(
                                      "Month :" +
                                          streamSnapshot
                                              .data
                                              .documents[index]
                                                  ['MonthlyReports'][index2]
                                                  ["month"]
                                              .toString(),
                                    ),
                                    subtitle: Text(
                                      streamSnapshot
                                          .data
                                          .documents[index]['MonthlyReports']
                                              [index2]["description"]
                                          .toString(),
                                    ),
                                  ),
                                ),
                              );
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
