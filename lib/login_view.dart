import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);


  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 150,),
                Text(
                  'UniForm',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6034A8),
                  ),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
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
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(20.0),
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
                          ),
                        ),
                      ],
                    ),
                ),
                SizedBox(height: 20.0,),
                OutlinedButton(
                  onPressed: () => {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF6034A8)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 150.0),
                    child: Text('Login',
                      style: TextStyle(
                        fontSize: 15.0
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
