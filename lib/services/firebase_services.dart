import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/helper/shared_pref.dart';
import 'package:flutter_fire/helper/snack_messenger.dart';

import '../screens/dashbaord/my_home.dart';

class FirebaseServices {
  static final auth = FirebaseAuth.instance;
  static final db = FirebaseFirestore.instance;
  static final storage = FirebaseStorage.instance.ref();
  static Map? userData;
  static Future signIn(BuildContext ctx, String email, String password) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await db.collection("users").doc(value.user?.uid).get().then((value) {
          userData = (value.data()!);

          SPHelper.saveKeyInLocal('Email', jsonDecode(userData!['Email']));
          SPHelper.saveKeyInLocal(
              'password', jsonDecode(userData!['password']));
          SPHelper.saveKeyInLocal('age', jsonDecode(userData!['age']));
          SPHelper.saveKeyInLocal('image', jsonDecode(userData!['image']));
        });

        SMHelper.msgSucess(ctx, "Login Success");
        Navigator.push(
            ctx, MaterialPageRoute(builder: (context) => Dashboard()));
      });
    } on FirebaseAuthException catch (e) {
      SMHelper.msgFail(ctx, "${e.message}");
    }
  }

  static Future signUp(
      {required BuildContext ctx,
      required PlatformFile? pickedFile,
      required String email,
      required String password,
      required String age}) async {
    try {
      final urlDownload = await uploadFile(ctx, pickedFile);

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

  static Future uploadFile(BuildContext ctx, PlatformFile? pickedFile) async {
    final path =
        'profile/images/${pickedFile!.name}'; //-------path or the directory
    final file =
        File(pickedFile.path!); //--------------------required file with path

    try {
      final ref = storage
          .child(path); //------here fetch the path you want to store your file
      final uploadTask = ref.putFile(file); //------put file and  path together
      final snapshot =
          await uploadTask.whenComplete(() {}); //---upload file with path
      if (snapshot != null) {
        final url = await snapshot.ref.getDownloadURL();
        return url;
      }
    } on FirebaseException catch (e) {
      // SMHelper.msgFail(ctx, "${e.message}");
      throw ('${e.message}');
    }
  }
}
