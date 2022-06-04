import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_clubs_app/screens/clubs_list.dart';
import 'package:student_clubs_app/screens/events_list.dart';
import 'package:student_clubs_app/screens/login.dart';
import 'package:student_clubs_app/screens/profile.dart';
import 'package:student_clubs_app/utils/colors.dart';

import '../widgets/navigation_drawer_widget.dart';

class MainClubPage extends StatefulWidget {
  const MainClubPage({Key key}) : super(key: key);

  @override
  State<MainClubPage> createState() => _MainClubPageState();
}

class _MainClubPageState extends State<MainClubPage> {
  @override
  bool _isLoggedin = false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.mainColor,
        centerTitle: true,
        title: const Text("Işık Student Clubs"),
        actions: [
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
              /*if (_isLoggedin==true) {
                //isLogin will add
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const Profile()));
              } else if (_isLoggedin==false){

                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Login(logindata: _isLoggedin)));
              }*/
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            child: const Image(
              image: AssetImage("assets/logo.png"),
            ),
            padding: const EdgeInsets.all(15),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 500,
                width: 200,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ClubsList()));
                  },
                  child: Card(
                    color: Appcolors.darkBlueColor,
                    elevation: 2,
                    child: Center(
                        child: Text(
                      "Clubs",
                      style:
                          TextStyle(fontSize: 48, color: Appcolors.textColor),
                    )),
                  ),
                ),
              ),
              Container(
                height: 500,
                width: 200,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EventsList()));
                  },
                  child: Card(
                      color: Appcolors.darkBlueColor,
                      elevation: 2,
                      child: Center(
                        child: Text(
                          "Events",
                          style:
                              TextStyle(fontSize: 48, color: Appcolors.textColor),
                        ),
                      )),
                ),
              )
            ],
          )
        ],
      ),
      backgroundColor: Appcolors.backgroundColor,
      drawer: NavigationDrawerWidget(),
    );
  }
}
