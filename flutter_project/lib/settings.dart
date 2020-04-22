import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/api.dart';
import 'package:flutter_project/authService.dart';
import 'package:flutter_project/settings/UpdateDefaultPage.dart';
import 'package:flutter_project/user.dart';
import 'package:flutter_project/drawer.dart';
import 'package:flutter_project/settings/UpdateSettings.dart';


class Settings extends StatefulWidget {

  final User user;

  Settings.Init({this.user});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  String _test = null;

  final AuthService _auth = AuthService();
  final APIService _apiService = APIService();


//  Stream<UserSettings> getUserSettings() async* {
//    var users = _apiService.getUserSettings();
//    var new_user = null;
//
//    await for (var user in users.asStream()) {
//      for (var i in user.documents) {
//        print('ishan');
//      }
//    }
//
//    yield new_user;
//  }

  Widget buildUserSettings(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _apiService.getUserSettings(widget.user.uid),
      builder: (context, snapshots) {
        if (snapshots.hasError) {
          return Text('error: ${snapshots.error}');
        }
        else {

        }
      },
    );
  }


  // building the body for user details
  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _apiService.getUserDetails(widget.user),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          }
          if (snapshot.hasData) {
            print("Documents ${snapshot.data.documents.length}");
            return getUserDetails(snapshot.data.documents);
//            return buildList(context, snapshot.data.documents);
          }
          return CircularProgressIndicator();
        }
    );
  }

  //to get the user details
  Widget getUserDetails(List<DocumentSnapshot> snapshots) {
    var name = '';

    for (var i = 0; i < snapshots.length; i++) {
      if (snapshots[i].data['uid'] == widget.user.uid) {
        name = snapshots[i].data['firstName'];
      }
    }

    return Text(
      name,
      style: TextStyle(
          color: Colors.white
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: CustomDrawer.Init(user: widget.user,),
        appBar: AppBar(
          actions: <Widget>[
            FlatButton.icon(
              color: Colors.blue,
              onPressed: () {
                _auth.signOut();
              },
              icon: Icon(
                Icons.perm_identity,
                color: Colors.white,
              ),
              label: buildBody(context)
            )
          ],
          title: Text(
            'ESPNSPORTS',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 22
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => UpdateSettings.Init(user: widget.user,))
                    )
                  );
                },
                leading: Text('Updates'),
              ),
              Divider(thickness: 2,),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => DefaultPage.Init(user: widget.user,))
                      )
                  );
                },
                leading: Text('Pages'),
              ),
              Divider(thickness: 2,),
              ListTile(
                onTap: () {},
                leading: Text('Settings 3'),
              ),
              Divider(thickness: 2,),
              ListTile(
                onTap: () {},
                leading: Text('Settings 4'),
              ),
              Divider(thickness: 2,),
              ListTile(
                onTap: () {},
//                leading: buildUserSettings(context),
              ),
            ],
          ),
        ),
      )
    );
  }
}
