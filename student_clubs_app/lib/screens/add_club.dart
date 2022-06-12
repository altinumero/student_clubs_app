import 'dart:developer';
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

  TextEditingController clubDescriptionController = TextEditingController();

  int status = 0;

  File _pickedImage;

  String urlForImage;
  var selectedPresident;
  var selectedVicePresident;
  var selectedSecretary;
  var selectedAccountant;
  var selectedMember;
  var selectedAltMember1;
  var selectedAltMember2;
  var selectedAdvisor;
  String selectPresident = "Select President";
  String selectVicePresident = "Select Vice President";
  String selectSecretary = "Select Secretary";
  String selectAccountant = "Select Accountant";
  String selectMember = "Select Member";
  String selectAltMember1 = "Select Alternative Member 1";
  String selectAltMember2 = "Select Alternative Member 2";
  String selectAdvisor = "Select Advisor";

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
              stream: Firestore.instance
                  .collection('users')
                  .where("userType", isEqualTo: "student")
                  .snapshots(),
              builder: (context, streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return StreamBuilder(
                    stream: Firestore.instance
                        .collection('users')
                        .where("userType", isEqualTo: "advisor").where("isAdvising",isEqualTo: "false")
                        .snapshots(),
                    builder: (context, streamSnapshot2) {
                      if (streamSnapshot2.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final documents =
                          streamSnapshot.data.documents; //student için
                      final advisorDocuments = streamSnapshot2.data.documents;
                      return ListView(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: _pickedImage != null
                                ? FileImage(_pickedImage)
                                : null,
                          ),
                          FlatButton.icon(
                              color: Appcolors.transparent,
                              textColor: Colors.lightGreen,
                              onPressed: _pickImage,
                              icon: Icon(Icons.image),
                              label: Text(
                                'Pick Image',
                                style: TextStyle(fontSize: 20),
                              )),
                          sizedBox(8),
                          buildClubNameField(),
                          sizedBox(8),
                          buildClubAdvisorField(advisorDocuments),
                          sizedBox(8),
                          buildClubPresidentField(documents),
                          sizedBox(8),
                          buildClubVicePresidentField(documents),
                          sizedBox(8),
                          buildClubSecretaryNameField(documents),
                          sizedBox(8),
                          buildClubAccountantField(documents),
                          sizedBox(8),
                          buildClubMemberField(documents),
                          sizedBox(8),
                          buildClubAltMember1Field(documents),
                          sizedBox(8),
                          buildClubAltMember2Field(documents),
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
                                    onChanged: (value) =>
                                        setState(() => status = 0)),
                                RadioListTile(
                                    value: 1,
                                    groupValue: status,
                                    title: Text("Active"),
                                    onChanged: (value) =>
                                        setState(() => status = 1))
                              ],
                            ),
                          ),
                          buildElevatedButton(
                              "Add Club", Appcolors.joinColor, () {})
                        ],
                      );
                    });
              }),
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
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Appcolors.darkBlueColor)),
          hintText: "Club Name",
          prefixIcon: Icon(Icons.drive_file_rename_outline)),
      validator: (value) {},
    );
  }

  buildClubAdvisorField(advisorDocuments) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Appcolors.transparent,
          border: Border.all(color: Appcolors.darkBlueColor)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SearchableDropdown.single(
          items: advisorDocuments
              .map<DropdownMenuItem<DocumentSnapshot>>(buildMenuItem)
              .toList(),
          value: selectedAdvisor,
          hint: selectAdvisor,
          searchHint: "Select one",
          onChanged: (value) {
            setState(() {
              selectedAdvisor = value;
              selectAdvisor = selectedAdvisor["username"].toString();
            });
          },
          isExpanded: true,
        ),
      ),
    );
  }

  buildClubPresidentField(documents) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Appcolors.transparent,
          border: Border.all(color: Appcolors.darkBlueColor)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SearchableDropdown.single(
          items: documents
              .map<DropdownMenuItem<DocumentSnapshot>>(buildMenuItem)
              .toList(),
          value: selectedPresident,
          hint: selectPresident,
          searchHint: "Select one",
          onChanged: (value) {
            setState(() {
              selectedPresident = value;
              selectPresident = selectedPresident["username"].toString();
            });
          },
          isExpanded: true,
        ),
      ),
    );
  }

  buildClubVicePresidentField(documents) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Appcolors.transparent,
          border: Border.all(color: Appcolors.darkBlueColor)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SearchableDropdown.single(
          items: documents
              .map<DropdownMenuItem<DocumentSnapshot>>(buildMenuItem)
              .toList(),
          value: selectedVicePresident,
          hint: selectVicePresident,
          searchHint: "Select one",
          onChanged: (value) {
            setState(() {
              selectedVicePresident = value;
              selectVicePresident =
                  selectedVicePresident["username"].toString();
            });
          },
          isExpanded: true,
        ),
      ),
    );
  }

  buildClubSecretaryNameField(documents) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Appcolors.transparent,
          border: Border.all(color: Appcolors.darkBlueColor)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SearchableDropdown.single(
          items: documents
              .map<DropdownMenuItem<DocumentSnapshot>>(buildMenuItem)
              .toList(),
          value: selectedSecretary,
          hint: selectSecretary,
          searchHint: "Select one",
          onChanged: (value) {
            setState(() {
              selectedSecretary = value;
              selectSecretary = selectedSecretary["username"].toString();
            });
          },
          isExpanded: true,
        ),
      ),
    );
  }

  buildClubAccountantField(documents) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Appcolors.transparent,
          border: Border.all(color: Appcolors.darkBlueColor)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SearchableDropdown.single(
          items: documents
              .map<DropdownMenuItem<DocumentSnapshot>>(buildMenuItem)
              .toList(),
          value: selectedAccountant,
          hint: selectAccountant,
          searchHint: "Select one",
          onChanged: (value) {
            setState(() {
              selectedAccountant = value;
              selectAccountant = selectedAccountant["username"].toString();
            });
          },
          isExpanded: true,
        ),
      ),
    );
  }

  buildClubMemberField(documents) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Appcolors.transparent,
          border: Border.all(color: Appcolors.darkBlueColor)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SearchableDropdown.single(
          items: documents
              .map<DropdownMenuItem<DocumentSnapshot>>(buildMenuItem)
              .toList(),
          value: selectedMember,
          hint: selectMember,
          searchHint: "Select one",
          onChanged: (value) {
            setState(() {
              selectedMember = value;
              selectMember = selectedMember["username"].toString();
            });
          },
          isExpanded: true,
        ),
      ),
    );
  }

  buildClubAltMember1Field(documents) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Appcolors.transparent,
          border: Border.all(color: Appcolors.darkBlueColor)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SearchableDropdown.single(
          items: documents
              .map<DropdownMenuItem<DocumentSnapshot>>(buildMenuItem)
              .toList(),
          value: selectedAltMember1,
          hint: selectAltMember1,
          searchHint: "Select one",
          onChanged: (value) {
            setState(() {
              selectedAltMember1 = value;
              selectAltMember1 = selectedAltMember1["username"].toString();
            });
          },
          isExpanded: true,
        ),
      ),
    );
  }

  buildClubAltMember2Field(documents) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Appcolors.transparent,
          border: Border.all(color: Appcolors.darkBlueColor)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SearchableDropdown.single(
          items: documents
              .map<DropdownMenuItem<DocumentSnapshot>>(buildMenuItem)
              .toList(),
          value: selectedAltMember2,
          hint: selectAltMember2,
          searchHint: "Select one",
          onChanged: (value) {
            setState(() {
              selectedAltMember2 = value;
              selectAltMember2 = selectedAltMember2["username"].toString();
            });
          },
          isExpanded: true,
        ),
      ),
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
      "Advisor": selectedAdvisor["userId"],
      "ClubName": clubNameController.text,
      "ClubPresident": selectedPresident["userId"],
      "VicePresident": selectedVicePresident["userId"],
      "Secretary": selectedSecretary["userId"],
      "Accountant": selectedAccountant["userId"],
      "ClubMember": selectedMember["userId"],
      "ClubAltMember": selectedAltMember1["userId"],
      "ClubAltMember2": selectedAltMember2["userId"],
      "Description": clubDescriptionController.text,
      "Status": statuss,
      "clubImage": url
    };
    Firestore.instance
        .collection("clubs")
        .document(clubNameController.text)
        .setData(map);
    var updatedmap = <String, String>{"userType": "president"};
    var updatedmapadvisor = <String, String>{"isAdvising": "true"};
    Firestore.instance
        .collection("users")
        .document(selectedPresident["userId"])
        .updateData(updatedmap);
    Firestore.instance
        .collection("users")
        .document(selectedAdvisor["userId"])
        .updateData(updatedmapadvisor);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ClubsList()));
    Fluttertoast.showToast(
      msg: "Club Created!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  DropdownMenuItem<DocumentSnapshot> buildMenuItem(DocumentSnapshot item) {
    return DropdownMenuItem(
      value: item,
      child: Text(
        item["username"],
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }
} // end
