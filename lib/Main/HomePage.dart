import 'package:camppus/Main/Groups.dart';
import 'package:camppus/Main/MyTasks.dart';
import 'package:camppus/constants.dart';
import 'package:camppus/login_pages/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String userId;

  HomePage({
    this.userId,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      GroupsPage(
        userId: widget.userId,
      ),
      MyTasksPage(
        userId: widget.userId,
      ),
    ];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TabBar(
                tabs: <Widget>[
                  Tab(
                    text: "Groups",
                  ),
                  Tab(
                    text: "My Tasks",
                  ),
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          children: pages,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text("Do you want to log out?"),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "No",
                              style: TextStyle(color: Colors.red),
                            )),
                        FlatButton(
                            onPressed: () {
                              _auth.signOut();
                              pageScroll(LoginPage(), context);
                            },
                            child: Text(
                              "Yes",
                              style: TextStyle(color: Colors.blue),
                            ))
                      ],
                    ));
          },
          child: Icon(Icons.exit_to_app),
        ),
      ),
    );
  }
}
