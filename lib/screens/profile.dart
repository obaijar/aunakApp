import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String? id;

  Profile({this.id});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(id != null ? 'Profile ID: $id' : 'No ID available'),
      ),
    );
  }
}
