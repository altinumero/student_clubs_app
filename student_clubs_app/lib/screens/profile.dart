import 'package:flutter/material.dart';
import 'package:student_clubs_app/screens/my_clubs.dart';
import 'package:student_clubs_app/screens/my_events.dart';
import 'package:student_clubs_app/utils/colors.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Appcolors.mainColor,
        centerTitle: true,
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed:
                () {}, //Burada eğer kullanıcı giriş yapmışsa profil sayfasına yoksa logine gidecek
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          sizedBox(24),
          buildProfileImage(), //veritabanından kullanıcı gidecek
          sizedBox(16),
          buildName(), //veritabanından kullanıcı yolluycaz.
          sizedBox(16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildElevatedButton("My Clubs", () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MyClubs()));
              }),
              buildElevatedButton("My Events", () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MyEvents()));
              })
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        child: buildElevatedButton("Logout", () {}),
      ),
    );
  }

  buildName() {
    return Column(
      children: [
        Text("İsim", //veri tabanından isim
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        Text(
          "Mail", //veri tabanından mail
          style: TextStyle(color: Appcolors.textColor),
        )
      ],
    );
  }

  buildElevatedButton(String text, VoidCallback onClicked) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        onPrimary: Appcolors.textColor,
        primary: Appcolors.mainColor,
        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 12),
      ),
      onPressed: onClicked, //logout için veritabanı fonksiyonu
      child: Text(text),
    );
  }

  sizedBox(double i) {
    return SizedBox(height: i);
  }

  buildProfileImage() {
    return Center(
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: NetworkImage(//veri tabanından resim
                "https://cdn.pixabay.com/photo/2022/05/09/17/08/mute-swan-7185076_1280.jpg"),
            fit: BoxFit.cover,
            width: 128,
            height: 128,
          ),
        ),
      ),
    );
  }
}
