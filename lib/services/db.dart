

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:untitled/model/user.dart';
import 'package:untitled/services/storage.dart';
import 'package:untitled/util/post.dart';

class DBService {
  final String uid;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference postCollection = FirebaseFirestore.instance.collection('posts');
  final CollectionReference topicCollection = FirebaseFirestore.instance.collection('topics');
  final CollectionReference friendRequestCollection = FirebaseFirestore.instance.collection('friendRequest');
  final CollectionReference notificationCollection = FirebaseFirestore.instance.collection('notifications');

  final usersRef = FirebaseFirestore.instance.collection('users').withConverter<AppUser>(
      fromFirestore: (snapshot, _) => AppUser.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJson()
  );

  late String username;

  DBService({
    required this.uid
  });

  Future createUser(String fullname, String schoolName, String username, String major, String term, String email) async {
    userCollection.doc(uid).set({
      'fullname': fullname,
      'username':username,
      'schoolName': schoolName,
      'major': major,
      'term': term,
      'email': email,
      'photoURL': 'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg'
    })
    .then((value) => print('User added'))
        .catchError((error) => print('Error: ${error.toString()}'));
  }

  Future sendPost(Post post) async {
    try {
      AppUser cu = await currentUser as AppUser;
      String docID = '${cu.username}-${DateTime.now()}';
      if (post.media != null)
        {
          post.mediaURL = await StorageService().uploadPostImage(docID, post.media!);
        }
      await postCollection.doc(cu.username).collection('posts').doc(docID).set({
        'username':cu.username,
        'title': post.title,
        'content': post.content,
        'time': Timestamp.now(),
        'likes': 0,
        'comments': 0,
        'url':post.mediaURL ?? '',
        'location':post.location ?? ''
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future sendTagPost(Post post) async {
    try {
      AppUser cu = await currentUser as AppUser;
      String docID = '${cu.username}-${DateTime.now()}';
      if (post.media != null)
      {
        post.mediaURL = await StorageService().uploadPostImage(docID, post.media!);
      }
      await FirebaseFirestore.instance.collection('topics').doc(post.title).collection('posts').doc(docID).set({
        'username':cu.username,
        'title': post.title,
        'content': post.content,
        'time': Timestamp.now(),
        'likes': 0,
        'comments': 0,
        'url':post.mediaURL ?? '',
        'location':post.location ?? ''
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future<Map<String,dynamic>?> addComment(String username, String docID, String comment, int comments) async {
    try {
      AppUser cu = await currentUser as AppUser;
      String docIDC = '${cu.username}-${DateTime.now()}';
      await postCollection.doc(username).collection('posts').doc(docID).collection('userComments').doc(docIDC).set({
        'comment' : comment
      });
      await updateComments(username, docID,comments);
      return {
        "name": username,
        "message": comment,
        "pic": await profilePicture,
      };
    } catch(e) {
      print(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getComments(String username, String docID) async {

    QuerySnapshot snapshot = await postCollection.doc(username).collection('posts').doc(docID).collection('userComments').get();
    return snapshot.docs.map((doc) {
      String username = doc.id.substring(0, doc.id.indexOf('-'));
      return {
        "username": username,
        "comment": doc.get("comment"),
      };
    }).toList();
  }

  Future<bool> updateLike(String userName, String docID, int likeNum) async {
    AppUser cu = await currentUser as AppUser;
    bool likeBefore = await islikedBefore(userName, docID);
    try {
      if(!likeBefore) {
        await postCollection.doc(userName).collection('posts').doc(docID).update({
          'likes' : likeNum
        });
        print('like incremented');
        await postCollection.doc(userName).collection('posts').doc(docID).collection('likedUser').doc(cu.username).set({});
        await _sendLikeNotification(userName, docID, likeNum);
      }

    } catch(e) {
      print(e.toString());
    }
    return !likeBefore;
  }
  
  Future<void> updateComments(String username, String docID, int commentNum) async {
    commentNum+= 1;
    await postCollection.doc(username).collection("posts").doc(docID).update({
      "comments": commentNum
    });
  }

  Future _sendLikeNotification(String username, String docID, int likeNumber) async {
    AppUser cu = await currentUser;
    notificationCollection.doc(username).collection('likes').doc('${docID}-${likeNumber.toString()}').set({
      "username" : cu.username,
      "timestamp" : Timestamp.now(),
    });
  }

  Future<bool> islikedBefore(String userName, String docID) async {

    AppUser cu = await currentUser as AppUser;
    DocumentSnapshot snapshot = await postCollection.doc(userName).collection('posts').doc(docID).collection('likedUser').doc(cu.username).get();
    print(snapshot.exists);
    if(!snapshot.exists) {
      return false;
    }
    else {
      return true;
    }
  }


  Future sendFriendRequestToUsername(String username) async {
    AppUser cu = await currentUser;
    await friendRequestCollection.doc(username).collection('requests').doc(cu.username).set({"status": "pending"});
    await friendRequestCollection.doc(cu.username).collection('sentRequests').doc(username).set({"status": "pending"});
  }


  Future followTopic(String topic) async {
    await userCollection.doc(uid).collection('followedTopics').doc(topic).set({});
  }

  Future<bool> isFriendRequestSentBefore(String username) async {
    AppUser cu = await currentUser;
    DocumentSnapshot snapshot = await friendRequestCollection.doc(username).collection('requests').doc(cu.username).get();
    if(snapshot.exists)
      return true;
    return false;
  }

  Future<bool> checkIfUsersAreFriends(String username) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).collection("friends").doc(username).get();
    if (snapshot.exists)
      return true;
    return false;
  }



  Future friendRequestsStatus() async {
    AppUser uc = await currentUser;
    QuerySnapshot snapshot = await friendRequestCollection.doc(uc.username).collection("sentRequests").get();
    if (snapshot.docs.isNotEmpty) {
      final List<Map<String, dynamic>> requestsList = await snapshot.docs.map((
          doc) {
        return {
          "username": doc.id,
          "status": doc.get("status"),
        };
      }).toList();
      for (int i = 0; i < requestsList.length; i++) {
        if (requestsList[i]["status"] == "accepted") {
          userCollection.doc(uid).collection("friends").doc(
              requestsList[i]["username"]).set({});
        }
      }
    }
  }

  Future acceptFriendRequest(String username) async {
    AppUser cu = await currentUser;
    await userCollection.doc(uid).collection("friends").doc(username).set({});
    await friendRequestCollection.doc(cu.username).collection("requests").doc(username).delete();
    await friendRequestCollection.doc(username).collection('sentRequests').doc(cu.username).set({"status": "accepted"});
  }

  Future declineFriendRequest(String username) async {
    AppUser cu = await currentUser;
    await friendRequestCollection.doc(cu.username).collection("requests").doc(username).delete();
  }

  Future createUserWithGoogle(String fullname, String schoolName, String username, String major, String term, String email, String photoURL) async {
    userCollection.doc(uid).set({
      'fullname': fullname,
      'username': username,
      'schoolName': schoolName,
      'major': major,
      'term': term,
      'email': email,
      'photoURL': photoURL
    })
        .then((value) => print('User added'))
        .catchError((error) => print('Error: ${error.toString()}'));
    StorageService().uploadUrlProfilePicture(username, photoURL);
  }

  List<AppUser> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
      return AppUser.fromJson(json);
    }).toList();
  }

  List<Post> _postsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return Post.fromNetwork(
        docID: doc.id,
        username: doc.get('username'),
        title: doc.get('title'),
        time: doc.get('time'),
        content: doc.get('content'),
        mediaURL: doc.get('url'),
        location: doc.get('location'),
        likes: doc.get('likes'),
        comments: doc.get('comments')
      );
    }).toList();
  }

  Future<List<Post>> getUserPosts(String username) async {
    final CollectionReference ref = postCollection.doc(username).collection('posts');
    QuerySnapshot snapshot = await ref.get();
    List<Post> postsOfUser = await _postsListFromSnapshot(snapshot);
    return _sortPosts(postsOfUser);
  }

  Future<List<Post>> getTopicPosts(String topic) async {
    final CollectionReference ref = topicCollection.doc(topic).collection('posts');
    QuerySnapshot snapshot = await ref.get();
    List<Post> postsOfTopic = await _postsListFromSnapshot(snapshot);
    return _sortPosts(postsOfTopic);
  }


  List<Post> _sortPosts(List<Post> posts) {
    List<Post> sortedPosts = [];
    while (posts.isNotEmpty) {
      Post currentPost = posts[0];
      for (int i = 0; i < posts.length; i++) {
        if (DateTime.fromMillisecondsSinceEpoch(posts[i].time!.seconds * 1000)
            .isAfter(DateTime.fromMillisecondsSinceEpoch(
            currentPost.time!.seconds * 1000))) {
          currentPost = posts[i];
        }
      }
      sortedPosts.add(currentPost);
      posts.remove(currentPost);
    }
    return sortedPosts;
  }

  List<Map<String, dynamic>> _sortLikeNotifications(List<Map<String, dynamic>> notifications) {
    print(notifications.length);
    List<Map<String, dynamic>> sortedNot = [];
    while (notifications.isNotEmpty) {
    Map<String, dynamic> currentNot = notifications[0];
    for (int i = 0; i < notifications.length ; i++){
      Timestamp currentTimestamp = currentNot["timestamp"] as Timestamp;
      Timestamp notTimestamp = notifications[i]["timestamp"] as Timestamp;
      if (DateTime.fromMillisecondsSinceEpoch(notTimestamp.seconds * 1000).isAfter(DateTime.fromMillisecondsSinceEpoch(currentTimestamp.seconds * 1000))) {
          currentNot = notifications[i];
        }
      }
      sortedNot.add(currentNot);
      notifications.remove(currentNot);
    }
    return sortedNot;
  }

  List<Map<String, dynamic>> _searchUserResultListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return
      {
        "fullname": doc.get("fullname"),
        "username": doc.get("username"),
        "photoURL": doc.get("photoURL"),
    };
    }).toList();
  }

  List<String> _searchTopicResultListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return doc.id;
    }).toList();
  }

  List<Map<String, dynamic>> _likeNotifications(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return
        {
        "username": doc.get("username"),
        "timestamp": doc.get("timestamp"),
        };
    }).toList();
  }


  Future<DocumentSnapshot> getCurrentUserSnapshot() async {
    return await userCollection.doc(uid).get().catchError((e) {
      print(e.toString());
    });
  }

  Future<QuerySnapshot> getFriendsOfCurrentUserSnapshot() async {
    final CollectionReference friendsCollectionRef = userCollection.doc(uid).collection('friends');
    return await friendsCollectionRef.get().catchError((e) {
      print(e.toString());
    });
  }


  Future<AppUser> get currentUser async {
    Future<DocumentSnapshot> apiSnapshot = getCurrentUserSnapshot();
    DocumentSnapshot snapshot = await apiSnapshot;

    return AppUser.fromJson(snapshot.data() as Map<String,dynamic>);

  }

  Future<List<String>> get friendsOfCurrentUser async {
    QuerySnapshot snapshot = await getFriendsOfCurrentUserSnapshot();
    return snapshot.docs.map((doc) {
      return doc.reference.id;
    }).toList();
  }

  Future<List<Post>> get allPostsOfCurrentUser async {
    AppUser user = await currentUser;
    return await getUserPosts(user.username);
  }

  Future<List<Post>> get allPostsFromCurrentUsersFriends async {
    List<String> friends = await friendsOfCurrentUser;
    List<Post> posts = [];
    for(int i = 0; i< friends.length ; i++) {
      String username = friends[i];
      posts += await getUserPosts(username);
    }
    return posts;
  }

  Future updateCurrentUserData(String fullname, String username, String schoolName, String major, String term) async {
    userCollection.doc(uid).update({
      'username': username,
      'fullname':fullname,
      'schoolName':schoolName,
      'major':major,
      'term':term,
    });
  }

  Future updateProfilePicture(XFile image) async {
    AppUser cu = await currentUser;
    String profilePictureURL = await StorageService().uploadProfilePicture(cu.username, image);
    userCollection.doc(uid).update({
      'photoURL': profilePictureURL
    });
  }

  Future<String> get profilePicture async {
    AppUser cu = await currentUser;
    String url = await StorageService().profilePictureUrlByUsername(cu.username);
    return url;
  }

  Future<void> addFriend(String username) async {
    await userCollection.doc(uid).collection('friends').doc(username).set({
      'time': DateTime.now()
    });
  }

  Future<void> deleteAccount() async {
    AppUser user = await currentUser;
    await userCollection.doc(uid).delete();
    await postCollection.doc(user.username).delete();
  }

  Future<List<Map<String, dynamic>>> get likeNotifications async{
    AppUser uc = await currentUser;
    QuerySnapshot snapshot = await notificationCollection.doc(uc.username).collection('likes').get();
    List<Map<String, dynamic>> notifications = _likeNotifications(snapshot);
    return _sortLikeNotifications(notifications);
  }

  Stream<List<AppUser>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  Stream<List<Map<String, dynamic>>> get searchResults {
    return  userCollection.snapshots().map(_searchUserResultListFromSnapshot);
  }

  Future<List<String>> get topicSearchResults async {
    QuerySnapshot snapshot = await topicCollection.get();
    return _searchTopicResultListFromSnapshot(snapshot);
  }


  AppUser? _getRealTimeUser(DocumentSnapshot snapshot) {
    final Map<String,dynamic> json = snapshot.data() as Map<String,dynamic>;
    return AppUser.fromJson(json);
  }

  Stream<AppUser?> get realTimeUser {
    return userCollection.doc(uid).snapshots().map(_getRealTimeUser);
  }

  Future<List<String>> get friendRequests async {
    AppUser cu = await currentUser;
    QuerySnapshot snapshot = await friendRequestCollection.doc(cu.username).collection('requests').get();
    final List<String> allRequests = snapshot.docs.map((doc) => doc.id).toList();
    return allRequests;
  }


}
