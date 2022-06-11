import 'package:flutter/material.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/services/db.dart';
import 'package:untitled/util/colors.dart';
import 'package:untitled/model/user.dart';


class OtherUserProfileView extends StatefulWidget {
  const OtherUserProfileView({Key? key}) : super(key: key);

  @override
  State<OtherUserProfileView> createState() => _OtherUserProfileViewState();
}

class _OtherUserProfileViewState extends State<OtherUserProfileView> {
  
  AuthService _auth = AuthService();

  String username = 'nusretk';

  AppUser findUser(List<Map<String,dynamic>> data) {
    for (int i = 0; i < data.length; i++)
      {
        if (data[i]["username"] == username)
          return AppUser.fromJson(data[i]);
      }
    return AppUser(fullname: 'fullname', username: 'username', schoolName: 'schoolName', email: 'email', major: 'major', term: 'term');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        title: Text(
          'username',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20.0
          ) ,
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: StreamBuilder(
            stream: DBService(uid: _auth.userID!).allUsers,
            builder:(BuildContext context, AsyncSnapshot snapshot)
            {
              if(snapshot.connectionState == ConnectionState.done || snapshot.hasData) {
                print(snapshot.hasData == 1);
                List<Map<String, dynamic>> data = snapshot.data as List<
                    Map<String, dynamic>>;
                AppUser user = findUser(data);
                return Text(user.email);
              }
              else if(snapshot.connectionState == ConnectionState.waiting)
                {
                  return(Text('waiting'));
                }
              else if (snapshot.hasError)
                {
                  return Text(snapshot.error.toString());
                }
              return(Text('not found'));
            },
          ),
        ),
      ),
    );
  }
}
