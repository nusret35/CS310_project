import 'package:flutter/material.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/util/colors.dart';
import 'package:untitled/util/objects.dart';
import 'package:intl/intl.dart';
import 'package:untitled/routes/post_comment_view.dart';
import 'package:untitled/util/post.dart';
import 'package:untitled/services/db.dart';
import 'package:untitled/services/storage.dart';

class TopicPostsView extends StatefulWidget {
  String topic;

  TopicPostsView({
    required this.topic,
  });

  @override
  State<TopicPostsView> createState() => _TopicPostsViewState(topic: topic);
}

class _TopicPostsViewState extends State<TopicPostsView> {

  String topic;
  List<FormPost> loadedPosts = [];
  bool postsIsEmpty = false;
  bool isFollowing = false;
  AuthService _auth = AuthService();
  Color buttonColor  = AppColors.primary;
  String buttonTitle = 'Follow';

  _TopicPostsViewState({
  required this.topic
  });

  void increamentLike(FormPost post){
    setState(() {
      post.likes++;
    });
  }

  void reportUser(FormPost post) async {
    DBService _db = DBService(uid: _auth.userID!);
    String username = post.docID.substring(0, post.docID.indexOf('-'));
    await _db.reportUser(username);
  }

  Future loadPosts() async {
    DBService _db = DBService(uid: _auth.userID!);
    List<Post> userPosts = await _db.getTopicPosts(topic);
    List<FormPost> posts = [];
    for(int i= 0; i< userPosts.length; i++)
    {
      Post post = userPosts[i];
      posts.add(FormPost(title: post.title, content: post.content, time: readTimestamp(post.time!.seconds), likes: post.likes!, comments: post.comments!, profilePictureURL: await StorageService().profilePictureUrlByUsername(post.username!), mediaURL: post.mediaURL, docID: post.docID, location: post.location));
    }
    setState(() {
      loadedPosts = posts;
      if (posts.isEmpty)
      {
        postsIsEmpty = true;
      }
    });
  }

  Future checkIfFollows() async {
     isFollowing = await DBService(uid: _auth.userID!).checkIfUserFollowingTheTopic(topic);
  }

  Future followTopic() async {
    DBService(uid: _auth.userID!).followTopic(topic);
    setState(() {
    buttonColor = Colors.lightBlueAccent;
      buttonTitle = 'Followed';
    });
  }

  void favoritePost(FormPost post){
    setState(() {
      if (post.postFavorited == false)
      {
        post.postFavorited = true;
      }
      else
      {
        post.postFavorited = false;
      }
    });
  }

  _leaveComment(String docID, int commentNum){
    String username = docID.substring(0, docID.indexOf('-'));
    Navigator.push(context, MaterialPageRoute(builder: (context) => postCommentView(username: username, docID: docID,commentNum: commentNum ,)));
  }


  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds >= 0 && diff.inSeconds < 60){
      time = diff.inSeconds.toString() + ' second ago';
    } else if (diff.inMinutes > 0 && diff.inMinutes < 60){
      if (diff.inMinutes.toInt() == 1) {
        time = '1 minute ago';
      }
      else {
        time = diff.inMinutes.toString() + ' minutes ago';
      }
    } else if (diff.inHours > 0 && diff.inHours < 24) {
      if (diff.inHours.toInt() == 1) {
        time = '1 hour ago';
      }
      else {
        time = diff.inHours.toString() + ' hours ago';
      }
    }
    else if (diff.inDays == 0) {
      time = 'Today';
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' days ago';
      } else {
        time = diff.inDays.toString() + ' days ago';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' weeks ago';
      } else {

        time = (diff.inDays / 7).floor().toString() + ' weeks ago';
      }
    }

    return time;
  }

  @override
  void initState() {
    checkIfFollows();
    loadPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        title: Text(
          topic,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20.0
          ) ,
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isFollowing ?
                  OutlinedButton(onPressed: null,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 50.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Following',
                                  style: TextStyle(
                                      fontSize: 15.0
                                  ),
                                ),
                              ]
                          ),
                        ),
                      )
                  )
                  :
                  OutlinedButton(onPressed: followTopic,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 50.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(buttonTitle,
                              style: TextStyle(
                                  fontSize: 15.0
                              ),
                            ),
                          ]
                      ),
                    ),
                  )
                  ),
              SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: loadedPosts.isNotEmpty ?
                loadedPosts.map((post) =>
                    PostCard(
                      post,
                      likeButtonAction: (){
                        increamentLike(post);
                      }, commentButtonAction: () {
                      _leaveComment(post.docID, post.comments);
                    }, starButtonAction: (){
                      favoritePost(post);
                    },
                      reportButtonAction: (){
                        reportUser(post);
                      },
                    )
                ).toList()
                    :
                [
                  Center(
                    child: Text(
                      'No posts',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0
                      ),
                    ),
                  )
                ],
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
