import 'package:camppus/Main/GroupMember.dart';
import 'package:camppus/Main/HomePage.dart';
import 'package:camppus/Main/NewTask.dart';
import 'package:camppus/Main/TaskDetail.dart';
import 'package:camppus/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupDetail extends StatefulWidget {
  final String userId, groupId, groupName;

  GroupDetail({
    this.userId,
    this.groupId,
    this.groupName,
  });

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  final _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.groupName),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
            child: IconButton(
                icon: Icon(Icons.group_add),
                onPressed: () {
                  pageScroll(
                      GroupMember(
                        groupId: widget.groupId,
                        userId: widget.userId,
                        groupName: widget.groupName,
                      ),
                      context);
                }),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(size.height * 0.02),
              child: FlatButton(
                  color: Colors.blue,
                  onPressed: () {
                    pageScroll(
                        NewTask(
                          userId: widget.userId,
                          groupName: widget.groupName,
                          groupId: widget.groupId,
                        ),
                        context);
                  },
                  child: Container(
                    width: size.width * 0.8,
                    height: size.height * 0.05,
                    child: Center(
                      child: Text(
                        "Create new task",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "Task List",
                  style: TextStyle(fontSize: size.height * 0.04),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('groups')
                        .document(widget.groupId)
                        .collection('tasks')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        int active = 0, completed = 0, failed = 0;
                        final tasks = snapshot.data.documents;
                        for (var task in tasks) {
                          if (task.data['status'] == 'Active') active++;
                          if (task.data['status'] == 'Failed') failed++;
                          if (task.data['status'] == 'Completed') completed++;
                        }
                        return Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.timelapse,
                                  color: Colors.blue,
                                ),
                                Text(active.toString())
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.done,
                                  color: Colors.grey,
                                ),
                                Text(completed.toString())
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                ),
                                Text(failed.toString())
                              ],
                            )
                          ],
                        );
                      }
                      return Container();
                    })
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('groups')
                  .document(widget.groupId)
                  .collection('tasks')
                  .orderBy('enddate', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final tasks = snapshot.data.documents;

                  List<Widget> activeTaskWidget = [];
                  List<Widget> completedTaskWidget = [];
                  for (var task in tasks) {
                    if (task.data['status'] == 'Active') {
                      activeTaskWidget.add(GestureDetector(
                        onTap: () {
                          if (widget.userId == task.data['from'] ||
                              widget.userId == task.data['toId']) {
                            pageScroll(
                                TaskDetail(
                                  taskId: task.documentID,
                                  groupId: widget.groupId,
                                  userId: widget.userId,
                                  fromId: task.data['from'],
                                  taskDate: task.data['enddate'],
                                  taskDescription: task.data['desc'],
                                  taskStatus: task.data['status'],
                                  taskTitle: task.data['title'],
                                  toId: task.data['toId'],
                                  toName: task.data['toName'],
                                  groupName: widget.groupName,
                                ),
                                context);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.01),
                          child: Container(
                            width: size.width,
                            color: Colors.blue,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.all(size.width * 0.02),
                                      child: Text(
                                        task.data['title'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.height * 0.025),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.timelapse,
                                          color: Colors.white,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.all(size.width * 0.02),
                                          child: Text(
                                            task.data['status'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: size.height * 0.025),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.01,
                                      horizontal: size.width * 0.01),
                                  child: Container(
                                    width: size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            size.height * 0.02)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(task.data['desc']),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.all(size.width * 0.02),
                                      child: Text(
                                        task.data['toName'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.height * 0.025),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.all(size.width * 0.02),
                                      child: Text(
                                        task.data['enddate']
                                            .toDate()
                                            .toString()
                                            .substring(0, 10),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.height * 0.025),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ));
                    } else {
                      completedTaskWidget.add(Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.01),
                        child: Container(
                          width: size.width,
                          color: task.data['status'] == 'Completed'
                              ? Colors.grey
                              : Colors.red,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(size.width * 0.02),
                                    child: Text(
                                      task.data['title'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.height * 0.025),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        task.data['status'] == 'Completed'
                                            ? Icons.done
                                            : Icons.clear,
                                        color: Colors.white,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.all(size.width * 0.02),
                                        child: Text(
                                          task.data['status'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: size.height * 0.025),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.01,
                                    horizontal: size.width * 0.01),
                                child: Container(
                                  width: size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          size.height * 0.02)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(task.data['desc']),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(size.width * 0.02),
                                    child: Text(
                                      task.data['toName'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.height * 0.025),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(size.width * 0.02),
                                    child: Text(
                                      task.data['enddate']
                                          .toDate()
                                          .toString()
                                          .substring(0, 10),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.height * 0.025),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ));
                    }
                  }
                  return Column(
                    children: <Widget>[
                      Column(
                        children: activeTaskWidget,
                      ),
                      completedTaskWidget.isNotEmpty
                          ? Center(
                              child: Text(
                              "Finished tasks",
                              style: TextStyle(fontSize: size.height * 0.04),
                            ))
                          : Container(),
                      Column(
                        children: completedTaskWidget,
                      ),
                    ],
                  );
                }

                return Container();
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _firestore
              .collection('groups')
              .document(widget.groupId)
              .collection('memberlist')
              .getDocuments()
              .then((members) async {
            members.documents.length < 2
                ? showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text("Do you want to delete the group"),
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
                                onPressed: () async {
                                  await _firestore
                                      .collection('groups')
                                      .document(widget.groupId)
                                      .collection('memberlist')
                                      .getDocuments()
                                      .then((users) {
                                    users.documents.forEach((user) async {
                                      await _firestore
                                          .collection('users')
                                          .document(user.documentID)
                                          .collection('usergroups')
                                          .document(widget.groupId)
                                          .delete();
                                    });
                                  });

                                  await _firestore
                                      .collection('groups')
                                      .document(widget.groupId)
                                      .delete();

                                  pageScroll(
                                      HomePage(userId: widget.userId), context);
                                },
                                child: Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.blue),
                                ))
                          ],
                        ))
                : showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text("Select new admin to quit the group"),
                          content: StreamBuilder<QuerySnapshot>(
                              stream: _firestore
                                  .collection('groups')
                                  .document(widget.groupId)
                                  .collection('memberlist')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null && snapshot.hasData) {
                                  print("here");
                                  final users = snapshot.data.documents;
                                  List<Widget> userWidget = [];
                                  for (var user in users) {
                                    if (user.documentID != widget.userId) {
                                      userWidget.add(StreamBuilder<
                                              DocumentSnapshot>(
                                          stream: _firestore
                                              .collection('users')
                                              .document(user.documentID)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data != null) {
                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        size.width * 0.04,
                                                    vertical:
                                                        size.height * 0.01),
                                                child: FlatButton(
                                                  onPressed: () async {
                                                    await _firestore
                                                        .collection('groups')
                                                        .document(
                                                            widget.groupId)
                                                        .updateData({
                                                      'founder': snapshot
                                                          .data.documentID,
                                                    });

                                                    await _firestore
                                                        .collection('users')
                                                        .document(widget.userId)
                                                        .collection(
                                                            'usergroups')
                                                        .document(
                                                            widget.groupId)
                                                        .delete();
                                                    pageScroll(
                                                        HomePage(
                                                          userId: widget.userId,
                                                        ),
                                                        context);
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                size.width *
                                                                    0.04,
                                                            vertical:
                                                                size.height *
                                                                    0.02),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.blue,
                                                            width: 1)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.person,
                                                          color: Colors.blue,
                                                        ),
                                                        Text(
                                                          snapshot.data[
                                                                  'name'] +
                                                              " " +
                                                              snapshot.data[
                                                                  'surname'],
                                                          style: TextStyle(
                                                              fontSize:
                                                                  size.height *
                                                                      0.02),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            return Container();
                                          }));
                                    }
                                  }
                                  return Column(
                                    children: userWidget,
                                  );
                                }
                                return Container();
                              }),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.red),
                                ))
                          ],
                        ));
          });
        },
        child: Icon(Icons.delete),
      ),
    );
  }
}
