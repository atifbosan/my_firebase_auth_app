import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/screens/addtask/add_task_screen.dart';
import 'package:flutter_fire/screens/profile/profile_screen.dart';
import 'package:flutter_fire/screens/update/update%20task.dart';

import '../map/map_tracking.dart';

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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapTracking()));
              },
              icon: Icon(Icons.map)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              icon: Icon(Icons.person)),
          IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: Icon(Icons.logout)),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('task')
                        .doc('myTask')
                        .collection(user!.uid)
                        .orderBy('date', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final item = snapshot.data!;
                        return ListView.builder(
                            itemCount: item.docs.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final items = item.docs[index];
                              final id = item.docs[index].id;
                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateTask(
                                          title: "${items['description']}",
                                          description:
                                              "${items['description']}",
                                          id: id,
                                        ),
                                      ),
                                    );
                                  },
                                  title: Text("${items['title']}"),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${items['description']}"),
                                      Text(
                                          "${DateTime.parse(items['date'].toDate().toString())}"),
                                      Text("${id}"),
                                    ],
                                  ),
                                ),
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Text("Error in the Data ${snapshot.hasError}");
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddTaskScreen()));
        },
        child: Icon(Icons.add),
      ),
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
