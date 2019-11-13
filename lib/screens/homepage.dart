import 'package:advaya/screens/loginpage.dart';
import 'package:advaya/screens/quizpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  Firestore db = Firestore.instance;
  String uId;

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
        this.uId = user.uid;
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

  Widget customCard(BuildContext context, String name, String path,
      DocumentSnapshot document) {
    return ListTile(
      title: Text(name),
      onTap: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => QuizPage(
                  path: path,
                  document: document,
                )));
      },
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    switch (document['Status']) {
      case 'Round1':
        return customCard(context, 'Round 1', 'assets/round1.json', document);
      case 'Round2':
        return customCard(context, 'Round 2', 'assets/round2.json', document);
      case 'Round3':
        return customCard(context, 'Round 3', 'assets/round3.json', document);
      default:
        return Center(
          child: Text('Please Wait ....'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: isSignedIn
          ? StreamBuilder(
              stream: db
                  .collection('users')
                  .where('UId', isEqualTo: uId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, index) =>
                        _buildListItem(context, snapshot.data.documents[index]),
                  );
                }
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName:
                  user != null ? Text(user.displayName) : Text('Loading'),
              accountEmail: user != null ? Text(user.email) : Text('Loading'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.purple,
              ),
            ),
            ListTile(
              title: Text('Log Out'),
              onTap: signOut,
            ),
          ],
        ),
      ),
    );
  }
}
