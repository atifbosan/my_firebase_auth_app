import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/firebase_services.dart';
import '../../widgets/progressIndicator_widget.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({Key? key}) : super(key: key);
  final txtTitle = TextEditingController();
  final txtDescription = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime now = DateTime.now();
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Your Task"),
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
                child: Text("Save"),
                onPressed: () async {
                  progressIndicatorWidget(context);
                  if (formKey.currentState!.validate()) {
                    dynamic body = {
                      'title': txtTitle.text,
                      'description': txtDescription.text,
                      'date': now,
                    };
                    await FirebaseServices.saveDaTa(
                        ctx: context,
                        body: body,
                        collection: 'task',
                        uid: user!.uid);
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
