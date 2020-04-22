import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/api.dart';
import 'package:flutter_project/authService.dart';
import 'package:flutter_project/user.dart';

class DefaultPage extends StatefulWidget {

  final User user;

  DefaultPage.Init({this.user});

  @override
  _DefaultPageState createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {

  final AuthService _auth = AuthService();
  final APIService _apiService = APIService();
  List<String> _pageList = ['feed', 'score', 'updates'];
  String _selectedValue = '';

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
            'Default Page',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(
                    'Select the default page',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),

              //updating the default page
              StreamBuilder<QuerySnapshot>(
                stream: _apiService.getUserSettings(widget.user.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error);
                  }
                  if (snapshot.hasData) {
                    String defaultPage = snapshot.data.documents[0].data['defaultPage'];
                    print('default page: ${defaultPage}');
                    DocumentReference reference = snapshot.data.documents[0].reference;
                    return ListTile(
                      onTap: () {},
                      title: DropdownButtonFormField(
                        value: defaultPage == '' ? _pageList[0] : defaultPage,
                        items: _pageList.map((page) {
                          return new DropdownMenuItem(
                              value: page,
                              child: Text(page)
                          );
                        }).toList(),
                        onChanged: (value) {
                          _apiService.updateDefaultPage(reference, value);
                        },
                      ),
                    );
                  }
                  else {
                    return Text('No data');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
