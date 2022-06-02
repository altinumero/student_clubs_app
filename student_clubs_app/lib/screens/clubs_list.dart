import 'package:flutter/material.dart';

import '../utils/colors.dart';

class ClubsList extends StatefulWidget {
  const ClubsList({Key? key}) : super(key: key);

  @override
  State<ClubsList> createState() => _ClubsListState();
}

class _ClubsListState extends State<ClubsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Appcolors.mainColor,
        centerTitle: true,
        title: Text("Clubs List"),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed:
                () {}, //Burada eğer kullanıcı giriş yapmışsa profil sayfasına yoksa logine gidecek
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: buildClubList(),
          ),
        ],
      ),
    );
  }

  buildClubList() {
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
          itemCount: 14, //kaç tane olduğu veritabanından
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
              title: Text("Zınk"), //isimler veritabanından
              onTap:
                  () {}, //detay sayfasına aktarıcaz yine veritabanı bağlantısı
            );
          },
        )
      ],
    );
  }
}
