import 'package:flutter/material.dart';
import 'package:student_clubs_app/screens/event_detail.dart';

import '../utils/colors.dart';

class ClubDetail extends StatefulWidget {
  const ClubDetail({Key? key}) : super(key: key);

  @override
  State<ClubDetail> createState() => _ClubDetailState();
}

class _ClubDetailState extends State<ClubDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Appcolors.mainColor,
        centerTitle: true,
        title: Text("Club Detail"),
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
          sizedBox(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildClubImage(),
              Column(
                children: [
                  Text("Canalp Cansever"),
                  Text("Sezin Eliçalışkan"),
                  Text("data"),
                  Text("data"),
                  Text("data"),
                  Text("data"),
                  Text("data"),
                  Text("data"),
                ],
              ),
              SizedBox(
                width: 6,
              )
            ],
          ),
          sizedBox(16),
          Container(
            decoration: BoxDecoration(
              border: Border.all()
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Description burada olacak, neler oluyo neler yapılıyor vs yazılacak.Yazı biraz uzasın"),
            ),
          ),
          sizedBox(16),
          Visibility(
              visible: (3 + 3 == 6),
              child: Container(
                child: buildElevatedButton(
                    "Join Club", Appcolors.joinColor, () {}),
              )),
          Visibility(
              visible: (3 + 3 == 6),
              child: Container(
                child: buildElevatedButton(
                    "Leave Club", Appcolors.warningColor, () {}),
              )),
          Divider(
            color: Appcolors.textColor,
          ),
          sizedBox(4),
          buildName(),
          sizedBox(4),
          buildEventList()
        ],
      ),
      bottomNavigationBar: Visibility(
        visible: (3 + 3 == 6),
        child: Container(
          child:
              buildElevatedButton("Remove Club", Appcolors.warningColor, () {}),
        ),
      ),
    );
  }

  sizedBox(double i) {
    return SizedBox(height: i);
  }

  buildName() {
    return Column(
      children: [
        Text("Club İsmi", //veri tabanından isim
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        sizedBox(4),
        Divider(
          color: Appcolors.textColor,
        ),
        sizedBox(4),
        Text(
          "Club's Events", //veri tabanından mail
          style: TextStyle(color: Appcolors.textColor),
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
                  "Zınk"), //isimler veritabanından //Text(this.products![position].name!),
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
      onPressed: onClicked, //logout için veritabanı fonksiyonu
      child: Text(text),
    );
  }

  buildClubImage() {
    return ClipOval(
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
    );
  }
}
