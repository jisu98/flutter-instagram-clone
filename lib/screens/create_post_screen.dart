import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  static final String id = 'create_post_screen';

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Create Post"),
      ),
    );
  }
}
