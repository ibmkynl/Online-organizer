import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class NewTask extends StatefulWidget {
  final String userId, groupId, groupName;

  NewTask({
    this.userId,
    this.groupId,
    this.groupName,
  });

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final _firestore = Firestore.instance;
  String assignedMember, assignedMemberId;
  DateTime endDate;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  bool controller() {
    if (nameController.text.isNotEmpty &&
        descController.text.isNotEmpty &&
        assignedMember != null &&
        endDate != null) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.groupName + " - New task"),
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
                  controller: nameController,
                  decoration: InputDecoration(hintText: "Task name"),
                ),
              ),
              Container(
                  width: size.width,
                  child: FlatButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text("Select a member"),
                                  content: StreamBuilder<QuerySnapshot>(
                                      stream: _firestore
                                          .collection('groups').document(widget.groupId).collection('memberlist').snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null &&
                                            snapshot.hasData) {
                                          final users = snapshot.data.documents;
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
                                                      padding:
                                                          EdgeInsets.symmetric(horizontal: size.width *0.04,vertical:size.height *0.01),
                                                      child: FlatButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            assignedMemberId =snapshot.data.documentID;
                                                            assignedMember = snapshot.data['name'] +" " +snapshot.data['surname'];
                                                          });
                                                          Navigator.pop(context);
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.symmetric(horizontal:size.width *0.04,vertical:size.height *0.02),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors.blue,width: 1)),
                                                          child: Row(
                                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                            mainAxisSize:MainAxisSize.max,
                                                            children: <Widget>[
                                                              Icon(Icons.person,color:Colors.blue,),
                                                              Text(snapshot.data['name'] +" " +snapshot.data['surname'],style: TextStyle(fontSize:size.height *0.02),
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
                  controller: descController,
                  maxLines: 10,
                  decoration: InputDecoration(hintText: "Task description"),
                ),
              ),
              Container(
                  width: size.width,
                  child: FlatButton(
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            maxTime: DateTime(2025, 12, 30), onConfirm: (date) {
                          setState(() {
                            endDate = date;
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
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
            child: FlatButton(
                onPressed: () async {
                  DocumentReference taskRef = _firestore
                      .collection('groups')
                      .document(widget.groupId)
                      .collection('tasks')
                      .document();
                  await taskRef.setData({
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
                      .document(assignedMemberId)
                      .collection('tasks')
                      .document(taskRef.documentID)
                      .setData({
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
                      .document(widget.userId)
                      .collection('assignedtasks')
                      .document(taskRef.documentID)
                      .setData({
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

                  Navigator.pop(context);
                },
                child: Container(
                  color: controller() ? Colors.blue : Colors.grey,
                  width: size.width,
                  height: size.height * 0.05,
                  child: Center(
                    child: Text(
                      "Create task",
                      style: TextStyle(
                          color: controller() ? Colors.white : Colors.black),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
