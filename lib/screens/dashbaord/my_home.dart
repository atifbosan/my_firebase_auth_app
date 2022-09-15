import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  static Map? userData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebaase"),
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Firebase Dashboard"),
            Text("User ID: ${user!.uid}"),
            Text("User Email: ${user!.email}"),
            RaisedButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: Text('Sign Out'),
            ),
            RaisedButton(
              onPressed: () => getUserContent(),
              child: Text('Fetch'),
            ),
          ],
        ),
      )),
    );
  }

  getUserContent() async {
    await db.collection("users").doc(user!.uid).get().then((value) {
      setState(() {
        userData = (value.data()!);
      });
      print(userData);
    });
  }
}
