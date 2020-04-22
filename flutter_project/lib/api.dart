

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_project/user.dart';

class APIService {

//  final user_references = Firestore.instance.collection('reviews').reference();

  Future registerUser(Map<String, dynamic> data) {

    RegisteredUser user = RegisteredUser.registerUser(data: data);

    try {
      Firestore.instance.runTransaction(
            (Transaction transaction) async {
          await Firestore.instance
              .collection('users')
              .document()
              .setData(user.toJson());
        },
      );
    } catch (e) {
      print(e.toString());

    }
  }

  getUserDetails(User user) {
    String uid = user.uid;
    final records = Firestore.instance
        .collection('users')
        .snapshots();
    return records;

  }

  getNewsFeedDetails() {
    final records = Firestore.instance
        .collection('news-feed')
        .snapshots();
    return records;

  }

  getInternationalCricketTeams() {
    final records = Firestore.instance
        .collection('International-Cricket')
        .snapshots();
    return records;
  }

  //get a particular international cricket team
  getInternationalCricketTeam(String teamDocId) {
    final records = Firestore.instance
        .collection('International-Cricket')
        .document('${teamDocId}')
        .get();
    return records;
  }

  //get a particular international cricket team
  getIPLCricketTeam(String teamDocId) {
    final records = Firestore.instance
        .collection('IPL_Teams')
        .document('${teamDocId}')
        .get();
    return records;
  }

  getIPLTeams() {
    final records = Firestore.instance
        .collection('IPL_Teams')
        .snapshots();
    return records;
  }

  //add methods
  addMyTeams(Map<String, dynamic> data) async {
    final teams = MyCricketTeams.fromData(data: data);
    var documentId = null;
    try {
      DocumentReference reference = Firestore.instance
          .collection('my-cricket-teams')
          .document();

      Firestore.instance.runTransaction(
        (Transaction transaction) async {
         await reference
          .setData(teams.toJson())
          .then((obj) => documentId);
        },
      );
      return reference;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  updateMyTeams(List<String> list, DocumentReference reference) {
//    print('hello update: ${list}');
    try {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(reference, {'team_Id': list});
      });
    } catch (e) {
      print(e.toString());
    }
  }

  getMyTeams(String uid, String table) {

    final records = Firestore.instance
        .collection('my-cricket-teams')
        .where("uid", isEqualTo: uid)
        .where("table", isEqualTo: table)
        .getDocuments();

    return records;
  }

  getAllMyTeams(String uid) {

    final records = Firestore.instance
        .collection('my-cricket-teams')
        .where("uid", isEqualTo: uid)
        .snapshots();

    return records;
  }

  getTeamByDocumentId(String collectionName) async {
    final records = await Firestore.instance
        .collection(collectionName)
        .getDocuments();

    return records;
  }

  //retrieving all international cricket matches
  getInternationalCricketMatches() async {
    final records = await Firestore.instance
        .collection('International-Cricket-Matches')
        .orderBy('date', descending: true)
        .snapshots();

    return records;
  }

  //retrieving all ipl cricket matches
  getIPLCricketMatches() async {
    final records = await Firestore.instance
        .collection('IPL_Cricket_Matches')
        .orderBy('date', descending: true)
        .snapshots();

    return records;
  }

  deleteMyTeams(DocumentReference reference) {
    print('I am deleted: ' + reference.toString());
  }

  //add new default page settings
  addDefaultPage(String uid, String defaultPage) {
    var documentId = null;
    try {
      DocumentReference reference = Firestore.instance
          .collection('settings')
          .document();

      Firestore.instance.runTransaction(
            (Transaction transaction) async {
          await reference
              .setData(Map<String, dynamic>());
        },
      );
      return reference;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //updating default page settings
  updateDefaultPage(DocumentReference reference, String defaultPage) {
    try {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(reference, {'defaultPage': defaultPage});
      });
    } catch (e) {
      print(e.toString());
    }
  }

  updateDefaultScore(DocumentReference reference, String defaultScore) {
    try {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(reference, {'defaultScore': defaultScore});
      });
    } catch (e) {
      print(e.toString());
    }
  }

  updateRankingSettings(DocumentReference reference, bool isRanking) {
    try {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(reference, {'isRanking': isRanking});
      });
    } catch (e) {
      print(e.toString());
    }
  }

  updateRankingType(DocumentReference reference, String rankingType) {
    try {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(reference, {'rankingType': rankingType});
      });
    } catch (e) {
      print(e.toString());
    }
  }

  //retrieving user settings
  getUserSettings(String uid) {
    final records = Firestore.instance
        .collection('settings')
        .where("uid", isEqualTo: uid)
        .snapshots();

    return records;
  }

  //retrieving test rankings
  getTestRankings() {
    final records = Firestore.instance
        .collection('International_Test_Rankings')
        .snapshots();

    return records;
  }

  //retrieving test rankings
  getODIRankings() {
    final records = Firestore.instance
        .collection('International_ODI_Rankings')
        .snapshots();

    return records;
  }

}