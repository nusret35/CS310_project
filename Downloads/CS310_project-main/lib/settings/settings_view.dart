import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:untitled/routes/welcome_view.dart';
import 'package:untitled/util/colors.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/util/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:email_validator/email_validator.dart';

class SettingsView extends StatefulWidget {
  SettingsView({Key? key,required this.title}) : super(key: key);
  final String title;
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool isSwitched = false;
  AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  Future signOutUser() async {
    await _auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => WelcomeView())
    );
  }

  Future deleteAccount() async {
    Navigator.of(context).pop();
    final bool emailCheck = await _auth.isSignedInWithEmail();
    if (await emailCheck == true)
      {
        print("signed in with email");
        await _showUserAuthenticateDialog();
      }
    else
      {
        await _auth.deleteGoogleAccount();
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => WelcomeView()));
      }

  }

  Future<void> _showDialog(String title, String message, VoidCallback function) async {
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
                  child: Text(
                      'Yes',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: function,
                ),
                TextButton(
                  child: Text('No'),
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
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    function;
                  },
                ),
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
        });
  }

  Future<void> _showUserAuthenticateDialog() async {
    bool isAndroid = Platform.isAndroid;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          if(isAndroid) {
            return AlertDialog(
              title: Text('Authenticate your account'),
              content: Container(
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
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
              ),
              actions: [
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text(
                    'Login ',
                  ),
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                      _auth.deleteEmailAccount(email, password);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => WelcomeView()));
                    }
                  },
                ),
                SizedBox(width: 5.0,),
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text(
                    'Cancel',
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          } else {
            return CupertinoAlertDialog(
              title: Text('Authenticate your account'),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
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
              ),
              actions: [
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text(
                    'Login ',
                  ),
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                      _auth.deleteEmailAccount(email, password);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => WelcomeView()));
                    }
                  },
                ),
                SizedBox(width: 5.0,),
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text(
                    'Cancel',
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text('Language'),
                value: Text('English'),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: true,
                leading: Icon(Icons.format_paint),
                title: Text('Enable custom theme'),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.logout),
                title: Text('Sign out'),
                onPressed: (BuildContext context) {
                  _showDialog('Sign out', 'Are you sure you want to sign out?', signOutUser);
                },
              ),
              SettingsTile.navigation(
                  onPressed: (BuildContext context) {
                    _showDialog('Delete account?', "Are you sure you want to delete your account? You won't be able take this action back.", deleteAccount);
                  },
                  title: Text('Delete account'),
                  leading: Icon(Icons.delete),
              ),
            ],
          ),
        ],
      ),
    );

  }
}