import 'package:flutter/material.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/services/db.dart';
import 'package:untitled/util/colors.dart';
import 'package:untitled/tab_controller.dart';

class GoogleLoginFinishView extends StatefulWidget {

  final String fullname;
  final String email;
  final String photoURL;

  GoogleLoginFinishView(
      this.fullname,
      this.email,
      this.photoURL,
      );

  @override
  State<GoogleLoginFinishView> createState() => _GoogleLoginFinishViewState(fullname,email,photoURL);
}

class _GoogleLoginFinishViewState extends State<GoogleLoginFinishView> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  final String fullname;
  final String email;
  final String photoURL;

  String username = '';
  String schoolName = '';
  String major = '';
  String term = 'Prep';
  bool _isLoading = false;

  _GoogleLoginFinishViewState(
      this.fullname,
      this.email,
      this.photoURL
      );

  String capitalize(String word)
  {
    if (word.contains(' '))
      return '${word[0].toUpperCase()}${word.substring(1,word.indexOf(' ')).toLowerCase()} ${word[word.indexOf(' ')+1].toUpperCase()}${word.substring(word.indexOf(' ')+2).toLowerCase()}';
    return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
  }
  
  Future _loginUser() async {
    setState(() {
      _isLoading = true;
    });
    DBService _db = DBService(uid: _auth.userID!);
    await _db.createUserWithGoogle(fullname, capitalize(schoolName), username, capitalize(major), term, email, photoURL);
    setState(() {
      _isLoading = false;
    });
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => TabView()),(route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.whiteTextColor,
          centerTitle: true,
          title: Text(
            'Login',
            style: TextStyle(
              color: AppColors.whiteTextColor,
              fontSize: 20.0,
            ),
          )
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Username'
                    ),
                    validator: (value) {
                      if(value != null){
                        if(value.isEmpty){
                          return 'Cannot leave this field empty';
                        }
                      }
                    },
                    onSaved: (value) {
                      username = value ?? '';
                    },
                  ),
                  SizedBox(height: 10.0,),
                  Text(
                    'School name',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'School name'
                    ),
                    validator: (value) {
                      if(value != null){
                        if(value.isEmpty){
                          return 'Cannot leave this field empty';
                        }
                      }
                    },
                    onSaved: (value) {
                      schoolName = value ?? '';
                    },
                  ),
                  SizedBox(height: 10.0,),
                  Text(
                    'Major',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Major'
                    ),
                    validator: (value) {
                      if(value != null){
                        if(value.isEmpty){
                          return 'Cannot leave this field empty';
                        }
                      }
                    },
                    onSaved: (value) {
                      major = value ?? '';
                    },
                  ),
                  SizedBox(height: 10.0,),
                  Text(
                    'Term',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  DropdownButton(
                    hint: Text(term),
                    items: <String>['Prep', 'Freshman', 'Sophomore', 'Junior', 'Senior'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (selected) {
                      setState(() {
                        term = selected.toString();
                      });
                    },
                  ),
                  SizedBox(height: 10.0,),
                  OutlinedButton(
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        _formKey.currentState!.save();
                        await _loginUser();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _isLoading ?
                            CircularProgressIndicator(
                              color: Colors.white,
                            )
                                :
                            Text('Login',
                              style: TextStyle(
                                  fontSize: 15.0
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ) ,
    );
  }
}
