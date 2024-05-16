// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/pages/Signup.dart';
import 'package:twitter/providers/user_provider.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var emailtextediting = TextEditingController();
  var passtextediting = TextEditingController();
  final signinkey = GlobalKey<FormState>();
  final RegExp regex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: signinkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/logo.png'),
              width: 100,
            ),
            Text("Log in to Twitter",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              margin: EdgeInsets.fromLTRB(15, 30, 15, 0),
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30)),
              child: TextFormField(
                controller: emailtextediting,
                decoration: InputDecoration(
                    hintText: "Enter an Email",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    border: InputBorder.none),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter an Email";
                  } else if (regex.hasMatch(value) == false) {
                    return "Please enter an valid email";
                  }

                  return null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30)),
              child: TextFormField(
                controller: passtextediting,
                decoration: InputDecoration(
                    hintText: "Password",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    border: InputBorder.none),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter a Password";
                  } else if (value.length < 6) {
                    return "Password must be atleast 6 characters";
                  }

                  return null;
                },
              ),
            ),
            Container(
              width: 250,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextButton(
                  onPressed: () async {
                    if (signinkey.currentState!.validate()) {
                      try {
                        // debugPrint(emailtextediting.text);
                        // debugPrint(passtextediting.text);
                        await _auth.signInWithEmailAndPassword(
                            email: emailtextediting.text,
                            password: passtextediting.text);

                        ref
                            .read(userProvider.notifier)
                            .logIn(emailtextediting.text);
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.code.toString())));
                      }
                    }
                  },
                  child: Text(
                    "Log In",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Signup()));
                },
                child: Text(
                  "Don't have an account? Sign up here",
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        ),
      ),
    );
  }
}
