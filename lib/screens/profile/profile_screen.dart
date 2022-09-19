import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? img;
  String? email;
  String? age;

  getUserDate() async {
    final user = await FirebaseAuth.instance.currentUser;
    final db = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    setState(() {
      email = db.data()!['Email'];
      img = db.data()!['image'];
      age = db.data()!['age'];
    });
  }

  @override
  void initState() {
    getUserDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Screen"),
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                "$img",
              ),
            ),
            Text(
              "$email",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
            Text(
              "$age",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
          ],
        ),
      )),
    );
  }
}
