import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_clubs_app/screens/my_events.dart';
import 'package:student_clubs_app/screens/profile.dart';

import '../home/main_club_page.dart';
import '../utils/colors.dart';
import 'login.dart';

class EventDetail extends StatefulWidget {
  EventDetail(
      {key,
        this.eventnamedata,
        this.eventownerdata,
        this.eventlocationdata,
        this.eventimagedata,
        this.eventdescriptiondata,

        })
      : super(key: key);
  final eventnamedata;
  final eventownerdata;
  final eventlocationdata;
  final eventimagedata;
  final eventdescriptiondata;


  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var usertypedata;
  List MyEvents;

  @override
  Widget build(BuildContext context) {
    final eventnamedata = widget.eventnamedata;
    final eventownerdata = widget.eventownerdata;
    final eventlocationdata = widget.eventlocationdata;
    final eventimagedatadata = widget.eventimagedata;
    final eventdescriptiondatadata = widget.eventdescriptiondata;
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
          title: Text("Event Detail"),
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
        body: FutureBuilder(
            future: getCurrentUserType(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData){
            return ListView(
              children: [
                sizedBox(16),
                buildDetails(eventnamedata,eventownerdata,eventlocationdata,eventimagedatadata,eventdescriptiondatadata),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    "${eventdescriptiondatadata}",
                    style: TextStyle(color: Appcolors.textColor),
                  ),
                ),
                sizedBox(16),

                FutureBuilder(
                    future: buildMyevList(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData){
                        log("eventlistsnapshot " + snapshot.data.toString());
                      log("eventboolean:" + snapshot.data.contains(eventnamedata).toString());
                    return Visibility(

                        visible: ( snapshot.data.contains(eventnamedata)==false),
                        child: Container(

                          child: buildElevatedButton(

                              "Join Event", Appcolors.joinColor, () async{
                            final FirebaseUser user = await _auth.currentUser();
                            final uid = user.uid;

                            log("c" + uid);
                            DocumentReference docRef =  Firestore.instance.collection("users").document(uid);
                            DocumentSnapshot doc = await docRef.get();
                            MyEvents = doc.data["MyEvents"];
                            if(MyEvents.contains(eventnamedata)==false){
                              docRef.updateData(
                                  {
                                    'MyEvents': FieldValue.arrayUnion(
                                        [eventnamedata])
                                  }
                              );
                            }

                          }),
                        ));}else { return Text("loading");}
                  }
                ),
                FutureBuilder(
                    future: buildMyevList(),
                    builder: (context, snapshot) {
              if (snapshot.hasData){
                    return Visibility(
                        visible: (snapshot.data.contains(eventnamedata)==true),
                        child: Container(
                          child: buildElevatedButton(
                              "Leave Event", Appcolors.warningColor, () async {
                            final FirebaseUser user = await _auth.currentUser();
                            final uid = user.uid;
                            DocumentReference docRef =  Firestore.instance.collection("users").document(uid);
                            DocumentSnapshot doc = await docRef.get();
                            docRef.updateData(
                                {
                                  'MyEvents': FieldValue.arrayRemove(
                                      [eventnamedata])
                                }
                            );
                          }),
                        ));}else { return Text("loading");}
                  }
                ),
              ],
            );} else { return Text("loading");}
          }
        ),
        bottomNavigationBar: FutureBuilder(
            future: getCurrentUserType(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Visibility(
                visible: (snapshot.data == "sks"),
                child: Container(
                  child: buildElevatedButton(
                      "Remove Event", Appcolors.warningColor, () {}),
                ),
              );
            }),
      ),
    );
  }

  sizedBox(double i) {
    return SizedBox(height: i);
  }

  buildDetails(eventnamedata,eventownerdata,eventlocationdata,eventimagedata,eventdescriptiondata) {
    return Column(
      children: [
        Text(" ${eventnamedata}", //veri tabanından isim
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Appcolors.textColor)),
        sizedBox(4),
        Divider(
          color: Appcolors.textColor,
        ),
        sizedBox(4),
        Text(
          "${eventownerdata} Club's Event", //veri tabanından mail
          style: TextStyle(color: Appcolors.textColor),
        ),
        sizedBox(4),
        Divider(
          color: Appcolors.textColor,
        ),
        sizedBox(4),
        Text(
          "${eventlocationdata}", //veri tabanından
          style: TextStyle(color: Appcolors.textColor),
        ),
        sizedBox(4),
        Divider(
          color: Appcolors.textColor,
        ),
        sizedBox(4)
      ],
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
      onPressed: onClicked, //logout için veritabanı fonksiyonu
      child: Text(text),
    );
  }

  Future<String> getCurrentUserType() async {
    final uid = await getCurrentUser();

    DocumentSnapshot snapshot =
    await Firestore.instance.collection('users').document(uid).get();
    var userType = snapshot.data[
    'userType']; //you can get any field value you want by writing the exact fieldName in the data[fieldName]
    print(userType);
    return userType;
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user.uid;
  }

  Future<List> buildMyevList() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    log("c" + uid);
    DocumentReference docRef =  Firestore.instance.collection("users").document(uid);
    DocumentSnapshot doc = await docRef.get();
    MyEvents = doc.data["MyEvents"];
    print("mm" + MyEvents.toString());
    log("myevents: " +MyEvents.toString());

    return MyEvents;
  }
}
