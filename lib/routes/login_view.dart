import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:untitled/routes/google_login_finish_view.dart';
import 'package:untitled/routes/reset_password_view.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/services/db.dart';
import 'package:untitled/util/styles.dart';
import 'package:untitled/tab_controller.dart';
import 'package:untitled/util/colors.dart';
import 'package:untitled/services/analytics.dart';
import 'package:provider/provider.dart';


class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  static const routename = '/loginview';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _isLoading = false;

  Future loginUser() async {
    setState(() {
      _isLoading = true;
    });
    dynamic result = await _auth.signInWithEmailPass(email, password);
    setState(() {
      _isLoading = false;
    });
    if (result is String)
      {
        _showDialog('Login unsuccessful', result);
      }
    else if (result is User)
      {
        await AppAnalytics.setUserId(result.uid);
        await AppAnalytics.setScreenName(TabView.routename);
        await AppAnalytics.logCustomEvent('login_event', <String, dynamic> {'email' : result.email});
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TabView()));
      }
    else
      {
        _showDialog('Login unsuccessful', result.toString());
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
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteTextColor,
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,0,0),
                  child: Image(
                    image: AssetImage(
                      'assets/logo.png'
                    ),
                    width: 200,
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0,0,0,20),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (value){
                                if (value != null){
                                  if (EmailValidator.validate(value) == false)
                                  {
                                    return 'Please enter a valid email';
                                  }
                                }
                                else
                                  {
                                    return 'Please enter your email address';
                                  }
                              },
                              onSaved: (value) {
                                email = value ?? '';
                              },
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
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0,20,0,20),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                label: Container(
                                  width: 100,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.password),
                                        const SizedBox(width: 4),
                                        const Text('Password'),
                                      ],
                                    ),

                                )
                              ),
                              validator: (value){
                                if (value != null)
                                  {
                                    if (value.length <= 6)
                                      {
                                        return 'Please enter a valid password';
                                      }
                                  }
                                else {
                                  return 'Please enter your password';
                                }
                              },
                              onSaved: (value) {
                                password = value ?? '';
                              },
                            ),
                          ),
                        ],
                      ),
                  ),
                ),
                SizedBox(height: 20.0,),
                TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordView()));
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                OutlinedButton(
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                      await loginUser();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 150.0),
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
                ),
                SizedBox(height: 10.0,),
                OutlinedButton(
                  onPressed: () async {
                   User? user = await _auth.signInWithGoogle();
                    if (user != null) {
                      print(user.metadata.creationTime.toString());
                      print(user.metadata.lastSignInTime.toString());
                      if(user.metadata.lastSignInTime == user.metadata.creationTime)
                        {
                          User googleUser = FirebaseAuth.instance.currentUser!;
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => GoogleLoginFinishView(
                                                                                            googleUser.displayName!,
                                                                                            googleUser.email!,
                                                                                            googleUser.photoURL ?? 'no-profile-photo')
                          ), (route) => false);
                        }
                      else {
                          await AppAnalytics.setUserId(_auth.userID!);
                          await AppAnalytics.setScreenName(TabView.routename);
                          await AppAnalytics.logCustomEvent(
                              'login_with_Google_event', <String, dynamic>{
                            'email': user.email
                          });
                          Navigator.pushAndRemoveUntil(
                              context, MaterialPageRoute(builder: (context) =>
                              TabView()), (route) => false);
                      }
                    }
                    else
                      {
                        print("something is wrong");
                      }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,15,0,15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(image: AssetImage('assets/google_icon.png'),height: 25, width: 25),
                          SizedBox(width: 4.0,),
                          Text('Sign in with Google',
                          style: TextStyle(
                              fontSize: 15.0
                          ),
                        ),
                      ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
