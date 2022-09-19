import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/screens/signup/signup_screen.dart';

import '../../auth/fir_auth.dart';
import '../../widgets/progressIndicator_widget.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
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
              RaisedButton(
                onPressed: () async {
                  progressIndicatorWidget(context);
                  if (_formKey.currentState!.validate()) {
                    await Auth.signIn(context, txtEmail.text, txtPassword.text);
                  }
                  dismissIndicator();
                },
                child: Text("Login"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupScreen()));
                },
                child: Text("Signup"),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
