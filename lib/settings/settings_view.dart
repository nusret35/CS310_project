import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:untitled/routes/welcome_view.dart';
import 'package:untitled/util/colors.dart';
import 'package:untitled/services/auth.dart';

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
                  signOutUser();
                },
              ),
            ],
          ),
        ],
      ),
    );

  }
}