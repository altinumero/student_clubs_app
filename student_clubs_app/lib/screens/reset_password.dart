import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../home/main_club_page.dart';
import '../utils/colors.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController emailController = TextEditingController();

  String email;

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
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 32,
              ),
              buildEmailField(),
              SizedBox(
                height: 32,
              ),
              buildResetButton(),
            ],
          ),
        ),
      ),
    );
  }

  buildEmailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      cursorColor: Appcolors.textColor,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          labelText: "Email",
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.mail)),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (email) => email != null && !EmailValidator.validate(email)
          ? "Enter a valid email"
          : null,
    );
  }

  buildResetButton() {
    return ElevatedButton(
      onPressed: resetPassword,
      child: Text("Reset Password"),
      style: ElevatedButton.styleFrom(
          primary: Appcolors.mainColor, onPrimary: Appcolors.textColor),
    );
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Fluttertoast.showToast(
        msg: "Mail Sent",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}