import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/services/db.dart';
import 'package:untitled/services/location.dart';
import 'package:untitled/util/colors.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/util/styles.dart';
import 'package:untitled/util/post.dart';
import 'package:comment_box/comment/comment.dart';


class postCommentView extends StatefulWidget {
  const postCommentView({Key? key}) : super(key: key);

  @override
  State<postCommentView> createState() => _postCommentViewState();
}

class _postCommentViewState extends State<postCommentView> {

  AuthService _auth = AuthService();
  String title = '';
  String content = '';
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  Future pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List filedata = [
    {
      'name': 'Adeleye Ayodeji',
      'pic': 'https://picsum.photos/300/30',
      'message': 'I love to code'
    },
    {
      'name': 'Biggi Man',
      'pic': 'https://picsum.photos/300/30',
      'message': 'Very cool'
    },
    {
      'name': 'Biggi Man',
      'pic': 'https://picsum.photos/300/30',
      'message': 'Very cool'
    },
    {
      'name': 'Biggi Man',
      'pic': 'https://picsum.photos/300/30',
      'message': 'Very cool'
    },
  ];

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comment Page"),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        child: CommentBox(
          userImage:
          "https://lh3.googleusercontent.com/a-/AOh14GjRHcaendrf6gU5fPIVd8GIl1OgblrMMvGUoCBj4g=s400",
          child: commentChild(filedata),
          labelText: 'Write a comment...',
          withBorder: false,
          errorText: 'Comment cannot be blank',
          sendButtonMethod: () {
            if (formKey.currentState!.validate()) {
              print(commentController.text);
              setState(() {
                var value = {
                  'name': 'New User',
                  'pic':
                  'https://lh3.googleusercontent.com/a-/AOh14GjRHcaendrf6gU5fPIVd8GIl1OgblrMMvGUoCBj4g=s400',
                  'message': commentController.text
                };
                filedata.insert(0, value);
              });
              commentController.clear();
              FocusScope.of(context).unfocus();
            } else {
              print("Not validated");
            }
          },
          formKey: formKey,
          commentController: commentController,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
        ),
      ),
    );
  }





}


/*
List<String> _comments = ['shah', 'Berfu', 'Buse'];

  void _addComment(String val) {
    setState(() {
      _comments.add(val);
    });
  }

  Widget _buildCommentList() {
    return ListView.builder(
        itemBuilder: (context, index) {
          try {
            if(index < _comments.length) {
              return _buildCommentItem(_comments[index]);
            }
          } catch(e) {
            print(e.toString());
          }
    }
    );
  }

  Widget _buildCommentItem(String comment) {
    return ListTile(title: Text(comment));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text('Comments'),
        centerTitle: true,
        actions: [

        ],
      ),
      body: Column( children: <Widget>[Expanded(child: _buildCommentList()),
        TextField(
          onSubmitted: (String submittedStr) {
            _addComment(submittedStr);
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20.0),
            hintText: "Add comment"
          ),

        )

        ],

      ),


    );
  }
 */