import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/services/firebase_services.dart';

import '../helper/snack_messenger.dart';

class Auth {
  static final auth = FirebaseAuth.instance;
  static final db = FirebaseFirestore.instance;
  static final storage = FirebaseStorage.instance.ref();

  static Future signIn(BuildContext ctx, String email, String password) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        SMHelper.msgSucess(ctx, "Login Success");
      });
    } on FirebaseAuthException catch (e) {
      SMHelper.msgFail(ctx, "${e.message}");
    }
  }

  static Future signUp(
      {required BuildContext ctx,
      PlatformFile? pickedFile,
      required String email,
      required String password,
      required String age}) async {
    try {
      final urlDownload = await FirebaseServices.uploadFile(ctx, pickedFile);
      final u = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await db.collection("users").doc(u.user!.uid).set({
        'Email': email,
        'password': password,
        'age': age,
        'image': urlDownload.toString(),
      }).then((value) => SMHelper.msgSucess(ctx, "Registration Success"));
    } on FirebaseAuthException catch (e) {
      SMHelper.msgFail(ctx, "${e.message}");
    } catch (e) {
      SMHelper.msgFail(ctx, "${e}");
    }
  }
}

/*await db
            .collection("users")
            .doc(value.user?.uid)
            .get()
            .then((value) async {
          userData = await (value.data());
          print(userData);
          await SPHelper.saveKeyInLocal('Email', userData!['Email']);
          await SPHelper.saveKeyInLocal('password', userData!['password']);
          await SPHelper.saveKeyInLocal('age', userData!['age']);
          print("My Email Age is : ${userData!['age']}");
          await SPHelper.saveKeyInLocal('image', userData!['image']);

          await Navigator.push(
              ctx, MaterialPageRoute(builder: (context) => Dashboard()));
        });*/
