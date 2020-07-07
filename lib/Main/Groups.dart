import 'package:camppus/Main/GroupDetail.dart';
import 'package:camppus/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupsPage extends StatefulWidget {
  final String userId;

  GroupsPage({
    this.userId,
  });

  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  TextEditingController groupName = TextEditingController();

  final _firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(size.height * 0.02),
          child: FlatButton(
              color: Colors.blue,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text("Create new group"),
                          content: Wrap(
                            children: <Widget>[
                              TextField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: groupName,
                                decoration:
                                    InputDecoration(hintText: "Group name"),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel",
                                    style: TextStyle(color: Colors.red))),
                            FlatButton(
                                onPressed: () async {
                                  DocumentReference groupRef = _firestore
                                      .collection('groups')
                                      .document();
                                  CollectionReference groupListRef = _firestore
                                      .collection('users')
                                      .document(widget.userId)
                                      .collection('usergroups');
                                  await groupRef.setData({
                                    'name': groupName.text,
                                    'timestamp': DateTime.now(),
                                    'groupid': groupRef.documentID,
                                    'founder': widget.userId,
                                  });
                                  await groupRef
                                      .collection('memberlist')
                                      .document(widget.userId)
                                      .setData({});
                                  await groupListRef
                                      .document(groupRef.documentID)
                                      .setData({
                                    'name': groupName.text,
                                  });

                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Create",
                                  style: TextStyle(color: Colors.blue),
                                )),
                          ],
                        ));
              },
              child: Container(
                width: size.width * 0.8,
                height: size.height * 0.05,
                child: Center(
                  child: Text(
                    "Create new group",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )),
        ),
        StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('users')
                .document(widget.userId)
                .collection('usergroups')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.documents != null) {
                final groupList = snapshot.data.documents;
                List<Widget> groupWidgets = [];
                for (var group in groupList) {
                  groupWidgets.add(GestureDetector(
                    onTap: () {
                      pageScroll(
                          GroupDetail(
                            userId: widget.userId,
                            groupId: group.documentID,
                            groupName: group.data['name'],
                          ),
                          context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.02,
                          horizontal: size.height * 0.03),
                      child: Container(
                          width: size.width * 0.8,
                          height: size.height * 0.05,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 1)),
                          child: Center(child: Text(group.data['name']))),
                    ),
                  ));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: groupWidgets,
                );
              } else {
                return Container();
              }
            })
      ],
    );
  }
}
