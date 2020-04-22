import 'package:flag/flag.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/api.dart';
import 'package:flutter_project/example.dart';
import 'package:flutter_project/utilities.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_project/user.dart';


class Scores extends StatefulWidget {

  final String uid;

  Scores({this.uid});

  @override
  _ScoresState createState() => _ScoresState();
}

class _ScoresState extends State<Scores> {

  bool _isTopEventsSelected = true;
  bool _isMyTeamsSelected = false;
  final _apiService = APIService();

  //creating the international cricket match details as a stream
  Stream<List<InternationalCricketMatch>> getInternationalCricketMatches() async* {
    var result = await _apiService.getInternationalCricketMatches();
    var matches = List<InternationalCricketMatch>();

    //iterating the result of international cricket matches to get team details for each match
    await for (var match in result) {
      for (var matchDoc in match.documents) {
        //retrieving home and opponent team document IDs separately
        String home_team_doc = matchDoc.data['Home'];
        String opponent_team_doc = matchDoc.data['Opponent'];


        String home_team_name = '';
        String home_team_code = '';
        String opponent_team_name = '';
        String opponent_code = '';

        //retrieve team details for a given home team document ID
        var home_details = _apiService.getInternationalCricketTeam(home_team_doc);

        //assigning home team name and code
        await home_details.then((document) {
          home_team_name = document.data['name'];
          home_team_code = document.data['code'];
        });

        //retrieve team details for a given opponent team document ID
        var opponent_details = _apiService.getInternationalCricketTeam(opponent_team_doc);
        //assigning home team name and code
        await opponent_details.then((document) {
          opponent_team_name = document.data['name'];
          opponent_code = document.data['code'];
        });


        //initializing a map
        Map<String, dynamic> data = Map();
        //setting values in the map
        data['name'] = home_team_name;
        data['home_code'] = home_team_code;
        data['Home_overs'] = matchDoc.data['Home_overs'];
        data['Home_run'] = matchDoc.data['Home_run'];
        data['Home_wickets'] = matchDoc.data['Home_wickets'];
        data['Home_inns'] = matchDoc.data['Home_inns'];
        data['opponent'] = opponent_team_name;
        data['opponent_code'] = opponent_code;
        data['Opponent_overs'] = matchDoc.data['Opponent_overs'];
        data['Opponent_runs'] = matchDoc.data['Opponent_runs'];
        data['Opponent_wickets'] = matchDoc.data['Opponent_wickets'];
        data['Opponent_inns'] = matchDoc.data['Opponent_inns'];
        data['match_type'] = matchDoc.data['match_type'];
        data['date'] = matchDoc.data['date'].toDate().toString().split(' ')[0];

        //creating a InternationalCricketMatch object by passing the created map as a argument
        var cricketMatch = InternationalCricketMatch.fromData(data: data);

        //adding the match details to the list
        matches.add(cricketMatch);
      }
      //retrieving the list
      yield matches;
    }

  }

  // build the main widget for displaying match details
  Widget buildInternationalCricketMatches(BuildContext context) {
    return StreamBuilder<List<InternationalCricketMatch>>(
      stream: getInternationalCricketMatches(),
      builder: (context, AsyncSnapshot<List<InternationalCricketMatch>> snapshots) {
        //check for any errors
        if (snapshots.hasError) {
          return Text('error: ${snapshots.error}');
        }
        switch (snapshots.connectionState) {
          // if the records are still loading, display the CicularProgressIndicator()
          case ConnectionState.waiting: return CircularProgressIndicator();
          //if evrything is okay, build the widget
          default:
            return buildMatchDetailItems(context, snapshots.data);
        }
      },
    );
  }

  //creating the column element to display each match details
  Widget buildMatchDetailItems(BuildContext context, List<InternationalCricketMatch> matches) {
    return Column(
      children: matches.map((match) => buildMatchDetailItem(context, match)).toList(),
    );
  }

  //displaying each cricket match detail in card element
  Widget buildMatchDetailItem(BuildContext context, InternationalCricketMatch match) {
    return Card(
      elevation: 3.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: 8,),
          Text(
            'Date: ${match.date}',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black,
            ),
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            title: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  //displaying home team score
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flags.getMiniFlag(match.home_code, 30, 30),
                      SizedBox(width: 90,),
                      Text(
                        match.Home_wickets == 10 ?
                        match.Home_run.toString() + ' (' + match.Home_overs.toString() + ' ov.)' :
                        match.Home_run.toString() + '/' + match.Home_wickets.toString() + ' (' + match.Home_overs.toString() + ' ov.)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30,),
                  // displaying opponent team score
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flags.getMiniFlag(match.opponent_code, 30, 30),
                      SizedBox(width: 90,),
                      Text(
                        match.Opponent_wickets == 10 ?
                        match.Opponent_runs.toString() + ' (' + match.Opponent_overs.toString() + ' ov.)' :
                        match.Opponent_runs.toString() + '/' + match.Opponent_wickets.toString() + ' (' + match.Opponent_overs.toString() + ' ov.)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  //displaying the result
                  Center(
                    child: Text(
                      match.displayWinner()
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  //creating the international cricket match details as a stream
  Stream<List<IPLCricketMatch>> getIPLCricketMatches() async* {
    var result = await _apiService.getIPLCricketMatches();
    var matches = List<IPLCricketMatch>();

    //iterating the result of ipl cricket matches to get team details for each match
    await for (var match in result) {
      print('document length: ${match.documents}');
      for (var matchDoc in match.documents) {
        //retrieving home and opponent team document IDs separately
        String home_team_doc = matchDoc.data['Home'];
        String opponent_team_doc = matchDoc.data['Opponent'];

        String home_team_name = '';
        String opponent_team_name = '';

        //retrieve team details for a given home team document ID
        var home_details = _apiService.getIPLCricketTeam(home_team_doc);

        //assigning home team name and code
        await home_details.then((document) {
          home_team_name = document.data['name'];
        });

        //retrieve team details for a given opponent team document ID
        var opponent_details = _apiService.getIPLCricketTeam(opponent_team_doc);
        //assigning home team name and code
        await opponent_details.then((document) {
          opponent_team_name = document.data['name'];
        });
        

        //initializing a map
        Map<String, dynamic> data = Map();
        //setting values in the map
        data['name'] = home_team_name;
        data['Home_overs'] = matchDoc.data['Home_overs'];
        data['Home_run'] = matchDoc.data['Home_run'];
        data['Home_wickets'] = matchDoc.data['Home_wickets'];
        data['Home_inns'] = matchDoc.data['Home_inns'];
        data['Opponent'] = opponent_team_name;
        data['Opponent_overs'] = matchDoc.data['Opponent_overs'];
        data['Opponent_runs'] = matchDoc.data['Opponent_runs'];
        data['Opponent_wickets'] = matchDoc.data['Opponent_wickets'];
        data['Opponent_inns'] = matchDoc.data['Opponent_inns'];
        data['date'] = matchDoc.data['date'].toDate().toString().split(' ')[0];

        //creating a InternationalCricketMatch object by passing the created map as a argument
        var cricketMatch = IPLCricketMatch.fromData(data: data);

        //adding the match details to the list
        matches.add(cricketMatch);
      }
      //retrieving the list
      yield matches;
    }

  }

  // build the main widget for displaying IPL match details
  Widget buildIPLCricketMatches(BuildContext context) {
    return StreamBuilder<List<IPLCricketMatch>>(
      stream: getIPLCricketMatches(),
      builder: (context, AsyncSnapshot<List<IPLCricketMatch>> snapshots) {
        //check for any errors
        if (snapshots.hasError) {
          return Text('error: ${snapshots.error}');
        }
        switch (snapshots.connectionState) {
        // if the records are still loading, display the CicularProgressIndicator()
          case ConnectionState.waiting: return CircularProgressIndicator();
        //if evrything is okay, build the widget
          default:
            return buildIPLMatchDetailItems(context, snapshots.data);
        }
      },
    );
  }

  //creating the column element to display each match details
  Widget buildIPLMatchDetailItems(BuildContext context, List<IPLCricketMatch> matches) {
    return Column(
      children: matches.map((match) => buildIPLMatchDetailItem(context, match)).toList(),
    );
  }

  //displaying each ipl cricket match detail in card element
  Widget buildIPLMatchDetailItem(BuildContext context, IPLCricketMatch match) {
    return Card(
      elevation: 3.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: 8,),
          Text(
            'Date: ${match.date}',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black
            ),
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            title: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  //displaying home team score
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TeamLogo.getLogo(match.home, 30, 30),
                      SizedBox(width: 90,),
                      Text(
                        match.Home_wickets == 10 ?
                        match.Home_run.toString() + ' (' + match.Home_overs.toString() + ' ov.)' :
                        match.Home_run.toString() + '/' + match.Home_wickets.toString() + ' (' + match.Home_overs.toString() + ' ov.)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30,),
                  // displaying opponent team score
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TeamLogo.getLogo(match.opponent, 30, 30),
                      SizedBox(width: 90,),
                      Text(
                        match.Opponent_wickets == 10 ?
                        match.Opponent_runs.toString() + ' (' + match.Opponent_overs.toString() + ' ov.)' :
                        match.Opponent_runs.toString() + '/' + match.Opponent_wickets.toString() + ' (' + match.Opponent_overs.toString() + ' ov.)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  //displaying the result
                  Center(
                    child: Text(
                        match.displayWinner()
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var result = getInternationalCricketMatches();
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
            color: Color.fromRGBO(211, 211, 211, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RaisedButton(
                  padding: EdgeInsets.all(10),
//                  highlightElevation: 2.0,
                  color: _isTopEventsSelected ? Colors.blueAccent : Color.fromRGBO(211, 211, 211, 3),
                  textColor: _isTopEventsSelected ? Colors.white : Colors.black,
                  onPressed: () {
                    setState(() {
                      _isMyTeamsSelected = false;
                      _isTopEventsSelected = true;

                      print('International: ${_isTopEventsSelected}, IPL: ${_isMyTeamsSelected}' );
                    });
                  },
                  shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.today),
                      Padding(padding: EdgeInsets.fromLTRB(5, 5, 8, 5),),
                      Text(
                          'International',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.all(5),),
                // My teams button
                RaisedButton(
                  padding: EdgeInsets.all(7),
                  color: _isMyTeamsSelected ? Colors.blueAccent : Color.fromRGBO(211, 211, 211, 3),
                  textColor: _isMyTeamsSelected ? Colors.white : Colors.black,
                  onPressed: () {
                    setState(() {
                      _isMyTeamsSelected = true;
                      _isTopEventsSelected = false;

                      print('International: ${_isTopEventsSelected}, IPL: ${_isMyTeamsSelected}' );
                    });
                  },
                  shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        child: Image.asset(
                          'images/logo/ipl.png',
                          height: 30,
                          width: 30,
                        ),
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(5, 5, 8, 5),),
                      Text(
                        'IPL',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10,),
          Divider(thickness: 2,),
          _isTopEventsSelected ? buildInternationalCricketMatches(context) : buildIPLCricketMatches(context)
//          _isTopEventsSelected ? Text('I am good') : Text('I am Ishan')
        ],
      ),
    );
  }
}
