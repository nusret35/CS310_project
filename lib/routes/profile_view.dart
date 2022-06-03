import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/model/user.dart';
import 'package:untitled/routes/edit_profile_view.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/services/db.dart';
import 'package:untitled/util/colors.dart';

import '../services/analytics.dart';

class Profile {
  static const String Name = 'Ali Can';
  static const String Username = 'alican';
  static const String University = 'Sabanci University';
  static const String Major = 'Computer Science';
  static const String Term = 'Sophomore';
}



class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  final AuthService _auth = AuthService();

  DBService _db = DBService(uid: '');

  final AppUser currentUser = AppUser(fullname: 'loading', username: 'loading', schoolName: 'loading', email: 'loading', major: 'loading', term: 'loading');


  @override
  void initState() {
    _db = DBService(uid: _auth.userID!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
          return Scaffold(
            body: SingleChildScrollView(
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(130, 0, 0, 0),
                          child: TextButton(
                            onPressed: () async {
                              await AppAnalytics.setScreenName(
                                  EditProfileView.routename);

                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => EditProfileView()));
                            },
                            child: const Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Arial',
                                fontWeight: FontWeight.w800,
                                color: AppColors.colorRed,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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
                          child: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            radius: MediaQuery
                                .of(context)
                                .size
                                .width * 0.4,
                            backgroundImage: NetworkImage('https://i1.rgstatic.net/ii/profile.image/279526891376650-1443655812881_Q512/Baris-Altop.jpg'),
                          ),
                        ),
                      ),
                    ),
                    FutureBuilder(
                        future: _db.getCurrentUser(),
                        builder:
                        (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData == true)
                            {
                              Map<String,dynamic> data = snapshot.data.data() as Map<String, dynamic>;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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
                                    data["fullname"] ?? 'fullname not found',
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
                          else if (!snapshot.hasData)
                            {
                              print("no data");
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
                  ],
                ),
              ),
            ),
          );
  }
}

