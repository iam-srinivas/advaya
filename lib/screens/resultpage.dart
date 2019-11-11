import 'package:advaya/screens/homepage.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final int score;
  final String round;

  ResultPage({Key key, @required this.score, this.round}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState(score, round);
}

class _ResultPageState extends State<ResultPage> {
  final int score;
  final String round;
  _ResultPageState(this.score, this.round);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your Score in ${round} is ${score} Points',
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
