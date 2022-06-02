import 'package:flutter/material.dart';
import 'package:student_clubs_app/screens/login.dart';
import 'package:student_clubs_app/screens/profile.dart';
import 'package:student_clubs_app/utils/colors.dart';

import '../widgets/navigation_drawer_widget.dart';

class MainClubPage extends StatefulWidget {
  const MainClubPage({Key? key}) : super(key: key);

  @override
  State<MainClubPage> createState() => _MainClubPageState();
}

class _MainClubPageState extends State<MainClubPage> {
  @override
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
              if (3 + 3 == 6) {
                //isLogin will add
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const Profile()));
              } else {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Login()));
              }
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
          )
        ],
      ),
      backgroundColor: Appcolors.backgroundColor,
      drawer: const NavigationDrawerWidget(),
    );
  }
}