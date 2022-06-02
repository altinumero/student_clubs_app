import 'package:flutter/material.dart';

import '../utils/colors.dart';

class EventDetail extends StatefulWidget {
  const EventDetail({Key key}) : super(key: key);

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Appcolors.mainColor,
        centerTitle: true,
        title: Text("Event Detail"),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed:
                () {}, //Burada eğer kullanıcı giriş yapmışsa profil sayfasına yoksa logine gidecek
          ),
        ],
      ),
      body: ListView(
        children: [
          sizedBox(16),
          buildDetails(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean bibendum eros eu iaculis porttitor. Vestibulum elementum, ipsum non cursus aliquam, enim mauris vehicula mauris, ac imperdiet purus libero at justo. Integer mollis orci pretium, semper ligula vel, commodo erat. Donec id orci eget diam facilisis tincidunt. Fusce laoreet sem a tortor scelerisque, et lacinia ante rhoncus. Quisque massa leo, fringilla id ex sit amet, rutrum faucibus lacus. Ut ultrices est lorem, non pulvinar dui efficitur vitae. Fusce rhoncus vulputate arcu, ac blandit sapien iaculis non. ",style: TextStyle(color: Appcolors.textColor),),
          ),
          sizedBox(16),
          Visibility(
              visible: (3 + 3 == 6),
              child: Container(
                child: buildElevatedButton(
                    "Join Event", Appcolors.joinColor, () {}),
              )),
          Visibility(
              visible: (3 + 3 == 7),
              child: Container(
                child: buildElevatedButton(
                    "Leave Event", Appcolors.warningColor, () {}),
              )),
        ],
      ),
    );
  }

  sizedBox(double i) {
    return SizedBox(height: i);
  }

  buildDetails() {
    return Column(
      children: [
        Text("Event Name", //veri tabanından isim
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Appcolors.textColor)),
        sizedBox(4),
        Divider(
          color: Appcolors.textColor,
        ),
        sizedBox(4),
        Text(
          "Event Owner", //veri tabanından mail
          style: TextStyle(color: Appcolors.textColor),
        ),
        sizedBox(4),
        Divider(
          color: Appcolors.textColor,
        ),
        sizedBox(4),
        Text(
          "Event Place : LMF317", //veri tabanından
          style: TextStyle(color: Appcolors.textColor),
        ),
        sizedBox(4),
        Divider(
          color: Appcolors.textColor,
        ),
        sizedBox(4)
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
}
