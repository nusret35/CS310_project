import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/tab_controller.dart';
import 'package:untitled/util/colors.dart';
import 'package:untitled/util/styles.dart';
import 'package:untitled/util/dimensions.dart';
import 'package:untitled/util/screen_size.dart';
import 'package:email_validator/email_validator.dart';
import 'package:untitled/api/auth.dart';
import 'package:flutter/cupertino.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();

  static const String routeName = '/signup';
}

class _SignUpState extends State<SignUp> {
  AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String name = '';
  String surname = '';
  String schoolName = '';

  Future signUpUser() async {
    dynamic result = await _auth.signUpWithEmailPass(name, surname, schoolName, email, password);
    if (result is String)
      {
        _showDialog('Sign up unsuccesful', result);
      }
    else if (result is User)
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TabView()));
      }
    else
    {
      _showDialog('Sign up unsuccesful', result.toString());
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: kAppBarTitleTextStyle,
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Dimen.regularPadding,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    width: screenWidth(context, dividedBy: 1.1),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        label: Container(
                          width: 150,
                          child: Row(
                            children: [
                              const SizedBox(width: 4),
                              const Text('Name'),
                            ],
                          ),
                        ),
                      ),
                      validator: (value) {
                        if(value != null){
                          if(value.isEmpty) {
                            return 'Cannot leave name empty';
                          }
                        }
                      },
                      onSaved: (value) {
                        name = value ?? '';
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: screenWidth(context, dividedBy: 1.1),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      decoration:InputDecoration(
                        label: Container(
                          width: 150,
                          child: Row(
                            children: [
                            const SizedBox(width: 4),
                            const Text('Surname'),
                            ],
                          ),
                        ),
                      ),
                      validator: (value) {
                        if(value != null){
                          if(value.isEmpty) {
                            return 'Cannot leave surname empty';
                          }
                        }
                      },
                      onSaved: (value) {
                        surname = value ?? '';
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: screenWidth(context, dividedBy: 1.1),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      decoration:InputDecoration(
                        label: Container(
                          width: 150,
                          child: Row(
                            children: [
                              const Icon(Icons.school),
                              const SizedBox(width: 4),
                              const Text('School Name'),
                            ],
                          ),
                        ),
                      ),
                      validator: (value) {
                        if(value != null){
                          if(value.isEmpty) {
                            return 'Cannot leave school empty';
                          }
                        }
                      },
                      onSaved: (value) {
                        schoolName = value ?? '';
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: screenWidth(context, dividedBy: 1.1),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        label: Container(
                          width: 100,
                          child: Row(
                            children: [
                              const Icon(Icons.email),
                              const SizedBox(width: 4,),
                              const Text('Email'),
                            ],
                          ),
                        ),
                      ),
                      validator: (value) {
                        if(value != null){
                          if(value.isEmpty) {
                            return 'Cannot leave e-mail empty';
                          }
                          if(!EmailValidator.validate(value)) {
                            return 'Please enter a valid e-mail address';
                          }
                        }
                      },
                      onSaved: (value) {
                        email = value ?? '';
                      },
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.all(8),
                    width: screenWidth(context, dividedBy: 1.1),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        label: Container(
                          width: 150,
                          child: Row(
                            children: [
                              const Icon(Icons.password),
                              const SizedBox(width: 4),
                              const Text('Password'),
                            ],
                          ),
                        ),
                      ),
                      validator: (value) {
                        if(value != null){
                          if(value.isEmpty) {
                            return 'Cannot leave password empty';
                          }
                          if(value.length < 6) {
                            return 'Password too short';
                          }
                        }
                      },
                      onSaved: (value) {
                        password = value ?? '';
                      },
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8,0,8,0),
                    child: OutlinedButton(
                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          _formKey.currentState!.save();
                          await signUpUser();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0,15,0,15),
                          child: Text('Sign up',
                            style: TextStyle(
                                fontSize: 15.0
                            ),
                          ),
                        ),
                      ),
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