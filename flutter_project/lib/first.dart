import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/authService.dart';
import 'package:flutter_project/home.dart';
import 'package:flutter_project/registration.dart';
import 'package:flutter_project/user.dart';
import 'package:flutter_project/wrapper.dart';
import 'package:provider/provider.dart';

void main() => runApp(LoginHome());

class LoginHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'ESPN Sports App',
        theme: ThemeData(
          primarySwatch: Colors.blue
        ),
        home: Wrapper(),
      ),
    );
  }

}

class FirstHome extends StatefulWidget {

  @override
  _FirstApp createState() => _FirstApp();

}

class _FirstApp extends State<FirstHome> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  dynamic _user;
  var _email = '';
  var _password = '';
  var _registeredUser = true;
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/blue_background.jpg'), fit: BoxFit.cover
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 15.0),
            children: <Widget>[
              SizedBox(height: 60.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/espn_logo.jpg',
                    fit: BoxFit.contain,
                    height: 60.0,
                    width: 100.0,
                  ),
                  Padding(padding: const EdgeInsets.all(6.0),),
                  Text(
                    'Sports',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                obscureText: false,
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                onChanged: (email) {
                  setState(() {
                    _email = email;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "email",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                ),
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                obscureText: true,
                validator: (val) => val.length < 6 ? 'Enter a password with minimum 6 charatcters' : null,
                onChanged: (pass) {
                  setState(() {
                    _password = pass;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Password",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                ),
              ),
              SizedBox(height: 15.0,),
              SizedBox(
                height: 15.0,
                child: Text(
                  !_registeredUser ? 'Not a Registered user, please sign up' : '',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              RaisedButton(
                color: Colors.green,
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    dynamic result = await _auth.signInWithEmailAndPassword(_email, _password);
                    if (result == null) {
                      setState(() {
                        _registeredUser = false;
                      });
                    }
                    else {
                      print('very good');
                    }
                  }
                },
              ),
              SizedBox(height: 10.0,),
              Material(
                elevation: 5.0,
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: OutlineButton(
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    disabledBorderColor: Colors.white,
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {},
                    borderSide: BorderSide(
                        color: Colors.white
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Material(
                            // needed
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => {}, // needed
                              child: Image.asset(
                                "images/facebook.png",
                                width: 22,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text("Log In with Facebook",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )
                          ),
                        ),

                      ],
                    )
                ),
              ),
              SizedBox(height: 10.0,),
              Material(
                elevation: 5.0,
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                child: OutlineButton(
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    borderSide: BorderSide(
                        color: Colors.white
                    ),
                    disabledBorderColor: Colors.white,
                    onPressed: () {
                    },
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => {}, // needed
                              child: Image.asset(
                                "images/google.png",
                                width: 22,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text("Log In with Google",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            )
                          ),
                        ),
                      ],
                    )
                ),
              ),
              SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'No Account?',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrationHome()
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}