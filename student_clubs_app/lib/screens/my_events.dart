import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_clubs_app/screens/profile.dart';

import '../home/main_club_page.dart';
import '../utils/colors.dart';
import 'event_detail.dart';
import 'login.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({Key key}) : super(key: key);

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  List MyEvents;
  var arr;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Appcolors.mainColor,
        centerTitle: true,
        title: Text("My Events"),
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
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FutureBuilder(
              future: buildEventListSez(),
              builder: ( context,  snapshot){
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
                                  child: Text(
                                      "Event"
                                    //Firestore.instance.collection("clubs").document(snapshot.data[index])
                                  ),
                                  backgroundColor: Colors.transparent),
                            ),
                          ),
                          title: Text(snapshot.data[index]),
                          /*onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(

                                  builder: (context) =>EventDetail(

                                      eventownerdata:snapshot.data[index],
                                      eventnamedata: snapshot.data[index],
                                      eventlocationdata: snapshot.data[index],
                                      eventdescriptiondata: snapshot.data[index]
                                      //['EventDescription']
                                  )
                              ),

                            );
                          },*/
                        ),
                      ),
                    ),
                  );
                } else { return Text("lodaing data");}
              },
            ),),
        ],
      ),
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
                  "Zınk"), //isimler veritabanından //Text(this.products![position].name!),
              onTap:
                  () {}, //detay sayfasına aktarıcaz yine veritabanı bağlantısı(sqflite_demo,productListte var)
            );
          },
        )
      ],
    );
  }
  buildEventListSez() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    log("c" + uid);
    DocumentReference docRef =  Firestore.instance.collection("users").document(uid);
    DocumentSnapshot doc = await docRef.get();
    MyEvents = doc.data["MyEvents"]; // events array list
    print("mm" + MyEvents.toString());
    log("myclubs: " +MyEvents.toString());

    return MyEvents;
  }
}
