import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/screens/edit_profile_screen.dart';
import 'package:instagram_clone/services/database_service.dart';
import 'package:instagram_clone/utilities/constants.dart';

class ProfileScreen extends StatefulWidget {
  static final String id = 'profile_screen';

  final String currentUserId;
  final String userId;

  ProfileScreen({this.currentUserId, this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isFollowing = true;
  int followersCount = 0;
  int followingCount = 0;

  @override
  void initState() {
    super.initState();
    _setupIsFollowing();
    _setupFollowers();
    _setupFollowing();
  }

  _setupIsFollowing() async {
    bool isFollowingUser = await DatabaseService.isFollowingUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    setState(() {
      isFollowing = isFollowingUser;
    });
  }

  _setupFollowers() async {
    int userFollowersCount = await DatabaseService.numFollowers(widget.userId);
    setState(() {
      followersCount = userFollowersCount;
    });
  }

  _setupFollowing() async {
    int userFollowingCount = await DatabaseService.numFollowing(widget.userId);
    setState(() {
      followingCount = userFollowingCount;
    });
  }

  _followOrUnfollow() {
    if (isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  _followUser() {
    DatabaseService.followUser(widget.currentUserId, widget.userId);
    setState(() {
      isFollowing = true;
      followersCount += 1;
    });
  }

  _unfollowUser() {
    DatabaseService.unfollowUser(widget.currentUserId, widget.userId);
    setState(() {
      isFollowing = false;
      followersCount -= 1;
    });
  }

  _displayButton(User user) {
    return user.id == widget.currentUserId
        ? Container(
            width: 200.0,
            child: FlatButton(
              color: Colors.blue,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfileScreen(user: user),
                ),
              ),
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Container(
            width: 200.0,
            child: FlatButton(
              color: isFollowing ? Colors.grey[200] : Colors.blue,
              textColor: isFollowing ? Colors.black : Colors.white,
              onPressed: _followOrUnfollow,
              child: Text(
                isFollowing ? 'Unfollow' : 'Follow',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Instagram',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Billabong',
            fontSize: 35.0,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: usersRef.document(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          User user = User.fromDoc(snapshot.data);

          return ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: user.profileImageUrl.isEmpty
                          ? AssetImage('assets/images/user_placeholder.jpg')
                          : CachedNetworkImageProvider(user.profileImageUrl),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    '12',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'posts',
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    followersCount.toString(),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'followers',
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    followingCount.toString(),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'following',
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          _displayButton(user),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.name,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      height: 80.0,
                      child: Text(
                        user.bio,
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
