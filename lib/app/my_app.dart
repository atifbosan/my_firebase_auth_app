import 'package:flutter/material.dart';

import '../screens/login/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase',
      home: LoginScreen(),
    );
  }
}
