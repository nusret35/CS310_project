import 'package:flutter/material.dart';
import 'package:untitled/routes/login_view.dart';
import 'package:untitled/routes/sign_up_view.dart';
import 'package:untitled/util/colors.dart';

import '../analytics.dart';


class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteTextColor,
      body: SingleChildScrollView(
        child: SafeArea(
          maintainBottomViewPadding: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Image.asset("assets/welcome_view_top_image.png"),

                      Row(
                        children: [
                          Padding(padding: EdgeInsets.fromLTRB(130, 150, 0, 0)),
                          RichText(
                            text: TextSpan(

                              text:"Welcome to",
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w600,

                              ),
                            ),
                          ),
                        ],
                      ),
                      Image(image: AssetImage('assets/logo.png'),
                      ),
                      Column(

                        children: <Widget>[
                          Padding(padding: EdgeInsets.fromLTRB(10, 50, 0, 0)),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(29),
                            child: FlatButton(
                              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 80),
                              color: AppColors.primary,
                              onPressed: () async {

                                await AppAnalytics.setScreenName(LoginView.routename);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginView()));
                              },
                              child: Text("LOGIN",style: TextStyle(color: AppColors.whiteTextColor)),
                            ),
                          ),
                          SizedBox(height: 10,),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(29),
                            child: FlatButton(
                              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 75),
                              color: AppColors.primary,
                              onPressed: () async {
                                await AppAnalytics.setScreenName(SignUp.routeName);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                              },
                              child: Text("SIGN UP",style: TextStyle(color: AppColors.whiteTextColor)),
                            ),
                          ),
                        ],
                      ),


                    ],
                  ),
                ),
              ),
            ],

          ),
        ),
      ),
    );
  }
}