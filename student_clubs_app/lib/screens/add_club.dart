import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:student_clubs_app/screens/clubs_list.dart';
import 'package:student_clubs_app/screens/profile.dart';

import '../home/main_club_page.dart';
import '../utils/colors.dart';
import 'login.dart';

class AddClub extends StatefulWidget {
  AddClub({Key key}) : super(key: key);

  @override
  State<AddClub> createState() => _AddClubState();
}

class _AddClubState extends State<AddClub> {
  TextEditingController clubNameController = TextEditingController();

  TextEditingController clubAdvisorController = TextEditingController();

  TextEditingController clubPresidentController = TextEditingController();

  TextEditingController clubVicePresidentController = TextEditingController();

  TextEditingController clubSecretaryController = TextEditingController();

  TextEditingController clubAccountantController = TextEditingController();

  TextEditingController clubMemberController = TextEditingController();

  TextEditingController clubAltMember1Controller = TextEditingController();

  TextEditingController clubAltMember2Controller = TextEditingController();

  TextEditingController clubDescriptionController = TextEditingController();

  int status = 0;

  // CLUB DESCRIPTION VE CLUB STATUS FIELDALARI EKLENMESİ GEREK!!
  File _pickedImage;

  String urlForImage;
  var selectedValue;
  final items= ["zınk","zort","tırt","sezin", "canalp"];
List mylist;

  void _pickImage() async {
    final pickedImageFile =
    await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

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
          title: Text("Add Club"),
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
          child: StreamBuilder(
              stream: Firestore.instance.collection('users').where("userType", isEqualTo: "student" ).snapshots(),
              builder: (context, streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final documents = streamSnapshot.data.documents;

              return ListView(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                    _pickedImage != null ? FileImage(_pickedImage) : null,
                  ),
                  FlatButton.icon(
                      textColor: Colors.deepPurple,
                      onPressed: _pickImage,
                      icon: Icon(Icons.image),
                      label: Text('Pick Image')),
                  sizedBox(8),
                  Container(
                    child: SearchableDropdown.single(
                      items: documents.map(buildMenuItem).toList(),
                      value: selectedValue,
                      hint: "Select one",
                      searchHint: "Select one",
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                  buildClubNameField(),
                  sizedBox(8),
                  buildClubAdvisorField(),
                  sizedBox(8),
                  buildClubPresidentField(),
                  sizedBox(8),
                  buildClubVicePresidentField(),
                  sizedBox(8),
                  buildClubSecretaryNameField(),
                  sizedBox(8),
                  buildClubAccountantField(),
                  sizedBox(8),
                  buildClubMemberField(),
                  sizedBox(8),
                  buildClubAltMember1Field(),
                  sizedBox(8),
                  buildClubAltMember2Field(),
                  sizedBox(8),
                  buildClubDescriptionField(),
                  sizedBox(8),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RadioListTile(
                            value: 0,
                            groupValue: status,
                            title: Text("Passive"),
                            onChanged: (value) => setState(() => status = 0)),
                        RadioListTile(
                            value: 1,
                            groupValue: status,
                            title: Text("Active"),
                            onChanged: (value) => setState(() => status = 1))
                      ],
                    ),
                  ),
                  buildElevatedButton("Add Club", Appcolors.joinColor, () {})
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  sizedBox(double i) {
    return SizedBox(height: i);
  }

  buildClubNameField() {
    return TextFormField(
      controller: clubNameController,
      decoration: InputDecoration(
          hintText: "Club Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.drive_file_rename_outline)),
      validator: (value) {},
    );
  }

  buildClubAdvisorField() {
    return TextFormField(
      controller: clubAdvisorController,
      decoration: InputDecoration(
          hintText: "Club Advisor",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.person)),
      validator: (value) {},
    );
  }

  buildClubPresidentField() {
    return TextFormField(
      controller: clubPresidentController,
      decoration: InputDecoration(
          hintText: "Club President",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.person)),
      validator: (value) {},
    );
  }

  buildClubVicePresidentField() {
    return TextFormField(
      controller: clubVicePresidentController,
      decoration: InputDecoration(
          hintText: "Club Vice President",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.person)),
      validator: (value) {},
    );
  }

  buildClubSecretaryNameField() {
    return TextFormField(
      controller: clubSecretaryController,
      decoration: InputDecoration(
          hintText: "Club Secretary",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.drive_file_rename_outline)),
      validator: (value) {},
    );
  }

  buildClubAccountantField() {
    return TextFormField(
      controller: clubAccountantController,
      decoration: InputDecoration(
          hintText: "Club Accountant",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.person)),
      validator: (value) {},
    );
  }

  buildClubMemberField() {
    return TextFormField(
      controller: clubMemberController,
      decoration: InputDecoration(
          hintText: "Club Member",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.person)),
      validator: (value) {},
    );
  }

  buildClubAltMember1Field() {
    return TextFormField(
      controller: clubAltMember1Controller,
      decoration: InputDecoration(
          hintText: "Club Alternate Member 1",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.person)),
      validator: (value) {},
    );
  }

  buildClubAltMember2Field() {
    return TextFormField(
      controller: clubAltMember2Controller,
      decoration: InputDecoration(
          hintText: "Club Alternate Member 2",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.person)),
      validator: (value) {},
    );
  }

  buildClubDescriptionField() {
    return TextFormField(
      controller: clubDescriptionController,
      decoration: InputDecoration(
          hintText: "Club Description",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.drive_file_rename_outline)),
      validator: (value) {},
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
      onPressed: () {
        //uploadFile();
        uploadFileandSendData();
      }, // resim database'e yükleniyor
      //buraya başka methodlar gelcek klüp ismi vb database'e eklenmesi için

      child: Text(text),
    );
  }

  void uploadFileandSendData() async {
    String statuss = "Passive";
    if (status == 1) {
      statuss = "Active";
    }
    // bu methodu submit butonunun içine koyulcak database club resmi yüklenmesi için
    final ref = FirebaseStorage.instance
        .ref()
        .child('clubImages')
        .child('${clubNameController.text}.jpg');

    await ref
        .putFile(_pickedImage)
        .onComplete; // bu imageı database upload ediyo

    final url =
    await ref.getDownloadURL(); // this is the url for downloading the image

    final map = <String, String>{
      "Advisor": clubAdvisorController.text,
      "ClubName": clubNameController.text,
      "ClubPresident": clubPresidentController.text,
      "VicePresident": clubVicePresidentController.text,
      "Secretary": clubSecretaryController.text,
      "Accountant": clubAccountantController.text,
      "ClubMember": clubMemberController.text,
      "ClubAltMember": clubAltMember1Controller.text,
      "ClubAltMember2": clubAltMember2Controller.text,
      "Description": clubDescriptionController.text,
      "Status": statuss,
      "clubImage": url
    };
    Firestore.instance
        .collection("clubs")
        .document(clubNameController.text)
        .setData(map);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ClubsList()));
    Fluttertoast.showToast(
      msg: "Club Created!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
    // b
    // bu urli yarattığımız kulubün imageUrl fieldina yapıştırmalıyız submit yaparken
  }

  DropdownMenuItem<DocumentSnapshot> buildMenuItem(DocumentSnapshot item) {
    return DropdownMenuItem(value: item,child: Text(item["username"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),);
  }


  getStudentUsers(){
    Firestore.instance
        .collection("users")
        .where('userType'.toString(),
        isEqualTo: "student")
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        Firestore.instance
            .collection("users")
            .document(element.documentID).get()
            .then((value) {
          print("deleting event success");
        });
      });
    });

  }


} // end
