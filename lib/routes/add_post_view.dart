import 'dart:io';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/services/db.dart';
import 'package:untitled/util/colors.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/util/styles.dart';
import 'package:untitled/util/post.dart';

class AddPostView extends StatefulWidget {
  const AddPostView({Key? key}) : super(key: key);

  @override
  State<AddPostView> createState() => _AddPostViewState();
}

class _AddPostViewState extends State<AddPostView> {

  AuthService _auth = AuthService();
  String title = '';
  String content = '';
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  Future pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<void> addPost() async
  {
    DBService db = DBService(uid: _auth.userID!);
    _formKey.currentState!.save();
    db.sendPost(Post(username:'',title: title, content: content, media: _image,docID: ''));
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text('Add post'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: addPost,
              icon:Icon(Icons.add)
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Title',
                    style: kBoldLabelStyle,
                  ),
                  SizedBox(height: 8.0,),
                  Container(
                    color: Colors.white12,
                    child: TextFormField(
                      onSaved: (value){
                        title = value ?? '';
                      },
                      maxLines: 2,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Enter the title of your post',
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0,),
                  Text(
                    'Content',
                    style: kBoldLabelStyle,
                  ),
                  SizedBox(height: 8.0,),
                  Container(
                    color: Colors.white12,
                    child: TextFormField(
                      onSaved: (value){
                        content = value ?? '';
                        },
                      maxLines: 7,
                      decoration: InputDecoration.collapsed(
                        hintText: "What's going on?",
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: (_image != null) ?
                        Image(
                          image: XFileImage(_image!))
                        :
                    InputChip(
                        onPressed: pickImage,
                        backgroundColor: AppColors.primary,
                        label: Container(
                          width: 160.0,
                          height: 20.0,
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Text(
                                'Add photo or video...',
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              )
                            ],
                          ),
                        )

                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

