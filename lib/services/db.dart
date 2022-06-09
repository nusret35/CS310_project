import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled/model/user.dart';
import 'package:untitled/routes/search_view.dart';

class DBService {
  final String uid;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

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
  }

  List<AppUser> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return AppUser(
          fullname: doc.get("fullname"),
          username: doc.get("username"),
          email: doc.get("email"),
          schoolName: doc.get("schoolName"),
          major: doc.get("major"),
          term: doc.get("term"),
      );
    }).toList();
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

  Future<DocumentSnapshot> getCurrentUser() async {
    return await userCollection.doc(uid).get();
}

  Stream<List<AppUser>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  Stream<List<Map<String, dynamic>>> get searchResults {
    return userCollection.snapshots().map(_searchUserResultListFromSnapshot);
  }


}
