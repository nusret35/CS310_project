import 'package:flutter/material.dart';
import 'package:untitled/routes/add_post_view.dart';
import 'package:untitled/services/db.dart';
import 'package:untitled/services/storage.dart';
import 'package:untitled/util/colors.dart';
import 'package:untitled/util/objects.dart';
import 'package:untitled/services/crashlytics.dart';
import 'package:untitled/services/storage.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/util/post.dart';
import 'package:intl/intl.dart';

class FeedView extends StatefulWidget {
  const FeedView({Key? key}) : super(key: key);
  static const String routename = '/feedView';

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {

  AuthService _auth = AuthService();

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


  Future loadPosts() async {
    DBService _db = DBService(uid: _auth.userID!);
    List<Post> currentUserPosts = await _db.allPostsOfCurrentUser;
    List<Post> friendsPosts = await _db.allPostsFromCurrentUsersFriends;
    List<FormPost> posts = [];
    for(int i = 0; i < friendsPosts.length; i++)
    {
      Post post  = friendsPosts[i];
      posts.add(FormPost(title: post.title, content: post.content, time: readTimestamp(post.time!.seconds), likes: post.likes, comments: post.comments, profilePictureURL: await StorageService().profilePictureUrlByUsername(post.username!), mediaURL: post.mediaURL, docID: post.docID));
    }
    for(int i= 0; i< currentUserPosts.length; i++)
    {
      Post post = currentUserPosts[i];
      posts.add(FormPost(title: post.title, content: post.content, time: readTimestamp(post.time!.seconds), likes: post.likes, comments: post.comments, profilePictureURL: await StorageService().profilePictureUrlByUsername(post.username!), mediaURL: post.mediaURL, docID: post.docID));
    }
     setState(() {
       loadedPosts = posts;
     });
  }

  void increamentLike(FormPost post){
    setState(() {
      post.likes++;
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

  List<FormPost> loadedPosts = [];

  @override
  void initState() {
    DBService(uid: _auth.userID!).friendRequestsStatus();
    loadPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostView()));
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: loadedPosts.map((post) => PostCard(
                  post,
                  likeButtonAction: (){
                    increamentLike(post);
                }, comment: (){;
                }, starButtonAction: (){
                    favoritePost(post);
                    },
                    )
                    ).toList(),
                  ),
                SizedBox(height: 50.0,)
                ]
              ),
            ),
          ),
        ),
      );

  }

  Widget menu() {
    return Container(
        color: AppColors.whiteTextColor,
      child: TabBar(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.grey_tab_control,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: AppColors.primary,
        tabs: [
            Tab(
              text: "Home",
              icon: Icon(Icons.home),
            ),
            Tab(
              text: "Search",
              icon: Icon(Icons.search),
            ),
            Tab(
              text: "Chat",
              icon: Icon(Icons.chat),
            ),
            Tab(
              text: "Schedule",
              icon: Icon(Icons.calendar_month_outlined),
            ),
             Tab(
               text: "Profile",
               icon: Icon(Icons.person),
              ),
        ],

      ),
    );
  }
}
