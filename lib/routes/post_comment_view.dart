import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/services/db.dart';
import 'package:untitled/services/location.dart';
import 'package:untitled/services/storage.dart';
import 'package:untitled/util/colors.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/util/styles.dart';
import 'package:untitled/util/post.dart';
import 'package:comment_box/comment/comment.dart';


class postCommentView extends StatefulWidget {

  String username;
  String docID;
  int commentNum;

  postCommentView({
    required this.username,
    required this.docID,
    required this.commentNum,
  });

  @override
  State<postCommentView> createState() => _postCommentViewState(username:username,docID: docID, commentNum: commentNum);
}

class _postCommentViewState extends State<postCommentView> {

  AuthService _auth = AuthService();
  String username;
  String docID;
  String title = '';
  String content = '';
  int commentNum;
  List<Map<String,dynamic>> comments = [];

  _postCommentViewState({
    required this.username,
    required this.docID,
    required this.commentNum
  });


  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  Future<void> loadComments() async {
    List<Map<String, dynamic>> loadedComments = await DBService(uid: _auth.userID!).getComments(username, docID);
    List<Map<String, dynamic>> cm = [];
    for (int i = 0; i< loadedComments.length; i++)
      {
        final Map<String,dynamic> comment = {
          "name": loadedComments[i]["username"],
          "message": loadedComments[i]["comment"],
          "pic": await StorageService().profilePictureUrlByUsername(loadedComments[i]["username"]),
        };
        cm.add(comment);
      }
    setState(() {
      comments = cm;
    });
  }

  Future<void> sendComment(String text) async {
    Map<String,dynamic>? comment = await DBService(uid: _auth.userID!).addComment(
        username, docID, text, commentNum);
    setState(() {
      comments.add(comment!);
    });
  }

  Widget commentChild(data) {
    return ListView(
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () async {
                  // Display the image in large form.
                  print("Comment Clicked");
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(data[i]['pic'] + "$i")),
                ),
              ),
              title: Text(
                data[i]['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(data[i]['message']),
            ),
          )
      ],
    );
  }
  @override
  void initState() {
    loadComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: FutureBuilder(
        future: DBService(uid:_auth.userID!).profilePicture,
        builder:(BuildContext context, AsyncSnapshot snapshot)
        {
          if (snapshot.hasData) {
            String pp = snapshot.data;
            return Container(
              child: CommentBox(
                userImage:
                pp,
                child: commentChild(comments),
                labelText: 'Write a comment...',
                withBorder: false,
                errorText: 'Comment cannot be blank',
                sendButtonMethod: () {
                  if (formKey.currentState!.validate()) {
                    print(commentController.text);
                    sendComment(commentController.text);
                    commentController.clear();
                    FocusScope.of(context).unfocus();
                  } else {
                    print("Not validated");
                  }
                },
                formKey: formKey,
                commentController: commentController,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                sendWidget: Icon(
                    Icons.send_sharp, size: 30, color: AppColors.primary),
              ),
            );
          }
          else if (snapshot.hasError){
            print(snapshot.error.toString());
            return Text('something went wrong');
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Center(child:
            CircularProgressIndicator(color: AppColors.primary,)
            ),
          ]
          );
        }
      ),
    );
  }

}