import 'package:flutter/material.dart';

import '../home/main_club_page.dart';
import '../utils/colors.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.mainColor,
        centerTitle: true,
        title: Text("Reset Password"),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainClubPage()));
            },
          ),
        ],
      ),
    );
  }
}
