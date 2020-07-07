import 'package:camppus/Main/HomePage.dart';
import 'package:camppus/login_pages/SignUp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camppus/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

final _auth = FirebaseAuth.instance;

final _firestore = Firestore.instance;

class _ControlPageState extends State<ControlPage> {
  @override
  void initState() {
    setState(() {
      _auth.currentUser().then((currentUser) {
        if (currentUser == null) {
          print("here");
          pageScroll(SignUpPage(), context);
        } else {
          print(currentUser.uid);
          _firestore
              .collection('users')
              .document(currentUser.uid)
              .get()
              .then((DocumentSnapshot result) {
            pageScroll(
                HomePage(
                  userId: currentUser.uid,
                ),
                context);
          }).catchError((err) => print(err));
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Text(
              "Online Organizer",
              style: TextStyle(color: Colors.blue, fontSize: size.width * 0.2),
            ),
          ),
        ),
      ),
    );
  }
}
