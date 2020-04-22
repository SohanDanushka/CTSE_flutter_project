import 'package:flutter/material.dart';
import 'package:flutter_project/authenticate.dart';
import 'package:flutter_project/first.dart';
import 'package:flutter_project/home.dart';
import 'package:flutter_project/user.dart';
import 'package:provider/provider.dart';


//handles the auth changes of the application
class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user == null);

    if (user == null) {
      return Authenticate();
    }
    else {
      return HomeApp(user: user,);
    }

  }
}
