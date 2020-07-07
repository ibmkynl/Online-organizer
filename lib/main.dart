import 'dart:io';

import 'package:camppus/constants.dart';
import 'package:camppus/login_pages/control_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(Camppus());

class Camppus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return MaterialApp(debugShowCheckedModeBanner: false, home: ControlPage());
  }
}
