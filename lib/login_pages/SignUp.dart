import 'package:camppus/constants.dart';
import 'package:camppus/login_pages/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  bool controller() {
    if (nameController.text.isEmpty ||
        surnameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        rePasswordController.text.isEmpty) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Text("Sign Up"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(size.width * 0.03),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: "Name"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size.width * 0.03),
            child: TextField(
              controller: surnameController,
              decoration: InputDecoration(hintText: "Surname"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size.width * 0.03),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: "Email"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size.width * 0.03),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(hintText: "Password"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size.width * 0.03),
            child: TextField(
              controller: rePasswordController,
              obscureText: true,
              decoration: InputDecoration(hintText: "Re-Password"),
            ),
          ),
          FlatButton(
              color: controller() ? Colors.blue : Colors.grey,
              splashColor: Colors.white,
              onPressed: () async {
                if (controller()) {
                  try {
                    final user = await _auth.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text);

                    if (user != null) {
                      user.user.sendEmailVerification();
                      Firestore.instance
                          .collection('users')
                          .document(user.user.uid)
                          .setData({
                        "uid": user.user.uid,
                        "name": nameController.text,
                        "surname": surnameController.text,
                        "email": emailController.text,
                        "creatingtime": DateTime.now(),
                      });
                      pageScroll(LoginPage(), context);
                    }
                  } catch (e) {
                    switch (e.code) {
                      case 'ERROR_EMAIL_ALREADY_IN_USE':
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "This email is already in use",
                            style: kSnackBarStyle,
                          ),
                        ));
                        break;
                      case 'FirebaseException':
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Check your connection",
                            style: kSnackBarStyle,
                          ),
                        ));
                        break;
                      default:
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Something goes wrong",
                            style: kSnackBarStyle,
                          ),
                        ));
                        break;
                    }
                  }
                }
              },
              child: Container(
                width: size.width * 0.8,
                height: size.height * 0.05,
                child: Center(
                  child: Text(
                    "Create an Account",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("You already have account ? "),
              GestureDetector(
                onTap: () {
                  pageScroll(LoginPage(), context);
                },
                child: Text("Login here",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
