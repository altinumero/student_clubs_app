import 'package:flutter/material.dart';
import 'package:student_clubs_app/screens/reset_password.dart';
import 'package:email_validator/email_validator.dart';

import '../utils/colors.dart';

class Login extends StatelessWidget {
  String? email;
  String? password;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.mainColor,
        centerTitle: true,
        title: Text("Login"),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed:
                () {}, //Burada eğer kullanıcı giriş yapmışsa profil sayfasına yoksa logine gidecek
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            buildEmailField(),
            SizedBox(
              height: 8,
            ),
            buildPasswordField(),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildLoginButton(),
                buildResetPasswordButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildEmailField() {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.mail)),
      autofillHints: [AutofillHints.email],
      validator: (value) {},
    );
  }

  buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          prefixIcon: Icon(Icons.password)),
      validator: (value) {},
    );
  }

  buildLoginButton() {
    return Builder(
      builder: (context) {
        return ElevatedButton(
          onPressed: () {
            email = emailController.text;
            password = passwordController.text;
            Navigator.pop(context);
          },
          child: Text("Login"),
          style: ElevatedButton.styleFrom(
              primary: Appcolors.mainColor, onPrimary: Appcolors.textColor),
        );
      },
    );
  }

  buildResetPasswordButton() {
    return Builder(builder: (context) {
      return ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ResetPassword()),
          );
        },
        child: Text("Reset Password"),
        style: ElevatedButton.styleFrom(
            primary: Appcolors.mainColor, onPrimary: Appcolors.textColor),
      );
    });
  }
}
