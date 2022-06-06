import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_clubs_app/screens/club_detail.dart';
import 'package:student_clubs_app/screens/profile.dart';
import 'package:student_clubs_app/utils/colors.dart';

import '../home/main_club_page.dart';
import 'login.dart';

class ClubsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Appcolors.mainColor,
        centerTitle: true,
        title: Text("Clubs List"),
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
        stream: Firestore.instance.collection('clubs').snapshots(),
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
                          child: Ink.image(
                            image: NetworkImage(documents[index]['clubImage']),
                            fit: BoxFit.cover,
                          ),
                          backgroundColor: Colors.transparent),
                    ),
                  ),
                  title: Text(documents[index]['ClubName']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClubDetail(
                              clubnamedata: documents[index]['ClubName'],
                              clubpresidentdata: documents[index]
                                  ['ClubPresident'],
                              clubadvisordata: documents[index]['Advisor'],
                              clubvicepresidentdata: documents[index]
                                  ['VicePresident'],
                              clubsecretarydata: documents[index]['Secretary'],
                              clubaccountantdata: documents[index]
                                  ['Accountant'],
                              clubmemberdata: documents[index]['ClubMember'],
                              clubaltmember1data: documents[index]
                                  ['ClubAltMember'],
                              clubaltmember2data: documents[index]
                                  ['ClubAltMember2'],
                              statusdata: documents[index]['Status'],
                              clubdescriptiondata: documents[index]
                                  ['Description'],
                              clubimagedata: documents[index]['clubImage']
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
    );
  }
}
