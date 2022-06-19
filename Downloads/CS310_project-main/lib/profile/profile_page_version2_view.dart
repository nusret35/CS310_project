import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:untitled/services/crashlytics.dart';
import 'package:untitled/util/styles.dart';
import 'package:untitled/model/user.dart';
import 'package:untitled/routes/edit_profile_view.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/services/db.dart';
import 'package:untitled/util/colors.dart';
import '../services/analytics.dart';
import 'package:image_picker/image_picker.dart';

import 'Profile_Book_Mark_View.dart';
import 'Profile_Post_View.dart';


class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  final AuthService _auth = AuthService();
  late DBService _db;
  final AppUser currentUser = AppUser(fullname: 'loading', username: 'loading', schoolName: 'loading', email: 'loading', major: 'loading', term: 'loading');
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    }
    );
  }

  Future<void> updateImage() async {
    Navigator.of(context).pop();
    await pickImage();
    await _db.updateProfilePicture(_image!);
  }

  Future<void> _changingProfilePictureDialog() async {
    bool isAndroid = Platform.isAndroid;
    String title = 'Changing Profile Picture';
    String message = 'Do you want to change your profile picture?';
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          if(isAndroid) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(message),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      updateImage();
                    },
                    child: Text('Yes')
                ),
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          } else {
            return CupertinoAlertDialog(
              title: Text(title, style: kBoldLabelStyle),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(message, style: kLabelStyle),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    pickImage();
                  },
                  child: Text('Yes',),
                ),
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }

        });
  }

  Future<void> _showDialog(String title, String message) async {
    bool isAndroid = Platform.isAndroid;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          if(isAndroid) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(message),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          } else {
            return CupertinoAlertDialog(
              title: Text(title, style: kBoldLabelStyle),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(message, style: kLabelStyle),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
        });
  }





  @override
  void initState() {
    _db = DBService(uid: _auth.userID!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
        child: Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Your Profile',
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Arial',
                            color: AppColors.textColor,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () async {
                            await AppAnalytics.setScreenName(
                                EditProfileView.routename);

                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => EditProfileView()));
                          },
                          icon: Icon(
                            Icons.edit,
                            color: AppColors.primary,
                          ),
                        )
                      ],
                    ),
                    FutureBuilder(
                        future: _db.getCurrentUserSnapshot(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData == true)
                          {
                            Map<String,dynamic> data = snapshot.data.data() as Map<String, dynamic>;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: Center(
                                    child: SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.4,
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.4,
                                      child:ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: CircleBorder(),
                                          padding: EdgeInsets.all(0),
                                        ),
                                        onPressed: _changingProfilePictureDialog,
                                        child: CircleAvatar(
                                          backgroundColor: AppColors.primary,
                                          radius: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.4,
                                          backgroundImage: NetworkImage(data['photoURL'] ?? 'https://i1.rgstatic.net/ii/profile.image/279526891376650-1443655812881_Q512/Baris-Altop.jpg'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(padding: const EdgeInsets.fromLTRB(0, 40, 0, 0)),
                                Text(
                                  'Name and Surname',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'Arial',
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Text(
                                  data['fullname'] ?? 'fullname not found',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Arial',
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Padding(padding: const EdgeInsets.fromLTRB(0, 25, 0, 0)),
                                Text(
                                  'Username',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'Arial',
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Text(
                                  data['username'] ?? 'username not found',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Arial',
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Padding(padding: const EdgeInsets.fromLTRB(0, 25, 0, 0)),
                                Text(
                                  'University',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'Arial',
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Text(
                                  data['schoolName'] ?? 'schoolName not found',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Arial',
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Padding(padding: const EdgeInsets.fromLTRB(0, 25, 0, 0)),
                                Text(
                                  'Major',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'Arial',
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Text(
                                  data['major'] ?? 'major not found',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Arial',
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Padding(padding: const EdgeInsets.fromLTRB(0, 25, 0, 0)),
                                Text(
                                  'Term',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'Arial',
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Text(
                                  data['term'] ?? 'term not found',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Arial',
                                    color: AppColors.textColor,
                                  ),
                                ),
                              ],
                            );

                          }
                          else if (snapshot.connectionState == ConnectionState.none)
                          {
                            _showDialog(
                                'Lost connection to service',
                                'Please reconnect to your service'
                            );
                          }
                          else if (snapshot.hasError)
                          {
                            CrashService.recordError(snapshot.error, snapshot.stackTrace, snapshot.error.toString(), false);
                            _showDialog(
                                'Error occured',
                                snapshot.error.toString()
                            );

                          }
                          return Center(child:
                          Column(
                              children: [
                                SizedBox(height: 50.0,),
                                CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ]
                          )
                          );
                        }
                    ),
                    Divider(height: 1,color: Colors.grey.shade400,),
                    TabBar(
                        tabs: [
                          Tab(icon: Icon(Icons.person, color: Colors.purple,),

                          ),
                          Tab(icon: Icon(Icons.grid_3x3_outlined, color: Colors.purple,),)
                        ]),

                    TabBarView(
                      children: [
                        ProfilePostView(),
                        ProfileBookMarkView(),

                      ],

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




