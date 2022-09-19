import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/helper/snack_messenger.dart';

class FirebaseServices {
  static final auth = FirebaseAuth.instance;
  static final db = FirebaseFirestore.instance;
  static final storage = FirebaseStorage.instance.ref();

  static Future saveDaTa({
    required BuildContext ctx,
    dynamic body,
    required String collection,
    required String uid,
  }) async {
    try {
      await db
          .collection("$collection")
          .doc('myTask')
          .collection(uid)
          .doc()
          .set(body)
          .then((value) => SMHelper.msgSucess(ctx, "Added Success"));
    } on FirebaseException catch (e) {
      print(e);
      SMHelper.msgFail(ctx, "${e.message}");
    } catch (e) {
      print(e);
      SMHelper.msgFail(ctx, "${e}");
    }
  }

  static Future update({
    required BuildContext ctx,
    dynamic body,
    required String collection,
    required String itemID,
    required String uid,
  }) async {
    try {
      await db
          .collection("$collection")
          .doc('myTask')
          .collection(uid)
          .doc(itemID)
          .set(body)
          .then((value) => SMHelper.msgSucess(ctx, "Updation Success"));
    } on FirebaseException catch (e) {
      print(e);
      SMHelper.msgFail(ctx, "${e.message}");
    } catch (e) {
      print(e);
      SMHelper.msgFail(ctx, "${e}");
    }
  }

  static Future delete({
    required BuildContext ctx,
    required String collection,
    required String itemID,
    required String uid,
  }) async {
    try {
      await db
          .collection("$collection")
          .doc('myTask')
          .collection(uid)
          .doc(itemID)
          .delete()
          .then((value) => SMHelper.msgSucess(ctx, "Deleted Success"));
    } on FirebaseException catch (e) {
      print(e.message);
      SMHelper.msgFail(ctx, "${e.message}");
    } catch (e) {
      print(e);
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
      SMHelper.msgFail(ctx, "${e.message}");
      throw ('${e.message}');
    }
  }

  static Future deleteFile(BuildContext ctx, PlatformFile? pickedFile) async {
    try {
      final path = 'profile/images/${pickedFile!.name}';
      final ref = storage.child(path);
      await ref
          .delete()
          .then((value) => SMHelper.msgSucess(ctx, "Deleted Success"));
    } on FirebaseException catch (e) {
      SMHelper.msgFail(ctx, "${e.message}");
      throw ('${e.message}');
    }
  }
}
