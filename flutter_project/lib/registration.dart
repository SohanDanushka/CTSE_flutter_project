import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/authService.dart';
import 'package:flutter_project/home.dart';
import 'package:flutter_project/user.dart';
import 'package:flutter_project/wrapper.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';

class RegistrationHome extends StatefulWidget {

  @override
  _RegistrationApp createState() => _RegistrationApp();

}

class _RegistrationApp extends State<RegistrationHome> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  dynamic _user;
  var _email = '';
  var _password = '';
  var _country = null;
  var _firstName = '';
  var _lastName = '';


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
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text(
            'ESPNSPORTS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 22
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 15.0),
            children: <Widget>[
              SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Registration',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.0,),
              // Textfield for 'FirstName'
              TextFormField(
                obscureText: false,
                validator: (val) => val.isEmpty ? 'Enter a firstname' : null,
                onChanged: (firstName) {
                  setState(() {
                    _firstName = firstName;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "FirstName",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                ),
              ),
              SizedBox(height: 20.0,),
              // textfield for 'LastName'
              TextFormField(
                obscureText: false,
                validator: (val) => val.isEmpty ? 'Enter a lastname' : null,
                onChanged: (lastName) {
                  setState(() {
                    _lastName = lastName;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "LastName",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                ),
              ),
              SizedBox(height: 15.0,),
              // textfield for 'country'
              CountryPicker(
                dense: false,
                showFlag: true,  //displays flag, true by default
                showDialingCode: false, //displays dialing code, false by default
                showName: true, //displays country name, true by default
                showCurrency: false, //eg. 'British pound'
                showCurrencyISO: false, //eg. 'GBP'
                onChanged: (Country country) {
                  setState(() {
                    _country = country;
                  });
                },
                selectedCountry: _country,
              ),
              SizedBox(height: 15.0,),
              // textfield for 'Email'
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
                  hintText: "Email",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                ),
              ),
              SizedBox(height: 15.0,),
              // textfield for 'password'
              TextFormField(
                obscureText: true,
                validator: (val) => val.length < 6 ? 'Enter a password with minimum 6 characters' : null,
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
              // textfield for 'cpassword'
              TextFormField(
                obscureText: true,
                validator: (val) => val != _password ? 'Passwords do not match' : null,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Confirm Password",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                ),
              ),
              SizedBox(height: 15.0,),
              RaisedButton(
                color: Colors.red,
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    var data = Map<String, dynamic>();
                    data['uid'] = '';
                    data['firstName'] = _firstName;
                    data['lastName'] = _lastName;
                    data['country'] = _country.name;
                    data['email'] = _email;
                    dynamic result = await _auth.registerWithEmailAndPassword(_email, _password, data);
                    if (result == null) {
                      print('No user');
                    }
                    else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Wrapper()
                        )
                      );
                    }
                  }
                  else {
                    print('wrong');
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeApp()
                        ),
                      );
                    },
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
                      onPressed: () {},
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