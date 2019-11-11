import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString("assets/round1.json"),
      builder: (BuildContext context, snapshot) {
        List myData = json.decode(snapshot.data.toString());
        if (myData == null)
          return CircularProgressIndicator();
        else
          return Quiz(myData: myData);
      },
    );
  }
}

class Quiz extends StatefulWidget {
  var myData;
  Quiz({Key key, @required this.myData}) : super(key: key);
  @override
  _QuizState createState() => _QuizState(myData);
}

class _QuizState extends State<Quiz> {
  int score = 0;

  Color displayColor = Colors.purple;
  Color wrong = Colors.red;
  Color right = Colors.green;

  Map<String, Color> btnColor = {
    "a": Colors.purple,
    "b": Colors.purple,
    "c": Colors.purple,
    "d": Colors.purple
  };
  checkAnswer(String option) {
    if (myData[2]["1"] == myData[1]["1"][option]) {
      score = score + 5;
      print(score);
      displayColor = right;
    } else {
      displayColor = wrong;
    }
    setState(() {
      btnColor[option] = displayColor;
    });
  }

  Widget choiceButton(String option) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: MaterialButton(
        minWidth: 200.0,
        height: 40,
        onPressed: () {
          checkAnswer(option);
        },
        child: Text(
          myData[1]['1'][option],
          style: TextStyle(color: Colors.white),
        ),
        color: btnColor[option],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  var myData;
  _QuizState(this.myData);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Error'),
                  content: Text('You Cant Go Back at this Stage'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.bottomLeft,
                child: Text(
                  myData[0]['1'],
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    choiceButton('a'),
                    choiceButton('b'),
                    choiceButton('c'),
                    choiceButton('d'),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Center(
                  child: Text(
                    '30',
                    style:
                        TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
