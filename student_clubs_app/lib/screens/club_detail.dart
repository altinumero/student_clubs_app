import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: Appcolors.backgroundColor,
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
                      Text("President : ${clubpresidentdata}",
                          style: TextStyle(color: Appcolors.textColor)),
                      Text("Advisor:${clubadvisordata} ",
                          style: TextStyle(color: Appcolors.textColor)),
                      Text("Vice President : ${clubvicepresidentdata}",
                          style: TextStyle(color: Appcolors.textColor)),
                      Text("Accountant: ${clubaccountantdata}",
                          style: TextStyle(color: Appcolors.textColor)),
                      Text("Secretary:${clubsecretarydata} ",
                          style: TextStyle(color: Appcolors.textColor)),
                      Text("Member: ${clubmemberdata}",
                          style: TextStyle(color: Appcolors.textColor)),
                      Text("Alternate Member: ${clubaltmember1data}",
                          style: TextStyle(color: Appcolors.textColor)),
                      Text("Alternate Member 2:${clubaltmember2data} ",
                          style: TextStyle(color: Appcolors.textColor)),
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
              future: getCurrentUserType(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                        visible: ((snapshot.data == "student" ||
                                snapshot.data == "president") &&
                            3 + 3 == 6 &&
                            statusdata=="Active"),
                        child: Container(
                          child: buildElevatedButton(
                              "Join Club", Appcolors.joinColor, () {}),
                        )),
                    Visibility(
                        visible: ((snapshot.data == "student" ||
                                snapshot.data == "president") &&
                            3 + 3 == 7 &&
                            statusdata=="Active"),
                        child: Container(
                          child: buildElevatedButton(
                              "Leave Club", Appcolors.warningColor, () {}),
                        )),
                  ],
                );
              }),
          sizedBox(16),
          buildName(clubnamedata),
          buildEventList()
        ],
      ),
      bottomNavigationBar: FutureBuilder(
          future: getCurrentUserType(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return Visibility(
              visible: (snapshot.data == "sks"),
              child: Container(
                child: buildElevatedButton(
                    "Remove Club", Appcolors.warningColor, () {}),
              ),
            );
          }),
    );
  }

  sizedBox(double i) {
    return SizedBox(height: i);
  }

  buildName(clubnamedata) {
    return Column(
      children: [
        Text(
          "${clubnamedata}'s Events",
          style: TextStyle(color: Appcolors.darkBlueColor),
        )
      ],
    );
  }

  buildEventList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 16,
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 16, //kaç tane olduğu veritabanından
          itemBuilder: (BuildContext context, int position) {
            return ListTile(
              leading: ClipOval(
                child: Material(
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Ink.image(
                      image: NetworkImage(//logolar veritabanından
                          "https://cdn.pixabay.com/photo/2022/05/09/17/08/mute-swan-7185076_1280.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              title: Text(
                "Zınk",
                style: TextStyle(color: Appcolors.darkBlueColor),
              ), //isimler veritabanından //Text(this.products![position].name!),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EventDetail()));
              }, //detay sayfasına aktarıcaz yine veritabanı bağlantısı(sqflite_demo,productListte var)
            );
          },
        )
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
    print(userType);
    return userType;
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user.uid;
  }
}
