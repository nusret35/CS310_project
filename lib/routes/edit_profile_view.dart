import 'package:flutter/material.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/services/db.dart';
import 'package:untitled/util/colors.dart';
import 'package:untitled/model/user.dart';

class Dimension {
  static const double parentMargin = 16.0;

  static get regularPadding => EdgeInsets.all(parentMargin);
}

class EditProfileView extends StatefulWidget {
  static const routename = '/editProfile';

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}
class _EditProfileViewState extends State<EditProfileView>
{
  String fullname = '';
  String username = '';
  String university = '';
  String major = '';
  String term = '';

  String dropDownText = 'Choose your term';

  AuthService _auth = AuthService();

  AppUser? currentUser;

  final _formKey = GlobalKey<FormState>();

  Future _saveChangesAndPop() async {
    _formKey.currentState!.save();
    await DBService(uid:_auth.userID!).updateCurrentUserData(fullname, username, university, major, term);
    Navigator.of(context).pop(true);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        actions: [
          IconButton(
              onPressed: _saveChangesAndPop,
              icon: Icon(Icons.done),
              color: Colors.white,
          ),
        ],
        title: Text(
          'Edit Profile',
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(35, 25, 0, 0),
            child: FutureBuilder(
              future: DBService(uid: _auth.userID!).currentUser,
              builder: (BuildContext context, AsyncSnapshot<AppUser> user){
                AppUser? currentUser = user.data;
                fullname = currentUser!.fullname;
                username = currentUser!.username;
                university = currentUser!.schoolName;
                major = currentUser!.major;
                term = currentUser!.term;
                return Form(
                  key: _formKey,
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name and Surname',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Padding(padding: const EdgeInsets.fromLTRB(0, 5, 0, 0)),
                    Container(
                      width: 350.0,
                      child: TextFormField(
                        onSaved: (value){
                          fullname = value ?? currentUser!.fullname;
                        },
                        initialValue: fullname,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your name and surname',
                        ),
                      ),
                    ),
                    Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Padding(padding: const EdgeInsets.fromLTRB(0, 5, 0, 0)),
                    Container(
                      width: 350.0,
                      child: TextFormField(
                        onSaved: (value){
                          username = value ?? currentUser!.username;
                        },
                        initialValue: username,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your username',
                        ),
                      ),
                    ),
                    Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 0)),

                    Text(
                      'University',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Padding(padding: const EdgeInsets.fromLTRB(0, 5, 0, 0)),
                    Container(
                      width: 350.0,
                      child: TextFormField(
                        onSaved: (value){
                          university = value ?? currentUser!.schoolName;
                        },
                        initialValue: university,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your university',
                        ),
                      ),
                    ),
                    Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    Text(
                      'Major',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Padding(padding: const EdgeInsets.fromLTRB(0, 5, 0, 0)),
                    Container(
                      width: 350.0,
                      child: TextFormField(
                        onSaved: (value){
                          major = value ?? currentUser!.major;
                        },
                        initialValue: major,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your major',
                        ),
                      ),
                    ),

                    Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    Text(
                      'Term',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Padding(padding: const EdgeInsets.fromLTRB(0, 5, 0, 0)),
                    DropdownButton(
                      hint: Text(term),

                      items: <String>['Prep', 'Freshman', 'Sophomore', 'Junior', 'Senior'].map((String value) {
                        return DropdownMenuItem<String>(

                          value: value,
                          child: Text(value),
                        );

                      }).toList(),
                      onChanged: (t) {
                        setState(() {
                          term = t.toString();
                        });
                      },
                    ),
                  ],
                ),
              );
            }
            ),
          ),
        ),
      ),
    );
  }
}