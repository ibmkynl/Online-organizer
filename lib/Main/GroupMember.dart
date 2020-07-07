import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupMember extends StatefulWidget {
  final String groupId, userId, groupName;

  GroupMember({
    this.userId,
    this.groupId,
    this.groupName,
  });

  @override
  _GroupMemberState createState() => _GroupMemberState();
}

class _GroupMemberState extends State<GroupMember> {
  final _firestore = Firestore.instance;
  TextEditingController emailController = TextEditingController();

  bool isAdmin = false;

  @override
  void initState() {
    _firestore
        .collection('groups')
        .document(widget.groupId)
        .get()
        .then((groupData) {
      if (groupData.data['founder'] == widget.userId)
        setState(() {
          isAdmin = true;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String memberName = "";
    String memberId = "";
    emailController.clear();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Member list"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(size.height * 0.02),
            child: FlatButton(
                color: Colors.blue,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => StatefulBuilder(
                            builder: (context, setState) => AlertDialog(
                              backgroundColor: Colors.white,
                              title: Text("Add new member"),
                              content: Wrap(
                                children: <Widget>[
                                  TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                        hintText: "Please enter user email"),
                                  ),
                                  memberName.isEmpty
                                      ? Container()
                                      : Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: size.height * 0.02),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(memberName),
                                              memberName != "User not found"
                                                  ? IconButton(
                                                      icon: Icon(
                                                        Icons.add,
                                                        color: Colors.blue,
                                                      ),
                                                      onPressed: () async {
                                                        await _firestore
                                                            .collection('users')
                                                            .document(memberId)
                                                            .collection(
                                                                'usergroups')
                                                            .document(
                                                                widget.groupId)
                                                            .setData({
                                                          'name':
                                                              widget.groupName
                                                        });

                                                        await _firestore
                                                            .collection(
                                                                'groups')
                                                            .document(
                                                                widget.groupId)
                                                            .collection(
                                                                'memberlist')
                                                            .document(memberId)
                                                            .setData({});

                                                        Navigator.pop(context);
                                                      })
                                                  : Container()
                                            ],
                                          )),
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
                                      _firestore
                                          .collection('users')
                                          .getDocuments()
                                          .then((docs) {
                                        for (var user in docs.documents) {
                                          if (user.data['email'] ==
                                              emailController.text) {
                                            setState(() {
                                              memberName = user.data['name'] +
                                                  " " +
                                                  user.data['surname'];
                                              print(user.documentID);
                                              memberId = user.documentID;
                                            });
                                            break;
                                          } else {
                                            setState(() {
                                              memberName = "User not found";
                                            });
                                          }
                                        }
                                      });
                                    },
                                    child: Text(
                                      "Search",
                                      style: TextStyle(color: Colors.blue),
                                    )),
                              ],
                            ),
                          ));
                },
                child: Container(
                  width: size.width * 0.8,
                  height: size.height * 0.05,
                  child: Center(
                    child: Text(
                      "Add new member",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )),
          ),
          Center(
              child: Text(
            "Member List",
            style: TextStyle(fontSize: size.height * 0.04),
          )),
          StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('groups')
                  .document(widget.groupId)
                  .collection('memberlist')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data != null && snapshot.hasData) {
                  final users = snapshot.data.documents;
                  List<Widget> userWidget = [];
                  for (var user in users) {
                    userWidget.add(StreamBuilder<DocumentSnapshot>(
                        stream: _firestore
                            .collection('users')
                            .document(user.documentID)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.04,
                                  vertical: size.height * 0.01),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.04,
                                    vertical: size.height * 0.02),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blue, width: 1)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Icon(
                                      Icons.person,
                                      color: Colors.blue,
                                    ),
                                    Text(
                                      snapshot.data['name'] +
                                          " " +
                                          snapshot.data['surname'],
                                      style: TextStyle(
                                          fontSize: size.height * 0.02),
                                    ),
                                    isAdmin
                                        ? widget.userId ==
                                                snapshot.data.documentID
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.transparent,
                                                ),
                                              )
                                            : IconButton(
                                                padding: EdgeInsets.all(0),
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                title: Text(
                                                                    "Do you want to remove the member from the group"),
                                                                actions: <
                                                                    Widget>[
                                                                  FlatButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: Text(
                                                                          "No",
                                                                          style:
                                                                              TextStyle(color: Colors.red))),
                                                                  FlatButton(
                                                                      onPressed:
                                                                          () async {
                                                                        await _firestore
                                                                            .collection('users')
                                                                            .document(snapshot.data.documentID)
                                                                            .collection('usergroups')
                                                                            .document(widget.groupId)
                                                                            .delete();

                                                                        await _firestore
                                                                            .collection('groups')
                                                                            .document(widget.groupId)
                                                                            .collection('memberlist')
                                                                            .document(snapshot.data.documentID)
                                                                            .delete();
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        "Yes",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                      )),
                                                                ],
                                                              ));
                                                })
                                        : Container()
                                  ],
                                ),
                              ),
                            );
                          }
                          return Container();
                        }));
                  }
                  return Column(
                    children: userWidget,
                  );
                }
                return Container();
              })
        ],
      ),
    );
  }
}
