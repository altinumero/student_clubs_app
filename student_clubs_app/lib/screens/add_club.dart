import 'package:flutter/material.dart';

import '../utils/colors.dart';

class AddClub extends StatelessWidget {
  AddClub({Key key}) : super(key: key);
  TextEditingController clubNameController = TextEditingController();
  TextEditingController clubAdvisorController = TextEditingController();
  TextEditingController clubPresidentController = TextEditingController();
  TextEditingController clubVicePresidentController = TextEditingController();
  TextEditingController clubSecretaryController = TextEditingController();
  TextEditingController clubAccountantController = TextEditingController();
  TextEditingController clubMemberController = TextEditingController();
  TextEditingController clubAltMember1Controller = TextEditingController();
  TextEditingController clubAltMember2Controller = TextEditingController();
  String clubName;
  String clubAdvisor;
  String clubPresident;
  String clubVicePresident;
  String clubSecretary;
  String clubAccountant;
  String clubMember;
  String clubAltMember1;
  String clubAltMember2;


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
            onPressed:
                () {}, //Burada eğer kullanıcı giriş yapmışsa profil sayfasına yoksa logine gidecek
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: ListView(
          children: [
            //burada image ekleme yeri olacak
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
            buildElevatedButton("Add Club", Appcolors.joinColor, () { })
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
  buildElevatedButton(String text, Color color, VoidCallback onClicked) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        onPrimary: Appcolors.textColor,
        primary: color,
        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 12),
      ),
      onPressed: onClicked, //logout için veritabanı fonksiyonu
      child: Text(text),
    );
  }
}
