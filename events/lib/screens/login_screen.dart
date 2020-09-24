
import 'package:events/screens/event_screen.dart';
import 'package:events/shared/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  Authentication auth;

  bool _isLogin = true;
  String _userId;
  String _password;
  String _email;
  String _message;

  @override
  void initState() {
    auth = Authentication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Login'),),
        body: Container(
            padding: EdgeInsets.all(24),
            child: SingleChildScrollView(
                child: Form(
                    child: Column(
                      children: <Widget>[
                        emailInput(),
                        passwordInput(),
                        mainButton(),
                        secondaryButton(),
                        validationMessage(),
                      ],
                    )
                )
            )
        )
    );
  }

  Widget emailInput() {
    return Padding(
        padding: EdgeInsets.only(top: 120),
        child: TextFormField(
          controller: txtEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'email',
            icon: Icon(Icons.mail),
          ),
          validator: (text) => text.isEmpty ? ' Email is required': '',
        )
    );
  }

  Widget passwordInput() {
    return Padding(
        padding: EdgeInsets.only(top: 120),
        child: TextFormField(
          controller: txtPassword,
          keyboardType: TextInputType.emailAddress,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'password',
            icon: Icon(Icons.enhanced_encryption),
          ),
          validator: (text) => text.isEmpty ? 'Password is required' : '',
        )
    );
  }

  Widget mainButton() {
    String buttonText = _isLogin ? 'Login' : 'Sign up';
    return Padding(
        padding: EdgeInsets.only(top: 120),
        child: Container(
            height: 50,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Theme.of(context).accentColor,
              elevation: 3,
              child: Text(buttonText),
              onPressed: submit,
            )
        )
    );
  }

  Widget secondaryButton() {
    String buttonText = !_isLogin ? 'Login' : 'Sign up';
    return FlatButton(
      child: Text(buttonText),
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
        });
      },
    );
  }

  Widget validationMessage() {
    return Text(
        (_message != null) ? _message : '',
        style: TextStyle(
          fontSize: 14,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        )
    );
  }

  Future<void> submit() async {
    setState(() {
      _message = "";
    });
    try {
      if (_isLogin) {
        _userId = await auth.login(txtEmail.text, txtPassword.text);
        print('Login for user $_userId');
      } else {
        _userId = await auth.signUp(txtEmail.text, txtPassword.text);
        print('Sign up for user $_userId');
      }
      if (_userId != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => EventScreen(_userId),
        ));
      }
    } catch (err) {
      print('Error: $err');
      setState(() {
        _message = err.message;
      });
    }
  }
}
