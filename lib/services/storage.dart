import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService{
  final Reference postImagesRef = FirebaseStorage.instance.ref().child('posts/images');
  final Reference profilePictureRef = FirebaseStorage.instance.ref().child('profilePictures');

  Future uploadPostImage(String postID,XFile image) async {
    final Reference imagePath = postImagesRef.child(postID);
    await imagePath.putFile(File(image!.path)).catchError((e){
      print(e.toString());
    });
    final String url = await imagePath.getDownloadURL().catchError((e){return e.toString();});
    return url;
  }

  Future uploadProfilePicture(String username, XFile image) async {
    final Reference imagePath = profilePictureRef.child(username);
    await imagePath.putFile(File(image!.path)).catchError((e){
      print(e.toString());
    });
    final String url = await imagePath.getDownloadURL().catchError((e){return e.toString();});
    return url;
  }

  Future uploadUrlProfilePicture(String username, String url) async {
    final Reference imagePath = profilePictureRef.child(username);
    await imagePath.putFile(File(url)).catchError((e){
      print(e.toString());
    });
    return url;
  }

  Future<String> profilePictureUrlByUsername(String username) async {
    final Reference imagePath = profilePictureRef.child(username);
    String url = await imagePath.getDownloadURL().catchError((e){
      print("pp not found");
    }) ?? 'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg';
    return url;
  }

}