import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_clubs_app/home/main_club_page.dart';
import 'package:student_clubs_app/screens/login.dart';
import 'package:student_clubs_app/screens/my_clubs.dart';
import 'package:student_clubs_app/screens/my_events.dart';
import 'package:student_clubs_app/utils/colors.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
          title: const Text("Profile"),
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainClubPage()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
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
              }, //Burada eğer kullanıcı giriş yapmışsa profil sayfasına yoksa logine gidecek
            ),
          ],
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            sizedBox(24),
            buildProfileImage(), //veritabanından kullanıcı gidecek
            sizedBox(16),
            buildName(), //veritabanından kullanıcı yolluycaz.
            sizedBox(16),
            FutureBuilder(
                future: getCurrentUserType(),
                builder: (context, snapshot) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                          visible: (snapshot.data.toString() == "president" ||
                              snapshot.data.toString() == "student"),
                          child: buildElevatedButton("My Clubs", () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyClubs()));
                          })),
                      Visibility(
                          visible: (snapshot.data.toString() == "president" ||
                              snapshot.data.toString() == "student"),
                          child: buildElevatedButton("My Events", () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyEvents()));
                          }))
                    ],
                  );
                }),
          ],
        ),
        bottomNavigationBar: Container(
          child: buildElevatedButton("Logout", () {
            _signOut();
          }),
        ),
      ),
    );
  }

  buildName() {
    CollectionReference users = Firestore.instance.collection('users');
    //var currentuserid = getCurrentUser();

    return Column(
      children: [
        FutureBuilder<String>(
            future: getCurrentUserName(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data, //veri tabanından isim
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 24));
              } else {
                return Text("Loading user data...");
              }
            }),
        sizedBox(16),
        FutureBuilder<String>(
            future: getCurrentUserEmail(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data, //veri tabanından mail
                    style: TextStyle(color: Colors.black, fontSize: 24));
              } else {
                return Text("Loading user data...");
              }
            }),
        sizedBox(15),
        FutureBuilder<String>(
          future: getPresidentUsersClubName(),
          initialData: null, // You can set a default value here.
          builder: (context, snapshot) {
            debugPrint('data1: ' + snapshot.data.toString());
            return snapshot.data == null
                ? Text("no data")
                : Text(
              snapshot.data.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            );
          },
        )
      ],
    );
  }

  buildElevatedButton(String text, VoidCallback onClicked) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        onPrimary: Appcolors.textColor,
        primary: Appcolors.mainColor,
        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 12),
      ),
      onPressed: onClicked,
      child: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  sizedBox(double i) {
    return SizedBox(height: i);
  }

  buildProfileImage() {
    return Column(
      children: [
        FutureBuilder<String>(
            future: getUsersPicture(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: Ink.image(
                        image: NetworkImage(//veri tabanından resim
                            snapshot.data),
                        fit: BoxFit.cover,
                        width: 128,
                        height: 128,
                      ),
                    ),
                  ),
                );
              } else {
                return Text("Loading user data...");
              }
            }),
      ],
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Login()));
  }

  Future<String> getCurrentUserEmail() async {
    FirebaseUser user = await _auth.currentUser();
    final String email = user.email.toString();
    //  print(email);
    return email;
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
    log("usertype: " + userType);
    return userType;
  }

  Future<String> getPresidentUsersClubName() async {
    var currentUser = await getCurrentUser(); //id
    var currentUserType = await getCurrentUserType();

    if (currentUserType.toString() == "president") {
      var collection = await Firestore.instance.collection('clubs');
      var querySnapshot = await collection
          .where('ClubPresident'.toString(), isEqualTo: currentUser.toString())
          .getDocuments();

      for (var snapshot in querySnapshot.documents) {
        clubnamefortext = snapshot.data["ClubName"];
      }

      log('dataa: $clubnamefortext');

      return "President of the " + clubnamefortext + " club";
    } else if (currentUserType.toString() == "student") {
      return "Student";
    } else if (currentUserType.toString() == "sks") {
      return "SKS";
    } else if (currentUserType.toString() == "advisor") {
      return "Advisor";
    }
    return "";
  }

  Future<String> getCurrentUserName() async {
    final uid = await getCurrentUser();

    DocumentSnapshot snapshot =
    await Firestore.instance.collection('users').document(uid).get();
    var username = snapshot.data[
    'username']; //you can get any field value you want by writing the exact fieldName in the data[fieldName]
    return username;
  }

  Future<String> getUsersPicture() async {
    final uid = await getCurrentUser();

    DocumentSnapshot snapshot =
    await Firestore.instance.collection('users').document(uid).get();
    var userImage = snapshot.data[
    'userImage']; //you can get any field value you want by writing the exact fieldName in the data[fieldName]
    return userImage;
  }
}
