import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_clubs_app/screens/profile.dart';
import 'package:student_clubs_app/screens/reset_password.dart';
import 'package:email_validator/email_validator.dart';

import '../utils/colors.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override

  //var _isLoggedin = false; //are we logged in (logindata ile değiştirdim)
  final _formKey = GlobalKey<FormState>();
  Future<void> _toSubmit() async {
    try {
      final isValid = _formKey.currentState
          .validate(); // will trgigger all validates inside text form
      FocusScope.of(context)
          .unfocus(); //keyboard closes after submitting the form
      if (isValid) {
        _formKey.currentState
            .save(); // will save email and password from the form
        print(email);
        print(password);

        final FirebaseUser user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: email,
          password: password,
        )).user;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Profile()));
      }

      // use the values to send login request to firebase

    }catch (e) {
      // throw the Firebase AuthException that we caught

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Email or Password is wrong"),
      ));

    }
  }

  String email;
  String password;
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

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
            onPressed: () {
              FirebaseAuth.instance.currentUser().then((firebaseUser) {
                if (firebaseUser == null) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Login()));
                } else {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Profile()));
                }
              });
            },
          ),
        ],
      ),
      body: ListView(children: [
        Padding(
          padding: EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
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
        ),
      ]),
    );
  }

  buildEmailField() {
    return TextFormField(
      key: ValueKey('email'),
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      decoration: InputDecoration(
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.mail)),
      autofillHints: [AutofillHints.email],
      onSaved: (value) {
        email = value;
      },
      validator: (value) {
        if (value.isEmpty || !value.contains('@')) {
          return "please enter valid email address";
        }
        return null;
      },
    );
  }

  buildPasswordField() {
    return TextFormField(
      key: ValueKey('password'),
      controller: passwordController,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          prefixIcon: Icon(Icons.password)),
      onSaved: (value) {
        password = value;
      },
      validator: (value) {
        if (value.isEmpty || value.length < 8) {
          return "enter a longer password ( 8 character)";
        }
        return null;
      },
    );
  }

  buildLoginButton() {
    return Builder(
      builder: (context) {
        return ElevatedButton(
          onPressed: () {
            email = emailController.text;
            password = passwordController.text;
            _toSubmit();
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
} //end
