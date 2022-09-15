import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/helper/snack_messenger.dart';

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

  bool loading = false;
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: selectFile,
                child: pickedFile != null
                    ? Image.file(File(pickedFile!.path!))
                    : Icon(Icons.photo),
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
              loading == false
                  ? RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final path = 'profile/images/${pickedFile!.name}';
                          final file = File(pickedFile!.path!);
                          try {
                            setState(() {
                              loading = true;
                            });
                            var u = await auth.createUserWithEmailAndPassword(
                                email: txtEmail.text,
                                password: txtPassword.text);
                            print("${u.user!.uid}");

                            if (u.user!.uid != null) {
                              final ref =
                                  FirebaseStorage.instance.ref().child(path);
                              final uploadTask = ref.putFile(file);
                              //-----upload
                              final snapshot =
                                  await uploadTask.whenComplete(() {});
                              final urlDownload =
                                  await snapshot.ref.getDownloadURL();
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(u.user!.uid)
                                  .set({
                                'Email': txtEmail.text,
                                'password': txtPassword.text,
                                'age': txtAge.text,
                                'image': urlDownload,
                              }).then((value) => SMHelper.msgSucess(
                                      context, "Registration Success"));
                            }
                            setState(() {
                              loading = false;
                            });
                          } on FirebaseException catch (e) {
                            setState(() {
                              loading = false;
                            });
                            SMHelper.msgFail(context, "${e.message}");
                            print("Check Error:  ${e.message}");
                          } catch (e) {
                            setState(() {
                              loading = false;
                            });
                            print("Check Exception: ${e}");
                          }
                        }
                      },
                      child: Text("Signup"),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              TextButton(
                onPressed: () {},
                child: Text("Login"),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
