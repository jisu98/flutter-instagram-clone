import 'package:flutter/material.dart';
import 'package:instagram_clone/services/auth_service.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'feed_screen';

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        child: Center(
          child: FlatButton(
            child: Text("Logout"),
            onPressed: () => AuthService.logout(context),
          ),
        ),
      ),
    );
  }
}
