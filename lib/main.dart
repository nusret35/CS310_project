import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/tab_controller.dart';
import 'package:untitled/walkthrough/walkthrough__screen.dart';
import 'package:untitled/routes/welcome_view.dart';
import 'package:untitled/tab_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int? firstLoad;
  SharedPreferences? prefs;

  decideRoute() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      firstLoad = (prefs!.getInt('appInitialLoad') ?? 0);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    decideRoute();
  }

  @override
  Widget build(BuildContext context) {
    if(firstLoad == null) {
      return Container();
    } else if(firstLoad == 0) {
      firstLoad = 1;
      prefs!.setInt('appInitialLoad', firstLoad!);
      return MaterialApp(
        home: WalkthroughScreen(),
      );
    } else {
      return MaterialApp(
        home: WelcomeView(),
    );
    }
  }
}













