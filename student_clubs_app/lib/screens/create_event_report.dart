import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:student_clubs_app/screens/profile.dart';

import '../home/main_club_page.dart';
import '../utils/colors.dart';
import 'login.dart';

class CreateEventReport extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var usertypedata;
  List eventReportsListOfTheClub;
  var clubnameforevent;
  var urltobeadded;
  DocumentReference docRef;
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
          title: Text("Create Event Report"),
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
        body: Padding(
          padding: EdgeInsets.all(30),
          child: ListView(
            children: [
              FutureBuilder(
                  future: getClubNameOfPresident(),
                  builder: (context, snapshot) {
                    var clubnamedataa = snapshot.data;
                    return buildElevatedButton(
                        "Add Report", Appcolors.joinColor, () async {
                      //final FirebaseUser user = await _auth.currentUser();
                      //final uid = user.uid;

                      //log("nameofpres" + snapshot.data);
                      docRef = Firestore.instance
                          .collection("clubs")
                          .document(clubnamedataa);

                      DocumentSnapshot doc = await docRef.get();
                      eventReportsListOfTheClub = doc.data["EventReports"];
                      //dev.log("looo" + getPdfAndUpload().toString());
                      urltobeadded =  getPdfAndUpload();
                      //dev.log("urltobeadded: " + urltobeadded);
                      docRef.updateData({
                        'EventReports': FieldValue.arrayUnion(
                            [urltobeadded]) // event report pdfi gönder
                        //BUNU FUTURE BUİLDER İLE YAAAAAAP!!!!!!
                      });
                    });
                  })
              //Template indirme kısmı olacak
              //upload etme kısmı olacak
              //upload yapan kişi hangi kulübün başkanıysa report o kulübe ait olacak
              //o kulübün advisorı bu sayede raporları görecek
            ],
          ),
        ),
      ),
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

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user.uid;
  }

  Future<String> getClubNameOfPresident() async {
    var currentUser = await getCurrentUser();
    var collection = await Firestore.instance.collection('clubs');
    var querySnapshot = await collection
        .where('ClubPresident'.toString(), isEqualTo: currentUser.toString())
        .getDocuments();

    for (var snapshot in querySnapshot.documents) {
      clubnameforevent = snapshot.data["ClubName"];
    }
    //log('dattaaa: $clubnameforevent');

    return clubnameforevent;
  }

  buildEventReportList() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
  }

  Future getPdfAndUpload() async {
    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if(result != null) {
      File file = File(result.files.single.path);
      String fileName = '${randomName}.pdf';
      //print(fileName);
      //print('${file.bytes}');
      savePdf(file.readAsBytesSync(), fileName);
    }else { print("user cancelled picker??");}
  }

  Future savePdf(List<int> asset, String name) async {
    StorageReference reference = FirebaseStorage.instance.ref().child(name);
    StorageUploadTask uploadTask =
        reference.putData(asset); // database'e pdfi upload edio
    String url = await (await uploadTask.onComplete)
        .ref
        .getDownloadURL(); // url for downloading pdf
    print("linkk" + url);
    //documentFileUpload(url);
    //urltobeadded = url;
    return url;
  }
} //end
