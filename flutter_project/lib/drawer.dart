import 'package:flutter/material.dart';
import 'package:flutter_project/home.dart';
import 'package:flutter_project/user.dart';
import 'package:flutter_project/settings.dart';

class CustomDrawer extends StatelessWidget {

  final User user;

  CustomDrawer.Init({this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                    image: AssetImage(
                      'images/background.jpg',
                    ),
                    fit: BoxFit.contain
                )
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => HomeApp(user: user))
                )
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => Settings.Init(user: user))
                )
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Account'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }
}
