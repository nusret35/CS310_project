import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/profile/profile_Pic_view.dart';
import 'package:untitled/services/crashlytics.dart';
import 'package:untitled/util/styles.dart';
import 'package:untitled/model/user.dart';
import 'package:untitled/routes/edit_profile_view.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/services/db.dart';
import 'package:untitled/util/colors.dart';
import '../services/analytics.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/profile/profile_label_view.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({Key? key}) : super(key: key);


  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {

  final AuthService _auth = AuthService();
  late DBService _db;
  final AppUser currentUser = AppUser(fullname: 'loading', username: 'loading', schoolName: 'loading', email: 'loading', major: 'loading', term: 'loading');
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 12, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            ProfilePicView(),
            SizedBox(width: 8,),
            profileLabelView(labelText: "Shah"),
            //profileLabelView(labelText: currentUser.schoolName),




          ],
    ),
        ),
      ],
    );
  }
}
