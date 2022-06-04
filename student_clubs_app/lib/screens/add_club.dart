import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_clubs_app/screens/profile.dart';

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

  void _pickImage() async {
    final pickedImageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Appcolors.mainColor,
        centerTitle: true,
        title: Text("Add Club"),
        actions: [
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
            }, //Burada eğer kullanıcı giriş yapmışsa profil sayfasına yoksa logine gidecek
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage:
                  _pickedImage != null ? FileImage(_pickedImage) : null,
            ),
            FlatButton.icon(
                textColor: Colors.deepPurple,
                onPressed:
                    _pickImage, // gets executed whenever a user presses this button
                icon: Icon(Icons.image),
                label: Text('Pick Image')), //burada image ekleme yeri olacak
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
    String statuss="false";
    if(status==1){
      statuss="true";
    }
    // bu methodu submit butonunun içine koyulcak database club resmi yüklenmesi için
    final ref = FirebaseStorage.instance
        .ref()
        .child('clubImages')
        .child('nyanImage.jpg');

    await ref
        .putFile(_pickedImage)
        .onComplete; // bu imageı database upload ediyo

    final url =
        await ref.getDownloadURL(); // this is the url for downloading the image

    final map = <String, String>{
      "Advisor": clubAdvisorController.text,
      "ClubName": clubNameController.text,
      "ClubPresident": clubPresidentController.text,
      "Description": clubDescriptionController.text,
      "Status": statuss,
      "clubImage": url
    };

    Firestore.instance
        .collection("clubs")
        .document(clubNameController.text)
        .setData(map);

    // bu urli yarattığımız kulubün imageUrl fieldina yapıştırmalıyız submit yaparken
  }
  /*sendData(){
 uploadFile();
    final map = <String, String>{
      "Advisor": clubAdvisorController.text,
      "ClubName": clubNameController.text,
      "ClubPresident": clubPresidentController.text,
    "Descrption": "description",
    "Status": "true",
    "clubImage": url
    };

 Firestore.instance.collection("clubs").document(clubNameController.text).setData(map);
  }*/

} // end
