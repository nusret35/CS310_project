import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:untitled/feed_view.dart';
import 'package:untitled/tab_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  static const routename = '/loginview';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  Future loginUser() async {
    Navigator.pushReplacementNamed(context, TabView.routename);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF6034A8),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
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
                SizedBox(height: 100,),
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
                                    return 'Please enter valid email';
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
                              keyboardType: TextInputType.visiblePassword,
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
                        child: Text('Login',
                          style: TextStyle(
                            fontSize: 15.0
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                TextButton(
                  onPressed: (){},
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Color(0xFF6034A8),
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
