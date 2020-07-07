import 'package:camppus/Main/TaskDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class MyTasksPage extends StatefulWidget {
  final String userId;

  MyTasksPage({
    this.userId,
  });

  @override
  _MyTasksPageState createState() => _MyTasksPageState();
}

class _MyTasksPageState extends State<MyTasksPage> {
  bool isMyTask = true;
  final _firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(size.height * 0.02),
            child: FlatButton(
                color: Colors.blue,
                onPressed: () {
                  setState(() {
                    isMyTask = !isMyTask;
                  });
                },
                child: Container(
                  width: size.width * 0.8,
                  height: size.height * 0.05,
                  child: Center(
                    child: Text(
                      isMyTask ? "Go to assigned tasks" : "Go to my tasks",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )),
          ),
          Padding(
            padding: EdgeInsets.all(size.height * 0.015),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  isMyTask ? "My tasks" : "Assigned tasks",
                  style: TextStyle(fontSize: size.height * 0.04),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('users')
                        .document(widget.userId)
                        .collection(isMyTask ? 'tasks' : 'assignedtasks')
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
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                    }),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .document(widget.userId)
                  .collection(isMyTask ? 'tasks' : 'assignedtasks')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final tasks = snapshot.data.documents;

                  List<Widget> myCompleted = [];
                  List<Widget> myActive = [];
                  for (var task in tasks) {
                    if (task.data['status'] == 'Active') {
                      myActive.add(GestureDetector(
                        onTap: () {
                          if (widget.userId == task.data['from'] ||
                              widget.userId == task.data['toId']) {
                            pageScroll(
                                TaskDetail(
                                  taskId: task.documentID,
                                  groupId: task.data['groupId'],
                                  userId: widget.userId,
                                  fromId: task.data['from'],
                                  taskDate: task.data['enddate'],
                                  taskDescription: task.data['desc'],
                                  taskStatus: task.data['status'],
                                  taskTitle: task.data['title'],
                                  toId: task.data['toId'],
                                  toName: task.data['toName'],
                                  groupName: task.data['groupName'],
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
                      myCompleted.add(Padding(
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
                        children: myActive,
                      ),
                      myCompleted.isNotEmpty
                          ? Center(
                              child: Text(
                              "Finished tasks",
                              style: TextStyle(fontSize: size.height * 0.04),
                            ))
                          : Container(),
                      Column(
                        children: myCompleted,
                      ),
                    ],
                  );
                }
                return Container();
              })
        ],
      ),
    );
  }
}
