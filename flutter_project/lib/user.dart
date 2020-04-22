import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String uid;

  User({this.uid});
}

class RegisteredUser {
  final String uid;
  final String firstName;
  final String lastName;
  final String country;
  final String email;
  final Map<String, dynamic> data;

  RegisteredUser.registerUser({this.data}) :
      uid = data['uid'],
      firstName = data['firstName'],
      lastName = data['lastName'],
      country = data['country'],
      email = data['email'];

  toJson() {
    return (
      {
        "firstName": firstName,
        "lastName": lastName,
        "country": country,
        "email": email,
        "uid": uid
      }
    );
  }

}

class MyCricketTeams {
  final int Id;
  final List team_Id;
  final String uid;
  final String table;
  final Map<String, dynamic> data;

  MyCricketTeams.fromData({this.data}) :
      Id = data['Id'],
      team_Id = data['team_Id'],
      table = data['table'],
      uid =  data['uid'];

  toJson() {
    return {
      "team_Id": team_Id,
      "uid": uid,
      "table": table
    };

  }


}

class InternationalCricketMatch {
  final String home;
  final String home_code;
  final double Home_overs;
  final int Home_run;
  final int Home_wickets;
  final int Home_inns;
  final String opponent;
  final String opponent_code;
  final double Opponent_overs;
  final int Opponent_runs;
  final int Opponent_wickets;
  final int Opponent_inns;
  final String match_type;
  final String date;
  final Map<String, dynamic> data;

  InternationalCricketMatch.fromData({this.data}) :
      home = data['name'],
      home_code = data['home_code'],
      Home_overs = data['Home_overs'].toDouble(),
      Home_run = data['Home_run'],
      Home_wickets = data['Home_wickets'],
      Home_inns = data['Home_inns'],
      opponent = data['opponent'],
      opponent_code = data['opponent_code'],
      Opponent_overs = data['Opponent_overs'].toDouble(),
      Opponent_runs = data['Opponent_runs'],
      Opponent_wickets = data['Opponent_wickets'],
      Opponent_inns = data['Opponent_inns'],
      match_type = data['match_type'],
      date = data['date'];


  displayWinner() {
    if ((Home_run > Opponent_runs) && (Home_inns == 1)) {
      return home + ' won by ' + (Home_run - Opponent_runs).toString() + ' runs';
    }
    else if ((Home_run > Opponent_runs) && (Home_inns == 2)) {
      return home + ' won by ' + (10 - Home_wickets).toString() + ' wickets';
    }
    else if ((Opponent_runs > Home_run) && (Opponent_inns == 2)) {
      return opponent + ' won by ' + (10 - Opponent_wickets).toString() + ' wickets';
    }
    else if ((Opponent_runs > Home_run) && (Opponent_inns == 1)) {
      return opponent + ' won by ' + (Opponent_runs - Home_run).toString() + ' runs';
    }
    else{
      return null;
    }
  }

}

class IPLCricketMatch {
  final String home;
  final double Home_overs;
  final int Home_run;
  final int Home_wickets;
  final int Home_inns;
  final String opponent;
  final double Opponent_overs;
  final int Opponent_runs;
  final int Opponent_wickets;
  final int Opponent_inns;
  final String date;
  final Map<String, dynamic> data;

  IPLCricketMatch.fromData({this.data}) :
        home = data['name'],
        Home_overs = data['Home_overs'].toDouble(),
        Home_run = data['Home_run'],
        Home_wickets = data['Home_wickets'],
        Home_inns = data['Home_inns'],
        opponent = data['Opponent'],
        Opponent_overs = data['Opponent_overs'].toDouble(),
        Opponent_runs = data['Opponent_runs'],
        Opponent_wickets = data['Opponent_wickets'],
        Opponent_inns = data['Opponent_inns'],
        date = data['date'];


  displayWinner() {
    if ((Home_run > Opponent_runs) && (Home_inns == 1)) {
      return home + ' won by ' + (Home_run - Opponent_runs).toString() + ' runs';
    }
    else if ((Home_run > Opponent_runs) && (Home_inns == 2)) {
      return home + ' won by ' + (10 - Home_wickets).toString() + ' wickets';
    }
    else if ((Opponent_runs > Home_run) && (Opponent_inns == 2)) {
      return opponent + ' won by ' + (10 - Opponent_wickets).toString() + ' wickets';
    }
    else if ((Opponent_runs > Home_run) && (Opponent_inns == 1)) {
      return opponent + ' won by ' + (Opponent_runs - Home_run).toString() + ' runs';
    }
    else{
      return null;
    }
  }

}

class UserSettings {
  final String uid;
  final String defaultPage;
  final String defaultScore;
  final Map<String, dynamic> data;


  UserSettings.fromData({this.data}) :
      uid = data['uid'],
      defaultPage = data['defaultPage'],
      defaultScore = data['defaultScore'];

  toJson() {
    return {
      "uid": uid,
      "defaultPage": defaultPage,
      "defaultScore": defaultPage
    };
  }
}