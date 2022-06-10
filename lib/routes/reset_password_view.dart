import 'dart:io' show Platform;

import 'package:untitled/util/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/util/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:untitled/services/auth.dart';
import 'package:flutter/cupertino.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {

  AuthService _auth = AuthService();
  String email = '';
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

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
        elevation: 10.0,
        title: Text(
          'Reset password',
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
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(
                  key: _formKey,
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
                      hintText: 'Enter your email'
                    ),
                  ),
                ),
                SizedBox(height: 8.0,),
                OutlinedButton(
                    onPressed:() async {
                      _isLoading = true;
                      if(_formKey.currentState!.validate())
                        {
                          _formKey.currentState!.save();
                          if(await _auth.isEmailHasAccount(email) == true){
                            //reset password
                            await _auth.resetPassword(email);
                            _isLoading = false;
                            _showDialog('Email sent', 'We have sent you an email. You can reset your password.');
                          }
                          else
                          {
                            _isLoading = false;
                            _showDialog('Error', 'Email address that you entered does not match with any account');
                          }
                        }
                    },
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
                              Text('Send email',
                                style: TextStyle(
                                    fontSize: 15.0
                                ),
                              ),
                            ]
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
