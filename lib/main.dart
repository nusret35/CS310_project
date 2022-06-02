import 'dart:io' show Platform;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/tab_controller.dart';
import 'package:untitled/walkthrough/walkthrough__screen.dart';
import 'package:untitled/routes/welcome_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:untitled/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled/util/styles.dart';
import 'analytics.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();


  runApp(MaterialApp(
    theme: ThemeData(
      primaryColorLight: Colors.green,
    ),
    home: MyFirebaseApp(analytics: analytics)
  ));
}

class MyFirebaseApp extends StatefulWidget {
  const MyFirebaseApp({Key? key, required this.analytics}) : super(key: key);

  static FirebaseAnalytics analytics = AppAnalytics.analytics;

  //final FirebaseAnalytics analytics;



  @override
  State<MyFirebaseApp> createState() => _MyFirebaseAppState();
}

class _MyFirebaseAppState extends State<MyFirebaseApp> {

  int? firstLoad;
  SharedPreferences? prefs;
  final Future<FirebaseApp> _init = Firebase.initializeApp();







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
    return FutureBuilder(
        future: _init,
        builder: (context, snapshot) {
          if(snapshot.hasError)
            {
              return ErrorScreen(message: snapshot.error.toString());
            }
          if(snapshot.connectionState  == ConnectionState.done)
            {
              if (firstLoad == null) {
                return Container();
              }
              else if(firstLoad == 0) {
                firstLoad = 1;
                prefs!.setInt('appInitialLoad', firstLoad!);
                return MaterialApp(
                  home: WalkthroughScreen(),
                );
              }
              else {
                return AuthenticationStatus();
              }
            }
          return const LoadingScreen();
        }
    );
  }
}


class AuthenticationStatus extends StatefulWidget {
  const AuthenticationStatus({Key? key}) : super(key: key);
  static const String routename = '/authenticationStatus';
  @override
  State<AuthenticationStatus> createState() => _AuthenticationStatusState();
}

class _AuthenticationStatusState extends State<AuthenticationStatus> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      return WelcomeView();
    }
    else {
      return TabView();
    }
  }
}


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool twoSecondsPassed = false;

  Future afterTwoSeconds() async {
    await Future.delayed(Duration(seconds: 2), () {
      setState(() {
        twoSecondsPassed = true;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    afterTwoSeconds();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/logo.png')),
          SizedBox(height: 20,),
          twoSecondsPassed ? CircularProgressIndicator(color: AppColors.primary,):
              SizedBox(),
        ],
      ),
    );
  }
}


class ErrorScreen extends StatefulWidget {

  final String message;
  ErrorScreen({required this.message});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState(message);
}

class _ErrorScreenState extends State<ErrorScreen> {

  final String message;
  bool isAndroid = Platform.isAndroid;

  _ErrorScreenState(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image(
          image: AssetImage('assets/logo.png'),
          width: 200,
        ),
        centerTitle: true,
        foregroundColor: AppColors.primary,
        backgroundColor: AppColors.whiteTextColor,
        elevation: 10.0,
      ),
      body: isAndroid ? AlertDialog(
          title: Text('Error occured'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(message),
              ],
            ),
          ),
        ):CupertinoAlertDialog(
          title: Text('Error occured', style: kBoldLabelStyle),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(message, style: kLabelStyle),
              ],
            ),
          ),
        ),
      );
  }
}














