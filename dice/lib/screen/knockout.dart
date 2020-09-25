import 'package:dice/dice.dart';
import 'package:dice/screen/single.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class KnockOutScreen extends StatefulWidget {
  @override
  _KnockOutScreenState createState() => _KnockOutScreenState();
}

class _KnockOutScreenState extends State<KnockOutScreen> {
  String _message;
  int _playScore = 0;
  int _aiScore = 0;
  String _animation1;
  String _animation2;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _animation1 = 'Start';
    _animation2 = 'Start';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Knockout Game'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.repeat_one),
                onPressed: () {
                  MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => Single(),
                  );
                  Navigator.push(context, route);
                })
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      height: height / 3,
                      width: width / 2.5,
                      child: FlareActor(
                        'assets/Dice.flr',
                        fit: BoxFit.contain,
                        animation: _animation1,
                      )),
                  Container(
                    height: height / 3,
                    width: width / 2.5,
                    child: FlareActor(
                      'assets/Dice.flr',
                      fit: BoxFit.contain,
                      animation: _animation2,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GameText('Player', Colors.deepOrange),
                  GameText(_playScore.toString(), Colors.white),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(height / 24),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GameText('AI', Colors.lightBlue),
                  GameText(_aiScore.toString(), Colors.white),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(height / 12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: width / 3,
                    height: height / 10,
                    child: RaisedButton(
                      child: Text('Play'),
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      onPressed: () {
                        play(context);
                      },
                    ),
                  ),
                  SizedBox(
                      width: width / 3,
                      height: height / 10,
                      child: RaisedButton(
                        child: Text('Restart'),
                        color: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: () {
                          reset();
                        },
                      ))
                ],
              )
            ],
          ),
        )));
  }

  void reset() {
    setState(() {
      _animation1 = 'Start';
      _animation2 = 'Start';
      _aiScore = 0;
      _playScore = 0;
    });
  }

  Future<void> play(BuildContext context) async {
    String message = '';

    setState(() {
      _animation1 = 'Roll';
      _animation2 = 'Roll';
    });

    Dice.wait3Seconds().then((_) {
      Map<int, String> animation1 = Dice.getRandomAnimation();
      Map<int, String> animation2 = Dice.getRandomAnimation();
      int result = animation1.keys.first + 1 + animation2.keys.first + 1;
      int aiResult = Dice.getRandomNumber() + Dice.getRandomNumber();

      if (result == 7) result = 0;
      if (aiResult == 7) aiResult = 0;

      setState(() {
        _message = message;
        _playScore += result;
        _aiScore += aiResult;
        _animation1 = animation1.values.first;
        _animation2 = animation2.values.first;
      });

      if (_playScore >= 50 || _aiScore >= 50) {
        if (_playScore > _aiScore) {
          message = 'You win!';
        } else if (_playScore == _aiScore) {
          message = 'Draw!';
        } else {
          message = 'You lose!';
        }
        showMessage(message);
      }
    }).catchError((error) => print(error));
  }

  Future showMessage(String message) async {
    SnackBar snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}

class GameText extends StatelessWidget {
  final String text;
  final Color color;

  GameText(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(
      this.text,
      style: TextStyle(
        fontSize: 24,
        color: this.color,
      ),
    ));
  }
}
