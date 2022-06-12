import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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
  int activeIndex = 0;
  final urlImages = [
    "https://firebasestorage.googleapis.com/v0/b/student-clubs-aaae0.appspot.com/o/imageSlider%2Fisik-universitesi.jpg?alt=media&token=2e8041f3-a96a-4db6-ad48-d64b259de399",
    "https://firebasestorage.googleapis.com/v0/b/student-clubs-aaae0.appspot.com/o/imageSlider%2F05-sile.jpg?alt=media&token=cf523763-fd0d-4636-9600-53d524c0e05e",
    "https://firebasestorage.googleapis.com/v0/b/student-clubs-aaae0.appspot.com/o/imageSlider%2Fisik-universitesi-kampus.jpg?alt=media&token=e075ae1f-fa96-4979-bb35-3258dfd67365",
    "https://firebasestorage.googleapis.com/v0/b/student-clubs-aaae0.appspot.com/o/imageSlider%2Fillustration.jpg?alt=media&token=309a4af2-9ec6-49e7-8661-94c707777504"
  ];
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
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            SizedBox(height: 3),
            Container(
              child: const Image(
                image: AssetImage("assets/logo.png"),
              ),
              padding: const EdgeInsets.all(15),
            ),
            SizedBox(height: 3),
            Container(
                height: 350,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CarouselSlider.builder(
                          options: CarouselOptions(
                              height: 250,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) =>
                                  setState(() => activeIndex = index)),
                          itemCount: urlImages.length,
                          itemBuilder: (context, index, realIndex) {
                            final urlImage = urlImages[index];
                            return buildImage(urlImage, index);
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      buildIndicator(),
                      SizedBox(
                        height: 1,
                      )
                    ],
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 150,
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
                        style: TextStyle(
                            fontFamily: "MontserratAlternates",
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Appcolors.textColor),
                      )),
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  width: 200,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventsList()));
                    },
                    child: Card(
                        color: Appcolors.darkBlueColor,
                        elevation: 2,
                        child: Center(
                          child: Text(
                            "Events",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "MontserratAlternates",
                                fontSize: 48,
                                color: Appcolors.textColor),
                          ),
                        )),
                  ),
                )
              ],
            )
          ],
        ),
        drawer: NavigationDrawerWidget(),
      ),
    );
  }

  Widget buildImage(String urlImage, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6),
      color: Colors.purple,
      child: Image.network(
        urlImage,
        fit: BoxFit.cover,
      ),
    );
  }

  buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: urlImages.length,
      effect: JumpingDotEffect(dotWidth: 20, dotHeight: 20),
    );
  }
}
