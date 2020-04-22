import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/country.dart';
import 'package:flutter_project/api.dart';
import 'package:flutter_project/user.dart';
import 'package:flutter_project/utilities.dart';
import 'package:vertical_tabs/vertical_tabs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flag/flag.dart';


class Example extends StatefulWidget {

 final String uid;

 Example.init({this.uid});
  @override
  ExampleState createState() => ExampleState();

//  Example.name({this.uid});


}

class ExampleState extends State<Example> {

  final _apiService = APIService();
  bool _selected = true;
  bool _isIPLUpdate = false;
  bool _isIPLAdd = true;
  bool _isInternationalUpdate = false;
  bool _isInternationalAdd = true;

  List _selectedList = new List<bool>(100);
  List _myIPLTeamList = new List<bool>(100);
  List _myIPLRedTeamList = new List<bool>(100);

  List _selectedInternationalList = new List<bool>(100);
  List _myInternationalTeamList = new List<bool>(100);
  List _myInternationalRedTeamList = new List<bool>(100);

  List _selectedMyTeamsList = new List<bool>(100);

  List _myTeamList = new List<bool>(100);
  List _addToSet = new List<bool>(100);
  List _addIntlToSet = new List<bool>(100);
  bool _adding;
  bool _deleting;
  Set<String> set = {};
  Set<String> update_set = {};

  Set<String> myIPLTeams = {};
  Set<String> removingIPLTeams = {};

  Set<String> myInternationalTeams = {};
  Set<String> removingInternationalTeams = {};

  Set<DocumentReference> myReference = {};
  Set<DocumentReference> myIntlReference = {};
  Map<String, dynamic> teamDetails = new Map();

  Map<String, dynamic> _intlTeamDetails = new Map();
  DocumentReference _myTeamsReference;


  @override
  void initState() {
    super.initState();
    print('In the InitState() method');
    for (int i = 0; i < 100; i++) {
      _selectedList[i] = false;
      _selectedInternationalList[i] = false;
      _addToSet[i] = false;
      _addIntlToSet[i] = false;
      _myIPLTeamList[i] = false;
      _myIPLRedTeamList[i] = false;
      _myInternationalTeamList[i] = false;
      _myInternationalRedTeamList[i] = false;
      _selectedMyTeamsList[i] = true;
    }
    _adding = true;
    _deleting = false;
    _myTeamsReference = null;
  }

  //combining the my cricket teams and team details
  Stream<List<CricketTeam>> getMyCricketTeamCombinedDetails() async* {
    var team_stream = _apiService.getAllMyTeams(widget.uid);
    var cricketTeams = List<CricketTeam>();
    await for (var my_team in team_stream) {
      for (var myTeamDoc in my_team.documents) {

        String collectionName = myTeamDoc.data['table'];
        List teamIDs = myTeamDoc.data['team_Id'];
        var result = _apiService.getTeamByDocumentId(collectionName);

        print('Team IDs: ${teamIDs}');
        await result.then((document) {
          document.documents.forEach((team) {
            if (teamIDs.contains(team.reference.documentID)) {
              cricketTeams.add(new CricketTeam.fromData(data: team.data));
            }
          });
        });
      }
      yield cricketTeams;
    }

  }

  //querying the My cricket teams
  Widget buildMyCricketTeams(BuildContext context) {
    return StreamBuilder<List<CricketTeam>>(
        stream: getMyCricketTeamCombinedDetails(),
        builder: (context, AsyncSnapshot<List<CricketTeam>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return  CircularProgressIndicator();
            default:
              return getMyCricketTeamDetails(snapshot.data);
          }
        }
    );
  }

  //extracting the My cricket team details
  Widget getMyCricketTeamDetails(List<CricketTeam> snapshots) {

    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      crossAxisCount: 2,
      children: snapshots.map((document) => buildMyCricketTeamItem(document)).toList(),
    );
  }

  //building each My cricket team details
  Widget buildMyCricketTeamItem(CricketTeam snapshot) {
//    final team = MyCricketTeams.fromData(data: snapshot.data);
    Key key = new ValueKey(snapshot.Id);

    return Container(
      padding: const EdgeInsets.all(8),
      child: Card(
        key: key,
        shape: _getMyShape(snapshot.Id),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedMyTeamsList[snapshot.Id - 1] = !_selectedMyTeamsList[snapshot.Id - 1];
            });
          },
          child: Column(
            children: <Widget>[
               snapshot.code != null ? Flags.getMiniFlag(snapshot.code, 40, 40) : TeamLogo.getLogo(snapshot.name, 40, 40),
              Text(
                snapshot.name.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        )
      ),
    );
  }


  //querying the international cricket teams
  Widget buildInternationalCricketTeams(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _apiService.getInternationalCricketTeams(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          }
          if (snapshot.hasData) {
            print("International Documents ${snapshot.data.documents.length}");
            return getInternationalCricketTeamDetails(snapshot.data.documents);
          }
          return CircularProgressIndicator();
        }
    );
  }

  //extracting the inetrnational cricket team details
  Widget getInternationalCricketTeamDetails(List<DocumentSnapshot> snapshots) {

    Future<QuerySnapshot> my_teams = _apiService.getMyTeams(widget.uid, "International-Cricket");
    my_teams.then((docs) {
      if (docs.documents.isNotEmpty) {
        setState(() {
          _isInternationalUpdate = true;
          _isInternationalAdd = false;
        });
      }
      setState(() {
        _isIPLUpdate = false;
        _isIPLAdd = false;
      });
    });

    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      crossAxisCount: 2,
      children: snapshots.map((document) => buildInternationalCricketTeamItem(document, my_teams)).toList(),
    );
  }

  //building each international cricket team details
  Widget buildInternationalCricketTeamItem(DocumentSnapshot snapshot, Future<QuerySnapshot> my_teams) {
    final team = InternationalCricketTeam.fromData(data: snapshot.data);
    Key key = new ValueKey(team.Id);

//    looking for international teams already selected
    my_teams.then((QuerySnapshot docs) {
      if (docs.documents.isEmpty) {
        print('international mkuth na');
      }
      else {
        docs.documents.forEach((document) {
          List list = document.data['team_Id'];
          if (list.contains(snapshot.documentID)) {
            setState(() {
              myInternationalTeams.add(snapshot.documentID);
              _myInternationalTeamList[team.Id - 1] = true;
              myIntlReference.add(document.reference);
            });
          }
        });
      }

    });

    _intlTeamDetails['Id'] = 0;
    _intlTeamDetails['uid'] = widget.uid;
    _intlTeamDetails['table'] = 'International-Cricket';

    return Container(
      padding: const EdgeInsets.all(8),
      child: Card(
        key: key,
        shape: _getIntlShape(team.Id),
        child: InkWell(
          onTap: () {
            if (!_myInternationalTeamList[team.Id - 1]) {
              setState(() {
                _selectedInternationalList[team.Id - 1] = !_selectedInternationalList[team.Id - 1];
                _addToSet[team.Id - 1] = !_addToSet[team.Id - 1];

                if (_addToSet[team.Id - 1]) {
                  myInternationalTeams.add(snapshot.reference.documentID);

                }
                else {
                  myInternationalTeams.remove(snapshot.reference.documentID);
                }
              });
              print('My International Teams: ${myInternationalTeams}');
            }
          },
          //for updating the team list in the user's teams
          onLongPress: () {
            if (_myInternationalTeamList[team.Id - 1]) {
              _myInternationalRedTeamList[team.Id - 1] = true;
              setState(() {
                removingInternationalTeams.add(snapshot.documentID);
              });

              print('My International Teams: ${removingIPLTeams}');
            }
          },
          child: Column(
            children: <Widget>[
              Flags.getMiniFlag(team.code, 40, 40),
              Text(
                team.name.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        )
      ),
    );
  }


  //querying the IPL cricket teams
  Widget buildIPLCricketTeams(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _apiService.getIPLTeams(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          }
          if (snapshot.hasData) {
            print("International Documents ${snapshot.data.documents.length}");
            return getIPLCricketTeamDetails(snapshot.data.documents);
          }
          return CircularProgressIndicator();
        }
    );
  }

  //extracting the IPL cricket team details
  Widget getIPLCricketTeamDetails(List<DocumentSnapshot> snapshots) {

    Future<QuerySnapshot> my_teams = _apiService.getMyTeams(widget.uid, "IPL_Teams");
    my_teams.then((docs) {
      if (docs.documents.isNotEmpty) {
        setState(() {
          _isIPLUpdate = true;
          _isIPLAdd = false;
        });
      }
      setState(() {
        _isInternationalAdd = false;
        _isInternationalUpdate = false;
      });
    });

    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      crossAxisCount: 2,
      children: snapshots.map((document) => buildIPLCricketTeamItem(document, my_teams)).toList(),
    );
  }

  //building each IPL cricket team details
  Widget buildIPLCricketTeamItem(DocumentSnapshot snapshot, Future<QuerySnapshot> my_teams) {
    final team = IPLCricketTeam.fromData(data: snapshot.data);
    Key key = new ValueKey(team.Id);
    var documentId;

    my_teams.then((QuerySnapshot docs) {
      if (docs.documents.isEmpty) {
        print('nothing');
      }
      else {
        docs.documents.forEach((document) {
          documentId = document.reference;
          List list = document.data['team_Id'];
          if (list.contains(snapshot.documentID)) {
            setState(() {
              myIPLTeams.add(snapshot.documentID);
              _myIPLTeamList[team.Id - 1] = true;
              myReference.add(document.reference);
            });
          }
        });
      }
    });

    //setting data
    teamDetails['Id'] = 0;
    teamDetails['uid'] = widget.uid;
    teamDetails['table'] = 'IPL_Teams';


    return Container(
      padding: const EdgeInsets.all(8),
      child: Card(
        key: key,
        shape: _getShape(team.Id),
        child: InkWell(
          onTap: () {
            if (!_myIPLTeamList[team.Id - 1]) {
              setState(() {
                _selectedList[team.Id - 1] = !_selectedList[team.Id - 1];
                _addToSet[team.Id - 1] = !_addToSet[team.Id - 1];

                if (_addToSet[team.Id - 1]) {
                  set.add(snapshot.reference.documentID);
                  myIPLTeams.add(snapshot.reference.documentID);
                  _adding = true;
                  _deleting = false;
                }
                else {
                  _deleting = true;
                  _adding = false;
                  set.remove(snapshot.reference.documentID);
                  myIPLTeams.remove(snapshot.reference.documentID);
                }
              });
            }

          },
          //for updating the team list in the user's teams
          onLongPress: () {
            if (_myIPLTeamList[team.Id - 1]) {
              _myIPLRedTeamList[team.Id - 1] = true;
              setState(() {
                removingIPLTeams.add(snapshot.documentID);
              });

              print('My IPL Teams: ${removingIPLTeams}');
            }
          },
          child: Column(
            children: <Widget>[
              Text(
                team.name.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  RoundedRectangleBorder _getShape(int Id) {
    if (_selectedList[Id - 1] && !_myIPLRedTeamList[Id - 1]) {
      return new RoundedRectangleBorder(
        side: new BorderSide(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(4.0)
      );
    }
    else if (_myIPLTeamList[Id - 1] && !_myIPLRedTeamList[Id - 1]) {
      return new RoundedRectangleBorder(
        side: new BorderSide(color: Colors.green, width: 2.0),
        borderRadius: BorderRadius.circular(4.0)
      );
    }
    else if (_myIPLRedTeamList[Id - 1]) {
      return new RoundedRectangleBorder(
        side: new BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.circular(4.0)
      );
    }
    else {
      return new RoundedRectangleBorder(
          side: new BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(4.0)
      );
    }
  }

  // defining the shape for international teams
  RoundedRectangleBorder _getIntlShape(int Id) {
    if (_selectedInternationalList[Id - 1] && !_myInternationalRedTeamList[Id - 1]) {
      return new RoundedRectangleBorder(
          side: new BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(4.0)
      );
    }
    else if (_myInternationalTeamList[Id - 1] && !_myInternationalRedTeamList[Id - 1]) {
      return new RoundedRectangleBorder(
          side: new BorderSide(color: Colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(4.0)
      );
    }
    else if (_myInternationalRedTeamList[Id - 1]) {
      return new RoundedRectangleBorder(
          side: new BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.circular(4.0)
      );
    }
    else {
      return new RoundedRectangleBorder(
          side: new BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(4.0)
      );
    }
  }

  // defining the shape for My teams
  RoundedRectangleBorder _getMyShape(int Id) {
    if (_selectedMyTeamsList[Id - 1]) {
      return new RoundedRectangleBorder(
          side: new BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(4.0)
      );
    }
    else {
      return new RoundedRectangleBorder(
          side: new BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.circular(4.0)
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title',
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: VerticalTabs(
                    tabBackgroundColor: Colors.white,
                    tabTextStyle: TextStyle(
                      color: Colors.white
                    ),
                    tabsWidth: 80,
                    tabs: <Tab>[
                      Tab(
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 1),
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.person),
                                SizedBox(height: 25),
                                Text('My Teams'),
                                SizedBox(height: 25),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 1),
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.thumb_up),
                                SizedBox(height: 25),
                                Text('Suggested'),
                                SizedBox(height: 25),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 1),
                            child: Column(
                              children: <Widget>[
                                Icon(MdiIcons.trophy),
                                SizedBox(height: 25),
                                Text('World Cup'),
                                SizedBox(height: 25),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 1),
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.favorite),
                                SizedBox(height: 25),
                                Text('IPL'),
                                SizedBox(height: 25),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 1),
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.favorite),
                                SizedBox(height: 25),
                                Text('BBL'),
                                SizedBox(height: 25),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 1),
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.favorite),
                                SizedBox(height: 25),
                                Text('PSL'),
                                SizedBox(height: 25),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 1),
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.favorite),
                                SizedBox(height: 25),
                                Text('Javascript'),
                                SizedBox(height: 25),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    contents: <Widget>[
                      buildMyCricketTeams(context),
                      Text(
                        set.toString()
                      ),
                      buildInternationalCricketTeams(context),
                      buildIPLCricketTeams(context),
                      Container(
                          color: Colors.black12,
                          child: ListView.builder(
                            itemCount: 10,
                            itemExtent: 100,
                            itemBuilder: (context, index){
                              return Container(
                                margin: EdgeInsets.all(10),
                                color: Colors.white30,
                              );
                            })
                      ),
                      tabsContent('HTML 5'),
                      Container(
                        color: Colors.black12,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemExtent: 100,
                          itemBuilder: (context, index){
                            return Container(
                              margin: EdgeInsets.all(10),
                              color: Colors.white30,
                            );
                          })
                      ),
                    ],
                  ),

                ),
              ),

            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // updating IPL teams
            if (_isIPLUpdate) {
              print('You can update');
              myIPLTeams.removeAll(removingIPLTeams);
              _apiService.updateMyTeams(myIPLTeams.toList(), myReference.toList()[0]);
//              dispose();
              Navigator.pop(context);
            }
            // adding IPL teams
            else if (!_isIPLUpdate && _isIPLAdd) {
              teamDetails['team_Id'] = set.toList();
              var reference = await _apiService.addMyTeams(teamDetails);
//              dispose();
              Navigator.pop(context);
            }
            // updating international teams
            else if (_isInternationalUpdate) {
              myInternationalTeams.removeAll(removingInternationalTeams);
              _apiService.updateMyTeams(myInternationalTeams.toList(), myIntlReference.toList()[0]);
//              dispose();
              Navigator.pop(context);
            }
            // adding international teams
            else if (!_isInternationalUpdate && _isInternationalAdd) {
              _intlTeamDetails['team_Id'] = myInternationalTeams.toList();
              await _apiService.addMyTeams(_intlTeamDetails);
              Navigator.pop(context);
            }
          },
          child: Icon(Icons.thumb_up),
        ),
      ),
    );
  }

  Widget tabsContent(String caption, [ String description = '' ] ) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      color: Colors.black12,
      child: Column(
        children: <Widget>[
          Text(
            caption,
            style: TextStyle(fontSize: 25),
          ),
          Divider(height: 20, color: Colors.black45,),
          Text(
            description,
            style: TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class InternationalCricketTeam {
  final int Id;
  final String name;
  final String code;
  final Map<String, dynamic> data;

  InternationalCricketTeam.fromData({this.data}) :
      Id = data['Id'],
      name = data['name'],
      code = data['code'];

}

class IPLCricketTeam {
  final int Id;
  final String name;
  final String code;
  final Map<String, dynamic> data;

  IPLCricketTeam.fromData({this.data}) :
        Id = data['Id'],
        name = data['name'],
        code = data['code'];

}

class CricketTeam {
  final int Id;
  final String name;
  final String code;
  final Map<String, dynamic> data;

  CricketTeam.fromData({this.data}) : assert(data != null),
        Id = data['Id'],
        name = data['name'],
        code = data['code'];

}
