import 'package:advaya/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final int score;
  final String round;
  final DocumentSnapshot document;

  ResultPage({Key key, @required this.score, this.round, this.document})
      : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState(score, round, document);
}

class _ResultPageState extends State<ResultPage> {
  final int score;
  final String round;
  final DocumentSnapshot document;
  _ResultPageState(this.score, this.round, this.document);

  @override
  void initState() {
    super.initState();
    updateResult(document, round, score);
  }

  updateResult(DocumentSnapshot document, String round, int score) async {
    await document.reference.updateData({'Scores.${round}': score});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your Response Has Been Recorded Thank You For Participation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text(
                  'Continue',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: Colors.purple,
              ),
            )
          ],
        ),
      ),
    );
  }
}
