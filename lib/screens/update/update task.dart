import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/firebase_services.dart';
import '../../widgets/progressIndicator_widget.dart';

class UpdateTask extends StatelessWidget {
  final String title;
  final String description;
  final String id;
  UpdateTask(
      {Key? key,
      required this.title,
      required this.description,
      required this.id})
      : super(key: key);
  final txtTitle = TextEditingController();
  final txtDescription = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime now = DateTime.now();
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    txtTitle.text = title;
    txtDescription.text = description;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Your Task"),
        actions: [
          IconButton(
            onPressed: () async {
              progressIndicatorWidget(context);
              await FirebaseServices.delete(
                  ctx: context,
                  collection: 'task',
                  uid: user!.uid,
                  itemID: '$id');

              dismissIndicator();
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: txtTitle,
                decoration: InputDecoration(hintText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please enter description";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: txtDescription,
                decoration: InputDecoration(hintText: 'Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please enter description";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 25,
              ),
              CupertinoButton(
                child: Text("Update"),
                onPressed: () async {
                  progressIndicatorWidget(context);
                  if (formKey.currentState!.validate()) {
                    dynamic body = {
                      'title': txtTitle.text,
                      'description': txtDescription.text,
                      'date': now,
                    };
                    await FirebaseServices.update(
                        ctx: context,
                        body: body,
                        collection: 'task',
                        uid: user!.uid,
                        itemID: '$id');
                  }
                  dismissIndicator();
                },
                color: Colors.blueAccent,
              )
            ],
          ),
        ),
      )),
    );
  }
}
