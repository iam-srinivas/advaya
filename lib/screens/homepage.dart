import 'package:advaya/screens/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  bool isSignedIn = false;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
      }
    });
  }

  getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isSignedIn = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: RaisedButton(
          color: Colors.purple,
          onPressed: signOut,
          padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
          child: Text(
            'Sign Out',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
      ),
    );
  }
}
