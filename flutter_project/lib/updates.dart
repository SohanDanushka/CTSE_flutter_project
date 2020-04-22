

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter_project/api.dart';
import 'package:flutter_project/example.dart';
import 'package:flutter_project/utilities.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UpdateApp extends StatefulWidget {

  final String uid;

  UpdateApp.init({this.uid});

  @override
  _UpdateStateApp createState() => _UpdateStateApp();

}

class _UpdateStateApp extends State<UpdateApp> {
  var _country = null;
  var _countryList = List<Country>();

  List<String> tableRows = ['Ishan', 'Sohan', 'Sachith'];

  final _apiService = APIService();

//  temporary image list
  final imageList = [
    {"image": 'images/srilanka.png'},
    {"image": 'images/india.png'},
    {"image": 'images/pakistan.png'},
    {"image": 'images/england.png'},
    {"image": 'images/australian.png'},
    {"image": 'images/SA.png'},
    {"image": 'images/NZ.png'}
  ];

  List<TableRow> getTableRows() {
    return tableRows.map((row) {
      return TableRow(
        children: <Widget>[
          TableCell(
            child: Text(row),
          ),
          TableCell(
            child: Text(row + ' 1 '),
          )
        ]
      );
    });
  }

  ListView getRandom() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text((index + 1).toString()),
              ),
              SizedBox(width: 30.0,),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Item ${index + 1}'),
              )
            ],
          ),
        );
      }
    );
  }

  //combining the my cricket teams and team details
  Stream<List<CricketTeam>> getMyCricketTeamCombinedDetails() async* {
    var team_stream = _apiService.getAllMyTeams(widget.uid);
    //the list which is yielded from the method
    var cricketTeams = List<CricketTeam>();
    // iterating the stream
    await for (var my_team in team_stream) {
      //considering each document in the stream
      for (var myTeamDoc in my_team.documents) {

        // finding the collection name from each document
        String collectionName = myTeamDoc.data['table'];
        // finding the team IDs from each document
        List teamIDs = myTeamDoc.data['team_Id'];
        // get the actual team details from the relevant team tables
        var result = _apiService.getTeamByDocumentId(collectionName);

        print('Team IDs: ${teamIDs}');
        // waiting until the process of adding to the team list is over
        await result.then((document) {
          //iterating through each team
          document.documents.forEach((team) {
            // if the user selected team is found in the actual team list
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

    return ListView(
      scrollDirection: Axis.horizontal,
      children: snapshots.map((team) => buildMyCricketTeamItem(team)).toList(),
    );

  }

  //building each My cricket team details
  Widget buildMyCricketTeamItem(CricketTeam snapshot) {
//    final team = MyCricketTeams.fromData(data: snapshot.data);
    Key key = new ValueKey(snapshot.Id);

    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.all(20.0),
      child: snapshot.code != null ? Flags.getMiniFlag(snapshot.code, 40, 40) : TeamLogo.getLogo(snapshot.name, 40, 40)
    );
  }


  //combining team rankings and its details
  Stream<List<InternationalCricketTeam>> getTeamRankingDetails() async* {
    Stream<QuerySnapshot> rankings = _apiService.getODIRankings();
    var teamList = List<InternationalCricketTeam>();

    await for (var ranking in rankings) {
      for (var rank in ranking.documents) {
        List rank_arr = rank.data['Rankings'];

        // get the actual team details from the relevant team tables
        var result = _apiService.getTeamByDocumentId("International-Cricket");

        // waiting until the process of adding to the team list is over
        await result.then((document) {
          //iterating through each team
          document.documents.forEach((team) {
            // if the user selected team is found in the actual team list
            if (rank_arr.contains(team.reference.documentID)) {
              teamList.add(new InternationalCricketTeam.fromData(data: team.data));
            }
          });
        });
      }

      yield teamList;
    }

  }

  //building the widget for displaying team Test rankings
  Widget buildODIRankings(BuildContext context) {
    return StreamBuilder<List<InternationalCricketTeam>>(
      stream: getTeamRankingDetails(),
      builder: (context, AsyncSnapshot<List<InternationalCricketTeam>> snapshots) {
        if (snapshots.hasError) {
          return Text('');
        }
        if (!snapshots.hasData) {
          return Text('No data');
        }
        switch (snapshots.connectionState) {
          case ConnectionState.waiting: return CircularProgressIndicator();
          default:
            return createTestRankingsTable(context, snapshots.data);
        }
      },
    );
  }

  //creating the table to view the test rankings
  Widget createTestRankingsTable(BuildContext context, List<InternationalCricketTeam> teams) {
    List<TableRow> tableRows = [];

    for (var i = 0; i < teams.length; i++) {
      tableRows.add(
          new TableRow(
            children: <TableCell>[
              TableCell(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text((i+1).toString()),
                  )
                ),
              ),
              TableCell(
                child: Row(
                  children: <Widget>[
                    SizedBox(height: 20, width: 10,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Flags.getMiniFlag(teams[i].code, 40, 40),
                    ),
//                    SizedBox(height: 20, width: 10,),
                    Text(teams[i].name)
                  ],
                ),
              )
            ]
          )
      );
    }

    return new Table(
      children: tableRows,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          Card(
            elevation: 4.0,
            child: ListTile(
              leading: Text(
                  'FAVORITES',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              trailing: RaisedButton(
                color: Colors.white,
                elevation: 0.0,
                onPressed: () {},
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.blue
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 75,
            width: double.infinity,
            child: Card(
              elevation: 1.0,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: IconButton(
                        iconSize: 20.0,
                        splashColor: Colors.blue,
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => Example.init(uid: widget.uid,)),
                            ),
                          );
                        }
                      ),
                    ),
                    title: Text('Add Team'),
                  ),
                ],
              )
            ),
          ),

          Container(
            height: 90,
            child: Card(
              child: buildMyCricketTeams(context),
            ),
          ),

          Container(
            height: 60,
            width: 400,
            child: Card(
              elevation: 3.0,
              child: ListTile(
                leading: Icon(MdiIcons.orderAlphabeticalAscending),
                title: Text(
                  'Rankings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                  ),
                ),
//                isThreeLine: true,
              ),
            ),
          ),

          //ranking container
          StreamBuilder<QuerySnapshot>(
            stream: _apiService.getUserSettings(widget.uid),
            builder: (context, snapshots) {
              if (snapshots.hasError) {
                return Text('something went wrong');
              }
              else if (snapshots.hasData) {
                bool rankingBool = snapshots.data.documents[0].data['isRanking'];
                if (rankingBool) {
                  String rankType = snapshots.data.documents[0].data['rankingType'];
                  return Container(
                    height: 700,
                    width: 400,
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10,),
                          Text(
                            rankType + ' rankings',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                            ),
                          ),
                          SizedBox(height: 10,),
                          buildODIRankings(context),
                        ],
                      ),
                    ),
                  );
                }
                else {
                  return Text('very bad');
                }
              }
              return Text('no rankings');
            },
          ),

          Container(
            height: 400,
            width: 400,
            child: Card(
              elevation: 3.0,
              child: ListTile(
                leading: FlutterLogo(),
                title: Text(
                    'All Series',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  CountryPicker _getCountries() {
    return (
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
            _countryList.add(country);
          });
        },
        selectedCountry: _country,
      )
    );
  }

  List<Widget> getListImages() {
    return (imageList.map((data) => _createListItem(data)).toList());
  }

  Widget _createListItem(Map<String, String> data) {
    var record = ImageSet.fromMap(data);
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.all(20.0),
      child: Image.asset(
        record.image.toString(),
      ),
    );
  }
}

class ImageSet {
  String image;
  String name;

  ImageSet.fromMap(Map<String, String> data) : image = data['image'];
}

