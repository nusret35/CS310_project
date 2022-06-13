import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';



class Post {
  String docID;
  String? username;
  String title;
  String content;
  Timestamp? time;
  XFile? media;
  String? mediaURL = '';
  int likes = 0;
  int comments = 0;

  Post({
    required this.docID,
    required this.username,
    required this.title,
    required this.content,
    this.time,
    this.media
  });

  Post.fromNetwork({
    required this.docID,
    required this.username,
    required this.title,
    required this.content,
    this.time,
    this.mediaURL
  });
}