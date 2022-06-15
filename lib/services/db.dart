
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'package:untitled/model/user.dart';
import 'package:untitled/services/storage.dart';
import 'package:untitled/util/post.dart';

class DBService {
  final String uid;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference postCollection = FirebaseFirestore.instance.collection('posts');
  final CollectionReference friendRequestCollection = FirebaseFirestore.instance.collection('friendRequest');

  final usersRef = FirebaseFirestore.instance.collection('users').withConverter<AppUser>(
      fromFirestore: (snapshot, _) => AppUser.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJson()
  );

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
      await postCollection.doc(cu.username).collection('posts').doc(docID).set({
        'username':cu.username,
        'title': post.title,
        'content': post.content,
        'time': Timestamp.now(),
        'likes': 0,
        'comments': 0,
        'url':'',
      });
      if (post.media != null)
        {
          String url = await StorageService().uploadPostImage(docID,post.media!);
          await postCollection.doc(cu.username).collection('posts').doc(docID).update({
            'url':url
          });
        }
    } catch(e) {
      print(e.toString());
    }
  }

  Future updateLike(String userName, String docID, int likeNum) async {
    AppUser cu = await currentUser as AppUser;
    try {
      bool likeBefore = await islikedBefore(cu.username, docID);
      if(!likeBefore) {
        await postCollection.doc(userName).collection('posts').doc(docID).update({
          'likes' : likeNum
        });
        print('like incremented');
        await postCollection.doc(userName).collection('posts').doc(docID).collection('likedUser').doc(cu.username).set({});

      }



    } catch(e) {
      print(e.toString());
    }
  }

  Future<bool> islikedBefore(String userName, String docID) async {

    AppUser cu = await currentUser as AppUser;
    DocumentSnapshot snapshot = await postCollection.doc(userName).collection('posts').doc(docID).collection('likedUser').doc(cu.username).get();
    print(snapshot.exists);
    if(!snapshot.exists) {
      print("flsae");
      return false;
    }
    else {
      print('tur');
      return true;
    }
  }

  Future sendFriendRequestToUsername(String username) async {
    AppUser cu = await currentUser;
    await friendRequestCollection.doc(username).collection('requests').doc(cu.username).set({"status": "pending"});
    await friendRequestCollection.doc(cu.username).collection('sentRequests').doc(username).set({"status": "pending"});
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
    final List<Map<String,dynamic>> requestsList =  await snapshot.docs.map((doc){
                                              return {
                                                "username": doc.id,
                                                "status": doc.get("status"),
                                              };
                                              }).toList();
    for (int i=0; i < requestsList.length; i++){
      if (requestsList[i]["status"] == "accepted"){
        userCollection.doc(uid).collection("friends").doc(requestsList[i]["username"]).set({});
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
      Map<String, dynamic> json = doc as Map<String, dynamic>;
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
      );
    }).toList();
  }

  Future<List<Post>> getUserPosts(String username) async {
    final CollectionReference ref = postCollection.doc(username).collection('posts');
    QuerySnapshot snapshot = await ref.get();
    List<Post> postsOfUser = await _postsListFromSnapshot(snapshot);
    return postsOfUser;
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

  Stream<List<AppUser>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  Stream<List<Map<String, dynamic>>> get searchResults {
    return  userCollection.snapshots().map(_searchUserResultListFromSnapshot);
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
