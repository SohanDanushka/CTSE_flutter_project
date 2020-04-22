import 'package:flutter/material.dart';

class TeamLogo {

  static Widget getLogo(String team, double height, double width) {

    return ClipRect(
      child: Image.asset(
        'images/logo/' + team + '.png',
        height: height,
        width: width,
      ),
    );
  }
}