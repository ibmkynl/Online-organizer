import 'package:camppus/Main/GroupDetail.dart';
import 'package:camppus/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TaskDetail extends StatefulWidget {
  final String groupId,
      taskId,
      userId,
      groupName,
      toName,
      toId,
      taskStatus,
      taskDescription,
      taskTitle,
      fromId;
  final Timestamp taskDate;

  TaskDetail({
    this.groupId,
    this.userId,
    this.taskId,
    this.groupName,
    this.fromId,
    this.taskDate,
    this.taskDescription,
    this.taskStatus,
    this.taskTitle,
    this.toId,
    this.toName,
  });

  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  final _firestore = Firestore.instance;

  String assignedMember, assignedMemberId;
  DateTime endDate;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  bool controller() {
    if (widget.userId == widget.fromId) return true;
    return false;
  }

  bool saveChanges() {
    if (nameController.text != widget.taskTitle ||
        descController.text != widget.taskDescription ||
        widget.taskDate.toDate() != endDate ||
        assignedMember != widget.toName) return true;
    return false;
  }

  @override
  void initState() {
    nameController.text = widget.taskTitle;
    descController.text = widget.taskDescription;
    endDate = widget.taskDate.toDate();
    assignedMember = widget.toName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.taskTitle + " - Edit task"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(size.width * 0.03),
                child: TextField(
                  enabled: controller(),
                  controller: nameController,
                  decoration: InputDecoration(hintText: "Task name"),
                ),
              ),
              Container(
                  width: size.width,
                  child: FlatButton(
                      onPressed: () {
                        if (controller()) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Select a member"),
                                    content: StreamBuilder<QuerySnapshot>(
                                        stream: _firestore
                                            .collection('groups')
                                            .document(widget.groupId)
                                            .collection('memberlist')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.data != null &&
                                              snapshot.hasData) {
                                            final users =
                                                snapshot.data.documents;
                                            List<Widget> userWidget = [];
                                            for (var user in users) {
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
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    size.width *
                                                                        0.04,
                                                                vertical:
                                                                    size.height *
                                                                        0.01),
                                                        child: FlatButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              assignedMemberId =
                                                                  snapshot.data
                                                                      .documentID;
                                                              assignedMember = snapshot
                                                                          .data[
                                                                      'name'] +
                                                                  " " +
                                                                  snapshot.data[
                                                                      'surname'];
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal:
                                                                    size.width *
                                                                        0.04,
                                                                vertical:
                                                                    size.height *
                                                                        0.02),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .blue,
                                                                    width: 1)),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  Icons.person,
                                                                  color: Colors
                                                                      .blue,
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
                                            return Column(
                                              children: userWidget,
                                            );
                                          }
                                          return Container();
                                        }),
                                  ));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Assign to:"),
                          Text(
                            assignedMember != null
                                ? assignedMember
                                : "Select a member",
                            style: TextStyle(
                                color: assignedMember != null
                                    ? Colors.blue
                                    : Colors.black),
                          )
                        ],
                      ))),
              Padding(
                padding: EdgeInsets.all(size.width * 0.03),
                child: TextField(
                  enabled: controller(),
                  controller: descController,
                  maxLines: 10,
                  decoration: InputDecoration(hintText: "Task description"),
                ),
              ),
              Container(
                  width: size.width,
                  child: FlatButton(
                      onPressed: () {
                        if (controller()) {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              maxTime: DateTime(2025, 12, 30),
                              onConfirm: (date) {
                            setState(() {
                              endDate = date;
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("End date:"),
                          Text(
                            endDate != null
                                ? endDate.month.toString() +
                                    "/" +
                                    endDate.day.toString() +
                                    "/" +
                                    endDate.year.toString()
                                : "DD/MM/YYYY",
                            style: TextStyle(
                                color: endDate != null
                                    ? Colors.blue
                                    : Colors.black),
                          )
                        ],
                      ))),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
            child: controller()
                ? Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.03),
                          child: FlatButton(
                              color: Colors.red,
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: Text(
                                              "Do you want to delete this task?"),
                                          actions: <Widget>[
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )),
                                            FlatButton(
                                                onPressed: () async {
                                                  {
                                                    DocumentReference taskRef =
                                                        _firestore
                                                            .collection(
                                                                'groups')
                                                            .document(
                                                                widget.groupId)
                                                            .collection('tasks')
                                                            .document(
                                                                widget.taskId);

                                                    await _firestore
                                                        .collection('users')
                                                        .document(widget.toId)
                                                        .collection('tasks')
                                                        .document(widget.taskId)
                                                        .delete();
                                                    await _firestore
                                                        .collection('users')
                                                        .document(widget.fromId)
                                                        .collection(
                                                            'assignedtasks')
                                                        .document(widget.taskId)
                                                        .delete();
                                                    await taskRef.delete();
                                                  }
                                                },
                                                child: Text("Yes")),
                                          ],
                                        ));
                              },
                              child: Text(
                                "Cancel task",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.03),
                          child: FlatButton(
                              color: saveChanges() ? Colors.blue : Colors.grey,
                              onPressed: () async {
                                if (saveChanges()) {
                                  DocumentReference taskRef = _firestore
                                      .collection('groups')
                                      .document(widget.groupId)
                                      .collection('tasks')
                                      .document(widget.taskId);
                                  await taskRef.updateData({
                                    'from': widget.userId,
                                    'groupname': widget.groupName,
                                    'groupId': widget.groupId,
                                    'toName': assignedMember,
                                    'toId': assignedMemberId,
                                    'title': nameController.text,
                                    'desc': descController.text,
                                    'startdate': DateTime.now(),
                                    'enddate': endDate,
                                    'status': 'Active'
                                  });
                                  await _firestore
                                      .collection('users')
                                      .document(widget.toId)
                                      .collection('tasks')
                                      .document(taskRef.documentID)
                                      .updateData({
                                    'from': widget.userId,
                                    'groupname': widget.groupName,
                                    'groupId': widget.groupId,
                                    'toName': assignedMember,
                                    'toId': widget.toId,
                                    'title': nameController.text,
                                    'desc': descController.text,
                                    'startdate': DateTime.now(),
                                    'enddate': endDate,
                                    'status': 'Active'
                                  });
                                  await _firestore
                                      .collection('users')
                                      .document(widget.fromId)
                                      .collection('assignedtasks')
                                      .document(taskRef.documentID)
                                      .updateData({
                                    'from': widget.userId,
                                    'groupname': widget.groupName,
                                    'groupId': widget.groupId,
                                    'toName': assignedMember,
                                    'toId': widget.toId,
                                    'title': nameController.text,
                                    'desc': descController.text,
                                    'startdate': DateTime.now(),
                                    'enddate': endDate,
                                    'status': 'Active'
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                "Save changes",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ),
                    ],
                  )
                : Container(
                    width: size.width * 0.85,
                    child: FlatButton(
                        color: Colors.blue,
                        onPressed: () async {
                          print(widget.taskId);
                          DocumentReference taskRef = _firestore
                              .collection('groups')
                              .document(widget.groupId)
                              .collection('tasks')
                              .document(widget.taskId);
                          await taskRef.updateData({'status': 'Completed'});
                          await _firestore
                              .collection('users')
                              .document(widget.fromId)
                              .collection('tasks')
                              .document(taskRef.documentID)
                              .updateData({'status': 'Completed'});
                          await _firestore
                              .collection('users')
                              .document(widget.toId)
                              .collection('assignedtasks')
                              .document(taskRef.documentID)
                              .updateData({'status': 'Completed'});
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Completed!",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
          ),
        ],
      ),
    );
  }
}
