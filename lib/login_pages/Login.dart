import 'package:camppus/Main/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool controller() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty)
      return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Text("Login"),
      ),
      body: Column(
        children: <Widget>[
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
          FlatButton(
              color: controller() ? Colors.blue : Colors.grey,
              splashColor: Colors.white,
              onPressed: () async {
                if (controller()) {
                  try {
                    _auth
                        .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text)
                        .then((value) {
                      pageScroll(HomePage(userId: value.user.uid), context);
                    });
                  } catch (e) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        e,
                        style: kSnackBarStyle,
                      ),
                      backgroundColor: kAppBodyBackgroundColor,
                    ));
                  }
                }
              },
              child: Container(
                width: size.width * 0.8,
                height: size.height * 0.05,
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
