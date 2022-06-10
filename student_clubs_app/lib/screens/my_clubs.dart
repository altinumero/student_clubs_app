import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_clubs_app/screens/club_detail.dart';
import 'package:student_clubs_app/screens/profile.dart';

import '../home/main_club_page.dart';
import '../utils/colors.dart';
import 'login.dart';

class MyClubs extends StatefulWidget {
  const MyClubs({Key key}) : super(key: key);

  @override
  State<MyClubs> createState() => _MyClubsState();
}

class _MyClubsState extends State<MyClubs> {
  List MyClubs;
  var arr;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var myclubslist;
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
            title: Text("My Clubs"),
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
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: FutureBuilder(
                future: buildClubList(),
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
                                    child: Text("C"),
                                    backgroundColor: Appcolors.darkBlueColor),
                              ),
                            ),
                            title: Text(snapshot.data[index]),
                            /* onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(

                          builder: (context) =>ClubDetail(

                                  clubnamedata: snapshot.data[index],
                                  clubpresidentdata: snapshot.data[index]
                                  ,
                                  clubadvisordata: snapshot.data[index],
                                  clubvicepresidentdata: snapshot.data[index]
                                  ,
                                  clubsecretarydata: snapshot.data[index],
                                  clubaccountantdata: snapshot.data[index]
                                  ,
                                  clubmemberdata: snapshot.data[index],
                                  clubaltmember1data: snapshot.data[index]
                                  ,
                                  clubaltmember2data: snapshot.data[index]
                                  ,
                                  statusdata: snapshot.data[index],
                                  clubdescriptiondata: snapshot.data[index]
                                  ,
                                  clubimagedata: "https://firebasestorage.googleapis.com/v0/b/student-clubs-aaae0.appspot.com/o/clubImages%2Fsmallclubimage.jpg?alt=media&token=a67e552d-bf35-4d90-a92e-7652779d6f90"
                              )
                      ),

                      );
                    },*/
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
          ])),
    );
  }

  buildClubList() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    log("c" + uid);
    DocumentReference docRef =
        Firestore.instance.collection("users").document(uid);
    DocumentSnapshot doc = await docRef.get();
    MyClubs = doc.data["MyClubs"];

    print("mm" + MyClubs.toString());
    log("myclubs: " + MyClubs.toString());

    return MyClubs;
  }

  /*Future<List<DocumentSnapshot>> getDataa() async {
    FirebaseUser curruser = await _auth.currentUser();
     await Firestore.instance.collection('users').document(curruser.toString())
         .get().then((DocumentSnapshot ds) => {
            arr = ds.data["MyArray"]
     });
 log("arr" + arr.toString());
 return arr;
  }*/

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
    log("usertype: " + userType);
    return userType;
  }

  /*myMethod() async {

    var currentUserId= getCurrentUser().toString();
    /* DocumentSnapshot snapshot = await Firestore.instance.collection('users')
        .document(currentUserId).get();
        myclubslist  = snapshot.data['MyClubs'] ;
        */
    final value = await Firestore.instance.collection("users")
        .document(currentUserId)
        .get();
    myclubslist = value.data["friends"];
    log("array: " + myclubslist);
    return myclubslist;
  }*/
} //end
