import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'sign_in_with_apple.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User _user;
  StreamSubscription<User> _authStateSub;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _authStateSub = FirebaseAuth.instance.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  void dispose() {
    _authStateSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            SizedBox(
              width: 300,
              child: SignInWithAppleButton(
                text: "Sign In with Apple",
                onPressed: () => _signIn(),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: SignInWithAppleButton(
                text: "Sign In with Apple (hack)",
                onPressed: () => _signIn(useHack: true),
              ),
            ),
            SizedBox(height: 20),
            RaisedButton(
              child: Text('Sign Out'),
              onPressed: _user == null ? null : FirebaseAuth.instance.signOut,
            ),
            if (_user != null) ...[
              SizedBox(height: 20),
              Text(_user.toString()),
            ]
          ],
        ),
      ),
    );
  }

  _signIn({bool useHack = false}) {
    signInWithApple(useHack: useHack)
        .then((value) => print('Signed in successfully.'))
        .catchError((error) => print("Sign In failed: $error"));
  }
}
