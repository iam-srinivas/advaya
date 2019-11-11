import 'dart:async';
import 'dart:convert';
import 'package:advaya/screens/resultpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuizPage extends StatelessWidget {
  final String path;
  QuizPage({Key key, @required this.path}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString(path),
      builder: (BuildContext context, snapshot) {
        List myData = json.decode(snapshot.data.toString());
        if (myData == null)
          return Center(child: CircularProgressIndicator());
        else
          return Quiz(myData: myData);
      },
    );
  }
}

class Quiz extends StatefulWidget {
  final List myData;
  Quiz({Key key, @required this.myData}) : super(key: key);

  @override
  _QuizState createState() => _QuizState(myData);
}

class _QuizState extends State<Quiz> {
  int score = 0;
  int i = 1;
  int timer = 30;
  String showTimer = "30";
  bool cancelTimer = false;
  bool isButtonTapped = false;

  Color displayColor = Colors.purple;
  Color wrong = Colors.red;
  Color right = Colors.green;

  Map<String, Color> btnColor = {
    "a": Colors.purple,
    "b": Colors.purple,
    "c": Colors.purple,
    "d": Colors.purple
  };

  void startTimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      if (timer < 1) {
        t.cancel();
        nextQuestion();
      } else if (cancelTimer) {
        t.cancel();
      } else {
        timer--;
      }
      setState(() {
        showTimer = timer.toString();
      });
    });
  }

  void nextQuestion() {
    cancelTimer = false;
    timer = 30;
    isButtonTapped = false;

    if (i < myData[1].length) {
      setState(() {
        i++;
        btnColor['a'] = Colors.purple;
        btnColor['b'] = Colors.purple;
        btnColor['c'] = Colors.purple;
        btnColor['d'] = Colors.purple;
      });
      startTimer();
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResultPage(
                score: score,
                round: myData[0]['Name'],
              )));
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void checkAnswer(String option) {
    isButtonTapped = true;
    if (myData[3][i.toString()] == myData[2][i.toString()][option]) {
      score = score + 5;
      displayColor = right;
    } else {
      displayColor = wrong;
    }
    setState(() {
      btnColor[option] = displayColor;
    });
    cancelTimer = true;
    Timer(Duration(seconds: 2), nextQuestion);
  }

  Widget choiceButton(String option) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: MaterialButton(
        minWidth: 200.0,
        height: 40,
        onPressed: () {
          if (!isButtonTapped) {
            checkAnswer(option);
          }
        },
        child: Text(
          myData[2][i.toString()][option],
          style: TextStyle(color: Colors.white),
        ),
        color: btnColor[option],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  List myData;
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
                  myData[1][i.toString()],
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
                    showTimer,
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
