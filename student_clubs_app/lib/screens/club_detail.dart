import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_clubs_app/screens/clubs_list.dart';
import 'package:student_clubs_app/screens/event_detail.dart';
import 'package:student_clubs_app/screens/profile.dart';

import '../home/main_club_page.dart';
import '../utils/colors.dart';
import 'login.dart';

class ClubDetail extends StatefulWidget {
  ClubDetail(
      {key,
      this.clubnamedata,
      this.clubadvisordata,
      this.clubpresidentdata,
      this.clubvicepresidentdata,
      this.clubsecretarydata,
      this.clubaccountantdata,
      this.clubmemberdata,
      this.clubaltmember1data,
      this.clubaltmember2data,
      this.statusdata,
      this.clubdescriptiondata,
      this.clubimagedata})
      : super(key: key);
  final clubnamedata;
  final clubadvisordata;
  final clubpresidentdata;
  final clubvicepresidentdata;
  final clubsecretarydata;
  final clubaccountantdata;
  final clubmemberdata;
  final clubaltmember1data;
  final clubaltmember2data;
  final statusdata;
  final clubdescriptiondata;
  final clubimagedata;

  @override
  State<ClubDetail> createState() => _ClubDetailState();
}

class _ClubDetailState extends State<ClubDetail> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var usertypedata;
  @override
  void initState() {
    super.initState();
  }

  var clubpresidentrealname;
  var clubadvisorrealname;
  var clubvicepresidentrealname;
  var clubaccountantrealname;
  var clubsecretaryrealname;
  var clubmemberrealname;
  var clubalternatememberrealname;
  var clubalternatemember2realname;

  List MyClubs;

  Widget build(BuildContext context) {
    final clubnamedata = widget.clubnamedata;
    final clubpresidentdata = widget.clubpresidentdata;
    final clubadvisordata = widget.clubadvisordata;
    final clubvicepresidentdata = widget.clubvicepresidentdata;
    final clubsecretarydata = widget.clubsecretarydata;
    final clubaccountantdata = widget.clubaccountantdata;
    final clubmemberdata = widget.clubmemberdata;
    final clubaltmember1data = widget.clubaltmember1data;
    final clubaltmember2data = widget.clubaltmember2data;
    final statusdata = widget.statusdata;
    final clubdescriptiondata = widget.clubdescriptiondata;
    final clubimagedata = widget.clubimagedata;

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
          title: Text("Club Page "),
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
            sizedBox(24),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(300),
                  color: Appcolors.darkBlueColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(" ${clubnamedata}", //veri tabanından isim
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Appcolors.textColor)),
                ),
              ),
            ),
            sizedBox(24),
            Row(
              children: [
                buildClubImage(clubimagedata),
                SizedBox(width: 10),
                Container(
                  width: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Appcolors.darkBlueColor,
                      border: Border.all(color: Appcolors.darkBlueColor)),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        FutureBuilder(
                            future: clubPresidentRealName(clubpresidentdata),
                            //initialData: null, // You can set a default value here.
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text("President : " + snapshot.data,
                                    style:
                                        TextStyle(color: Appcolors.textColor));
                              }
                              return Text("");
                            }),
                        FutureBuilder(
                            future: clubAdvisorRealName(clubadvisordata),
                            //initialData: null, // You can set a default value here.
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text("Advisor:${snapshot.data} ",
                                    style:
                                        TextStyle(color: Appcolors.textColor));
                              }
                              return Text("");
                            }),
                        FutureBuilder(
                            future: clubVicePresidentRealName(
                                clubvicepresidentdata),
                            //initialData: null, // You can set a default value here.
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text("Vice President:${snapshot.data} ",
                                    style:
                                        TextStyle(color: Appcolors.textColor));
                              }
                              return Text("");
                            }),
                        FutureBuilder(
                            future: clubAccountantRealName(clubaccountantdata),
                            //initialData: null, // You can set a default value here.
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text("Accountant:${snapshot.data} ",
                                    style:
                                        TextStyle(color: Appcolors.textColor));
                              }
                              return Text("");
                            }),
                        FutureBuilder(
                            future: clubSecretaryRealName(clubsecretarydata),
                            //initialData: null, // You can set a default value here.
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text("Secretary:${snapshot.data} ",
                                    style:
                                        TextStyle(color: Appcolors.textColor));
                              }
                              return Text("");
                            }),
                        FutureBuilder(
                            future: clubMemberRealName(clubmemberdata),
                            //initialData: null, // You can set a default value here.
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text("Member:${snapshot.data} ",
                                    style:
                                        TextStyle(color: Appcolors.textColor));
                              }
                              return Text("");
                            }),
                        FutureBuilder(
                            future:
                                clubAlternateMemberRealName(clubaltmember1data),
                            //initialData: null, // You can set a default value here.
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                    "Alternate Member:${snapshot.data} ",
                                    style:
                                        TextStyle(color: Appcolors.textColor));
                              }
                              return Text("");
                            }),
                        FutureBuilder(
                            future: clubAlternateMember2RealName(
                                clubaltmember2data),
                            //initialData: null, // You can set a default value here.
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                    "Alternate Member 2:${snapshot.data} ",
                                    style:
                                        TextStyle(color: Appcolors.textColor));
                              }
                              return Text("");
                            }),
                        Text("Status :${statusdata} ",
                            style: TextStyle(color: Appcolors.textColor)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            sizedBox(16),
            Container(
              decoration: BoxDecoration(
                  color: Appcolors.darkBlueColor,
                  border: Border.all(color: Appcolors.darkBlueColor)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Club Description : ${clubdescriptiondata} ",
                  style: TextStyle(color: Appcolors.textColor),
                ),
              ),
            ),
            sizedBox(16),
            FutureBuilder(
                future: Future.wait([buildMyClubList(), getCurrentUserType()]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var arraydata = snapshot.data[0];
                    var userdata = snapshot.data[1];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible:
                              ((arraydata.contains(clubnamedata) == false &&
                                      statusdata == "Active" &&
                                      userdata == "student") ||
                                  (arraydata.contains(clubnamedata) == false &&
                                      statusdata == "Active" &&
                                      userdata == "president")),
                          child: Container(
                            child: buildElevatedButton(
                                "Join Club", Appcolors.joinColor, () async {
                              final FirebaseUser user =
                                  await _auth.currentUser();
                              final uid = user.uid;

                              DocumentReference docRef = Firestore.instance
                                  .collection("users")
                                  .document(uid);
                              DocumentSnapshot doc = await docRef.get();
                              MyClubs = doc.data["MyClubs"];
                              if (MyClubs.contains(clubnamedata) == false) {
                                docRef.updateData({
                                  'MyClubs':
                                      FieldValue.arrayUnion([clubnamedata])
                                });
                              }
                              setState(() {});
                              Fluttertoast.showToast(
                                msg: "Joined!",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                              );
                            }),
                          ),
                        ),
                        Visibility(
                            visible: ((arraydata.contains(clubnamedata) ==
                                        true &&
                                    statusdata == "Active" &&
                                    userdata == "student") ||
                                (snapshot.data.contains(clubnamedata) == true &&
                                    statusdata == "Active" &&
                                    userdata == "president")),
                            child: Container(
                              child: buildElevatedButton(
                                  "Leave Club", Appcolors.warningColor,
                                  () async {
                                final FirebaseUser user =
                                    await _auth.currentUser();
                                final uid = user.uid;
                                DocumentReference docRef = Firestore.instance
                                    .collection("users")
                                    .document(uid);
                                DocumentSnapshot doc = await docRef.get();
                                docRef.updateData({
                                  'MyClubs':
                                      FieldValue.arrayRemove([clubnamedata])
                                });
                                setState(() {});
                                Fluttertoast.showToast(
                                  msg: "Leaved!",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                );
                              }),
                            )),
                      ],
                    );
                  } else {
                    return Text(
                        ""); // if the user is not logged in or not the required type
                  }
                }),
            sizedBox(16),
            buildName(clubnamedata),
            StreamBuilder(
              stream: Firestore.instance
                  .collection('events')
                  .where('EventOwnerClub'.toString(), isEqualTo: clubnamedata)
                  .snapshots(),
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
                                    eventownerdata: documents[index]
                                        ["EventOwnerClub"],
                                    eventnamedata: documents[index]
                                        ['EventName'],
                                    eventlocationdata: documents[index]
                                        ['EventLocation'],
                                    eventdescriptiondata: documents[index]
                                        ['EventDescription'])),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: FutureBuilder(
            future: getCurrentUserType(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Visibility(
                visible: (snapshot.data == "sks"),
                child: Container(
                  child: buildElevatedButton(
                      "Remove Club", Appcolors.warningColor, () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Remove Club?"),
                              actions: [
                                TextButton(
                                    child: Text("Remove"),
                                    onPressed: () {
                                      Firestore.instance
                                          .collection("clubs")
                                          .document(clubnamedata)
                                          .delete();
                                      Firestore.instance
                                          .collection("events")
                                          .where('EventOwnerClub'.toString(),
                                              isEqualTo: clubnamedata)
                                          .getDocuments()
                                          .then((value) {
                                        value.documents.forEach((element) {
                                          Firestore.instance
                                              .collection("events")
                                              .document(element.documentID)
                                              .delete()
                                              .then((value) {});
                                        });
                                      });
                                      var updatedmap = <String, String>{
                                        "userType": "student"
                                      };
                                      Firestore.instance
                                          .collection("users")
                                          .document(clubpresidentdata)
                                          .updateData(updatedmap);

                                      var updatedmapadvisor = <String, String>{
                                        "isAdvising": "false"
                                      };
                                      Firestore.instance
                                          .collection("users")
                                          .document(clubadvisordata)
                                          .updateData(updatedmapadvisor);

                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ClubsList()));
                                    }),
                              ],
                            ));
                  }),
                ),
              );
            }),
      ),
    );
  }

  sizedBox(double i) {
    return SizedBox(height: i);
  }

  buildName(clubnamedata) {
    return Column(
      children: [
        Text(
          "${clubnamedata} Club's Events",
          style: TextStyle(color: Appcolors.darkBlueColor, fontSize: 30),
        )
      ],
    );
  }

  buildEventList(clubnamedata) async {
    var collection = await Firestore.instance.collection('events');
    var querySnapshot = await collection
        .where('EventOwnerClub'.toString(), isEqualTo: clubnamedata)
        .getDocuments();
    //final int docNumForItemCount = querySnapshot.documents.length;
    var snapshotstuff = querySnapshot.documents;
    return snapshotstuff;
    for (var snapshot in querySnapshot.documents) {
      //clubnameforevent = snapshot.data["ClubName"];

    }
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

  buildClubImage(clubimagedata) {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: NetworkImage(clubimagedata //veri tabanından resim
              ),
          fit: BoxFit.cover,
          width: 128,
          height: 128,
        ),
      ),
    );
  }

  Future<String> getCurrentUserType() async {
    final uid = await getCurrentUser();

    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var userType = snapshot.data[
        'userType']; //you can get any field value you want by writing the exact fieldName in the data[fieldName]
    return userType;
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user.uid;
  }

  clubPresidentRealName(clubpresidentdata) async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('users')
        .document(clubpresidentdata)
        .get();
    clubpresidentrealname = snapshot.data['username'];
    return clubpresidentrealname;
  }

  Future<List> buildMyClubList() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    DocumentReference docRef =
        Firestore.instance.collection("users").document(uid);
    DocumentSnapshot doc = await docRef.get();
    MyClubs = doc.data["MyClubs"];

    return MyClubs;
  }

  clubAdvisorRealName(clubadvisordata) async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('users')
        .document(clubadvisordata)
        .get();
    clubadvisorrealname = snapshot.data['username'];
    return clubadvisorrealname;
  }

  clubVicePresidentRealName(clubvisepresidentdata) async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('users')
        .document(clubvisepresidentdata)
        .get();
    clubvicepresidentrealname = snapshot.data['username'];
    return clubvicepresidentrealname;
  }

  clubAccountantRealName(clubaccountantdata) async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('users')
        .document(clubaccountantdata)
        .get();
    clubaccountantrealname = snapshot.data['username'];
    return clubaccountantrealname;
  }

  clubSecretaryRealName(clubsecretarydata) async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('users')
        .document(clubsecretarydata)
        .get();
    clubsecretaryrealname = snapshot.data['username'];
    return clubsecretaryrealname;
  }

  clubMemberRealName(clubmemberdata) async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('users')
        .document(clubmemberdata)
        .get();
    clubmemberrealname = snapshot.data['username'];
    return clubmemberrealname;
  }

  clubAlternateMemberRealName(clubalternatememberdata) async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('users')
        .document(clubalternatememberdata)
        .get();
    clubalternatememberrealname = snapshot.data['username'];
    return clubalternatememberrealname;
  }

  clubAlternateMember2RealName(clubalternatemember2data) async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('users')
        .document(clubalternatemember2data)
        .get();
    clubalternatemember2realname = snapshot.data['username'];
    return clubalternatemember2realname;
  }
}
