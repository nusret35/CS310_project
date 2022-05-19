import 'package:flutter/material.dart';
import 'package:untitled/login_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                              color: Colors.black,
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
                            color: Colors.deepPurple,
                            onPressed: (){
                              Navigator.pushNamed(context, LoginView.routename);
                            },
                            child: Text("LOGIN",style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(height: 10,),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(29),
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 75),
                            color: Colors.deepPurple,
                            onPressed: (){},
                            child: Text("SIGN UP",style: TextStyle(color: Colors.white)),
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
    );
  }
}