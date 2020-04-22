import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/NewsFeed.dart';
import 'package:flutter_project/api.dart';
import 'package:flutter_project/authService.dart';
import 'package:flutter_project/scores.dart';
import 'package:flutter_project/user.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'updates.dart';
import 'package:flutter_project/settings.dart';
import 'package:flutter_project/drawer.dart';


void main() => runApp(Home());

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'ESPN Sports App',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: HomeApp(),
    );
  }

}

class HomeApp extends StatefulWidget {
  final User user;
  RegisteredUser _registeredUser;

  HomeApp({Key key, this.user}) : super(key: key);


  @override
  _HomeStateApp createState() => _HomeStateApp();

}

class _HomeStateApp extends State<HomeApp> {

  final AuthService _auth = AuthService();
  final APIService _apiService = APIService();

  int number = 0;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
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
        body: <Widget>[
          NewsFeed(),
          Scores(uid: widget.user.uid),
          UpdateApp.init(uid: widget.user.uid),
        ].elementAt(_selectedIndex),

        bottomNavigationBar: BottomNavigationBar(
          onTap: _onItemTapped,
          elevation: 3.0,
          backgroundColor: Colors.blue,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: Text(
                'Home',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.score,
                color: Colors.white,
              ),
              title: Text(
                'Scores',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.touch_app,
                color: Colors.white,),
              title: Text(
                'Updates',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
        )
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

  // building the body for user details
  Widget buildNewsFeed() {
    return StreamBuilder<QuerySnapshot>(
      stream: _apiService.getNewsFeedDetails(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          print("Documents ${snapshot.data.documents.length}");
          return getNewsFeedDetails(snapshot.data.documents);
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

  // getting the list of news feed
  Widget getNewsFeedDetails(List<DocumentSnapshot> snapshots) {
    return ListView(
      children: <Widget>[
        Row(
          children: <Widget>[
            Card(
              color: Colors.grey,
              child: Container(
                height: 100,
                width: 100,
                child: Center(
                  child: Text('Title 1'),
                ),
              ),
              elevation: 2.0,
            ),
//                middle card
            Card(
              child: Container(
                height: 100,
                width: 100,
              ),
              elevation: 0,
            ),

            Card(
              color: Colors.grey,
              child: Container(
                height: 100,
                width: 100,
                child: Center(
                  child: Text('Title 2'),
                ),
              ),
              elevation: 2.0,
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(5, 20, 5, 10),
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: snapshots.map((document) => buildNewsFeedItem(document)).toList(),
          )
        )
      ]
    );
  }

  // building each news feed item
  Widget buildNewsFeedItem(DocumentSnapshot snapshot) {
    return Container(
      height: 100,
      width: 400,
      child: Card(
        elevation: 3.0,
        child: ListTile(
          leading: FlutterLogo(),
          title: Text('Hello'),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> ListBottomNavigationBarItems() {
    return (
        <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: Text(
              'Home',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.score,
              color: Colors.white,
            ),
            title: Text(
              'Scores',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.trophy,
              color: Colors.white,
            ),
            title: Text(
              'Updates',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ]
    );
  }

}




