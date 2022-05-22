import 'package:flutter/material.dart';
import 'package:untitled/routes/HomePage.dart';
import 'package:untitled/util/colors.dart';
import 'package:untitled/util/styles.dart';
import 'package:untitled/util/dimensions.dart';
import 'package:untitled/util/screen_size.dart';
import 'package:email_validator/email_validator.dart';
import 'package:untitled/tab_controller.dart';
import 'package:untitled/feed_view.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();

  static const String routeName = '/signup';
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String pass = '';

  Future loginUser() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: "ss")));
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
      body: Padding(
        padding: Dimen.regularPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                          const SizedBox(width: 4),
                          const Text('Email'),
                        ],
                      ),
                    ),
                    fillColor: AppColors.textFieldFillColor,
                    filled: true,
                    labelStyle: kBoldLabelStyle,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                      ),
                      borderRadius: BorderRadius.circular(30),
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
                    fillColor: AppColors.textFieldFillColor,
                    filled: true,
                    labelStyle: kBoldLabelStyle,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                      ),
                      borderRadius: BorderRadius.circular(30),
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
                    pass = value ?? '';
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(8,0,8,0),
                child: OutlinedButton(
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                      await loginUser();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF6034A8)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,15,0,15),
                      child: Text('SignUp',
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
    );
  }
}