import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:untitled/routes/welcome_view.dart';
import 'package:untitled/util/colors.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/util/styles.dart';
import 'package:flutter/cupertino.dart';

class SettingsView extends StatefulWidget {
  SettingsView({Key? key,required this.title}) : super(key: key);
  final String title;
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool isSwitched = false;
  AuthService _auth = AuthService();

  Future signOutUser() async {
    await _auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => WelcomeView())
    );
  }

  Future deleteAccount() async {
    await _auth.deleteAccount();
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => WelcomeView())
    );
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
                    Navigator.of(context).pop();
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