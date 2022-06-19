
import  'package:flutter/material.dart';
import 'package:untitled/routes/post_comment_view.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/services/db.dart';
import 'package:untitled/services/storage.dart';
import 'package:untitled/util/colors.dart';
import 'package:untitled/model/user.dart';
import 'package:untitled/util/styles.dart';
import 'package:untitled/util/post.dart';
import 'package:untitled/util/objects.dart';
import 'package:intl/intl.dart';


class OtherUserProfileView extends StatefulWidget {
  String username;
  OtherUserProfileView({required this.username});
  @override
  State<OtherUserProfileView> createState() => _OtherUserProfileViewState(username:username);
}

class _OtherUserProfileViewState extends State<OtherUserProfileView> {


  String username;
  _OtherUserProfileViewState({required this.username});
  bool postsIsEmpty = false;
  AuthService _auth = AuthService();
  List<FormPost> loadedPosts = [];
  String profilePictureURL = '';
  bool friendRequestSentBefore = false;
  bool ownAccount = false;

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

  _leaveComment(){
    setState(() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => postCommentView()));
    });

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

  AppUser findUser(List<AppUser> data) {
    for (int i = 0; i < data.length; i++)
      {
        if (data[i].username == username)
          return data[i];
      }
    return AppUser(fullname: 'fullname', username: 'username', schoolName: 'schoolName', email: 'email', major: 'major', term: 'term');
  }

  Future getProfilePictureURL(String username) async {
    String url = await StorageService().profilePictureUrlByUsername(username);
    setState(() {
      profilePictureURL = url;
    });
  }

  Future loadPosts() async {
    DBService _db = DBService(uid: _auth.userID!);
    List<Post> userPosts = await _db.getUserPosts(username);
    List<FormPost> posts = [];
    for(int i= 0; i< userPosts.length; i++)
    {
      Post post = userPosts[i];
      posts.add(FormPost(title: post.title, content: post.content, time: readTimestamp(post.time!.seconds), likes: post.likes!, comments: post.comments, profilePictureURL: await StorageService().profilePictureUrlByUsername(post.username!), mediaURL: post.mediaURL, docID: post.docID, location: post.location));
    }
    setState(() {
      loadedPosts = posts;
      if (posts.isEmpty)
        {
          postsIsEmpty = true;
        }
    });
  }

  Future checkFriendRequest() async {
    friendRequestSentBefore = await DBService(uid: _auth.userID!).isFriendRequestSentBefore(username);
  }

  Future<bool> checkOwnAccount() async {
    final AppUser cu = await DBService(uid: _auth.userID!).currentUser;
    if (username == cu.username) {
      ownAccount = true;
      return true;
    }
    return false;

  }

  @override
  void initState() {
    getProfilePictureURL(username);
    loadPosts();
    if (checkOwnAccount()==false)
      checkFriendRequest();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        title: Text(
          username,
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
          child: StreamBuilder(
            stream: DBService(uid: _auth.userID!).users,
            builder:(BuildContext context, AsyncSnapshot snapshot)
            {
              if(snapshot.connectionState == ConnectionState.done || snapshot.hasData) {
               List<AppUser> data = snapshot.data as List<AppUser>;
                AppUser user = findUser(data);
                return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Container(
                     height: 150.0,
                     width: 150.0,
                     child: CircleAvatar(
                     backgroundImage: NetworkImage((profilePictureURL != '') ? profilePictureURL : 'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg'),
                       ),
                   ),
                   SizedBox(height: 20.0,),
                   Container(
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         //Spacer(),
                         ownAccount ?
                           SizedBox()
                           :
                           friendRequestSentBefore ?
                           OutlinedButton(onPressed: null,  style: ButtonStyle(
                             backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                             foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                           ),
                             child: Center(
                               child: Padding(
                                 padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 50.0),
                                 child: Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Text('Request sent',
                                         style: TextStyle(
                                             fontSize: 15.0
                                         ),
                                       ),
                                     ]
                                 ),
                               ),
                             ),
                           )
                           :
                           FutureBuilder(
                             future: DBService(uid: _auth.userID!).checkIfUsersAreFriends(username),
                             builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
                               bool areFriends = snapshot.data ?? false;
                            if (areFriends)
                              {
                                return OutlinedButton(
                                  onPressed: null,
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
                                            Text('Friends',
                                              style: TextStyle(
                                                  fontSize: 15.0
                                              ),
                                            ),
                                            Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            ),
                                          ]
                                      ),
                                    ),
                                  ),
                                );
                              }
                            return OutlinedButton(
                             onPressed: (){
                               DBService(uid: _auth.userID!).sendFriendRequestToUsername(username);
                               setState(() {
                                 friendRequestSentBefore = true;
                               });
                             },
                             style: ButtonStyle(
                               backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary),
                               foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                             ),
                             child: Center(
                               child: Padding(
                                 padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 50.0),
                                 child: Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Text('Add as friend',
                                         style: TextStyle(
                                             fontSize: 15.0
                                         ),
                                       ),
                                     ]
                                 ),
                               ),
                             ),
                         );
                                 }
                )
                        // Spacer(),
                      ]
                     ),
                   ),
                   SizedBox(height: 20.0,),
                   Text('Name and Surname',
                   style: kBoldLabelStyle,
                   ),
                   Text(user.fullname,
                   style: kLabelStyle
                     ,),
                   SizedBox(height: 20.0,),
                   Text('University',
                     style: kBoldLabelStyle,
                   ),
                   Text(user.schoolName,
                   style: kLabelStyle,
                   ),
                   SizedBox(height: 20.0,),
                   Text('Major',
                     style: kBoldLabelStyle,
                   ),
                   Text(user.major,
                     style: kLabelStyle,
                   ),
                   SizedBox(height: 20.0,),
                   Text('Term',
                     style: kBoldLabelStyle,
                   ),
                   Text(user.term,
                     style: kLabelStyle,
                   ),
                   SizedBox(height: 20.0,),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.stretch,
                     children:
                     loadedPosts.isNotEmpty ?
                     loadedPosts.map((post) =>

                         PostCard(post,
                       reportButtonAction: () {},
                       likeButtonAction: (){
                         increamentLike(post);
                       }, commentButtonAction: () {
                         _leaveComment();
                     }, starButtonAction: (){
                       favoritePost(post);
                     },
                     )
                     ).toList()
                         :
                         postsIsEmpty ?
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
                         ]
                         :
                         [
                         Center(
                           child: CircularProgressIndicator(
                             color: AppColors.primary,
                           ),
                         ),
                      ]
                   )
                 ],
                )
                );
              }
              else if(snapshot.connectionState == ConnectionState.waiting)
                {
                  return(
                  Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                  );
                }
              else if (snapshot.hasError)
                {
                  return Text(snapshot.error.toString());
                }
              return(Text('not found!'));
            },
          ),
        ),
      ),
    );
  }
}
