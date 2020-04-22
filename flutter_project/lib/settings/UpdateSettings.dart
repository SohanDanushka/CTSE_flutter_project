import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/api.dart';
import 'package:flutter_project/authService.dart';
import 'package:flutter_project/settings/UpdateDefaultPage.dart';
import 'package:flutter_project/user.dart';

class UpdateSettings extends StatefulWidget {

  final User user;

  UpdateSettings.Init({this.user});

  @override
  _UpdateSettingsState createState() => _UpdateSettingsState();
}

class _UpdateSettingsState extends State<UpdateSettings> {

  final AuthService _auth = AuthService();
  final APIService _apiService = APIService();

  List<bool> _selections = [true, false];
  List<String> _scoreList = ['International', 'IPL'];
  List<String> _rankingList = ['Test', 'ODI', 'T20'];
  bool _isRanking = true;
  String _scoreType = 'IPL';
  String _ranking = '';
  DocumentReference _docRef = null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
          ),
          title: Text(
            'Updates Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
        ),

        body: Container(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: <Widget>[
              ListTile(
                onTap: () {},
                leading: Text('This is a toggle button'),
                trailing: ToggleButtons(
                  children: <Widget>[
                    Text(
                        '1',
                      style: TextStyle(
                        fontSize: 10
                      ),
                    ),
                    Text(
                      '2',
                      style: TextStyle(
                          fontSize: 10
                      ),)
                  ],
                  isSelected: _selections,
                  splashColor: Colors.blue,
                  selectedColor: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  fillColor: Colors.red,
                  onPressed: (index) {
                    setState(() {
                      for (var i = 0; i < _selections.length; i++) {
                        _selections[i] = i == index;
                      }
                    });
                  },
                ),
              ),
              SizedBox(height: 30,),
              ListTile(
                leading: Text(
                  'Default Scores',
                  style: TextStyle(
//                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  )
                ),
                trailing: Container(
                  width: 120,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _apiService.getUserSettings(widget.user.uid),
                    builder: (context, snaphsot) {
                      if (snaphsot.hasError) {
                        print('The error: ${snaphsot.error}');
                        return Text('');
                      }
                      if (snaphsot.hasData) {
                        String defaultScore = snaphsot.data.documents[0].data['defaultScore'];
                        print('default score: ${defaultScore}');
                        DocumentReference reference = snaphsot.data.documents[0].reference;
                        return DropdownButton(
                          value: defaultScore == '' ? _scoreList[0] : defaultScore,
                          items: _scoreList.map((score) {
                            return new DropdownMenuItem(
                              value: score,
                              child: Text(score),
                            );
                          }).toList(),
                          onChanged: (val) {
                            //updating the default score type
                            _apiService.updateDefaultScore(reference, val);
                          },
                        );
                      }
                      return Text('');
                    },
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Divider(thickness: 2.0,),
              //ranking enabling

              StreamBuilder<QuerySnapshot>(
                stream: _apiService.getUserSettings(widget.user.uid),
                builder: (context, snapshots) {
                  if (snapshots.hasError) {
                    return Text('');
                  }
                  else if (snapshots.hasData) {
                    //changing the ranking option
                    bool rankingBool = snapshots.data.documents[0].data['isRanking'];
                    DocumentReference reference = snapshots.data.documents[0].reference;
                    return ListTile(
                      leading: Text(
                        'Ranking Updates',
                        style: TextStyle(
//                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                      ),
                      trailing: Switch(
                        value: rankingBool,
                        onChanged: (newBool) {
                          _apiService.updateRankingSettings(reference, newBool);
                          setState(() {
                            _isRanking = newBool;
                            _docRef = reference;
                          });
                        }
                      ),
                    );
                  }
                  return Text('No records found...');
                }
              ),
              Divider(thickness: 2,),
              //ranking settings
              _isRanking ? ListTile(
                leading: Text(
                  'View Rankings',
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),

                trailing: DropdownButton(
                  value: _ranking == '' ? _rankingList[0] : _ranking,
                  items: _rankingList.map((ranking) {
                    return new DropdownMenuItem(
                      value: ranking,
                      child: Text(ranking)
                    );
                  }).toList(),
                  onChanged: (value) {
                    _apiService.updateRankingType(_docRef, value);
                    setState(() {
                      _ranking = value;
                    });
                  },
                ),
              ) : Text('')


            ],
          ),
        ),
      ),
    );
  }
}
