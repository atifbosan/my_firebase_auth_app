import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/screens/signup/signup_screen.dart';

import '../../helper/snack_messenger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SafeArea(
          child: Form(
        key: _formKey,
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
            loading == false
                ? RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          setState(() {
                            loading = true;
                          });
                          var u = await auth
                              .signInWithEmailAndPassword(
                                  email: txtEmail.text,
                                  password: txtPassword.text)
                              .then((value) =>
                                  SMHelper.msgSucess(context, "Login Success"));
                          setState(() {
                            loading = false;
                          });
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            loading = false;
                          });
                          SMHelper.msgFail(context, "${e.message}");
                          print("check Error: ${e.message}");
                        } catch (e) {
                          setState(() {
                            loading = false;
                          });
                          print("check Exception: ${e}");
                        }
                      }
                    },
                    child: Text("Login"),
                  )
                : Center(
                    child: CircularProgressIndicator(),
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
      )),
    );
  }
}
