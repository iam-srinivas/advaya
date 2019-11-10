import 'package:advaya/screens/quizpage.dart';
import 'package:flutter/material.dart';

class QuizHomePage extends StatefulWidget {
  @override
  _QuizHomePageState createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  Widget customCard(String name) {
    return ListTile(
      title: Text(name),
      onTap: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => QuizPage()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz page'),
      ),
      body: ListView(
        children: <Widget>[
          customCard('Round 1'),
          customCard('Round 2'),
          customCard('Round 3'),
        ],
      ),
    );
  }
}
