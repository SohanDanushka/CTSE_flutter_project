import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/api.dart';


class NewsFeed extends StatelessWidget {

  final APIService _apiService = APIService();

  Widget buildNewsFeed(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _apiService.getNewsFeedDetails(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          print("Documents ${snapshot.data.documents.length}");
          return getNewsFeedDetails(snapshot.data.documents);
//          return getNewsFeedDetails(snapshot.data.documents);
//            return buildList(context, snapshot.data.documents);
        }
        return CircularProgressIndicator();
      }
    );
  }

  Widget getNewsFeedDetails(List<DocumentSnapshot> snapshots) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 20, 5, 10),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: snapshots.map((document) => buildNewsFeedItem(document)).toList(),
      )
    );
  }

  // building each news feed item
  Widget buildNewsFeedItem(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data;
    final record = NewsFeedDetails.fromMap(data: data);
    return Container(
      height: 220,
      constraints: BoxConstraints.expand(width: double.infinity, height: 250),
      width: double.infinity,
      child: Card(
        elevation: 3.0,
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.asset(
              record.image.toString(),
              height: 250,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          title: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(
              record.title.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                decorationStyle: TextDecorationStyle.solid
              ),
            ),
          ),
          subtitle: Text(record.subtitle.toString()),
          isThreeLine: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (
      Container(
        margin: const EdgeInsets.fromLTRB(5, 20, 5, 10),
        padding: const EdgeInsets.all(1.0),
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Main Story',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25
                  ),
                )
              ],
            ),
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
            SizedBox(height: 15,),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Other Stories',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25
                  ),
                )
              ],
            ),
            buildNewsFeed(context)
          ],
        ),
      )
    );
  }
}

class NewsFeedDetails {
  int id;
  String title;
  String subtitle;
  String image;
  Map<String, dynamic> data;

  NewsFeedDetails.fromMap({this.data}) :
      id = data['id'],
      title = data['title'],
      image = data['image'],
      subtitle = data['subtitle'];
}
