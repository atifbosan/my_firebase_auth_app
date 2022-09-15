import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/services/firebase_services.dart';

import '../../widgets/progressIndicator_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  final txtAge = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance.collection('users');
  PlatformFile? pickedFile;
  Future selectFile() async {
    final picked = await FilePicker.platform.pickFiles();
    if (picked != null) {
      setState(() {
        pickedFile = picked.files.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: selectFile,
                  child: pickedFile != null
                      ? Image.file(
                          File(pickedFile!.path!),
                          width: 150,
                        )
                      : Icon(
                          Icons.photo,
                          size: 100,
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: txtEmail,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "Please Enter Email";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: txtPassword,
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "Please Enter Password";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: txtAge,
                  decoration: InputDecoration(labelText: 'Age'),
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "Please Enter Age";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () async {
                    progressIndicatorWidget(context);
                    if (_formKey.currentState!.validate()) {
                      await FirebaseServices.signUp(
                          ctx: context,
                          pickedFile: pickedFile,
                          email: txtEmail.text,
                          password: txtPassword.text,
                          age: txtAge.text);
                    }
                    dismissIndicator();
                  },
                  child: Text("Signup"),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("Login"),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
