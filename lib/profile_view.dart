import 'package:flutter/material.dart';

class Profile {
  static const String Name = 'Ali Can';
  static const String Username = 'alican';
  static const String University = 'Sabanci University';
  static const String Major = 'Computer Science';
  static const String Term = 'Sophomore';
}

class AppColors {
  static const Color Purple = Color.fromARGB(255, 108, 7, 170);
  static const Color Red = Colors.red;
  static const Color Text = Colors.black;
  static const Color Background = Colors.white;
}

class Dimension {
  static const double parentMargin = 16.0;

  static get regularPadding => EdgeInsets.all(parentMargin);
}

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(35, 25, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Your Profile',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Arial',
                      color: AppColors.Text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(130, 0, 0, 0),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.w800,
                        color: AppColors.Red,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.4,
                    child: CircleAvatar(
                      backgroundColor: AppColors.Purple,
                      radius: MediaQuery.of(context).size.width * 0.4,
                      backgroundImage: AssetImage('assets/empty_profile.png'),
                    ),
                  ),
                ),
              ),
              Padding(padding: const EdgeInsets.fromLTRB(0, 40, 0, 0)),
              Text(
                'Name and Surname',
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.w600,
                  color: AppColors.Text,
                ),
              ),
              Text(
                Profile.Name,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Arial',
                  color: AppColors.Text,
                ),
              ),
              Padding(padding: const EdgeInsets.fromLTRB(0, 25, 0, 0)),
              Text(
                'Username',
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.w600,
                  color: AppColors.Text,
                ),
              ),
              Text(
                Profile.Username,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Arial',
                  color: AppColors.Text,
                ),
              ),
              Padding(padding: const EdgeInsets.fromLTRB(0, 25, 0, 0)),
              Text(
                'University',
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.w600,
                  color: AppColors.Text,
                ),
              ),
              Text(
                Profile.University,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Arial',
                  color: AppColors.Text,
                ),
              ),
              Padding(padding: const EdgeInsets.fromLTRB(0, 25, 0, 0)),
              Text(
                'Major',
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.w600,
                  color: AppColors.Text,
                ),
              ),
              Text(
                Profile.Major,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Arial',
                  color: AppColors.Text,
                ),
              ),
              Padding(padding: const EdgeInsets.fromLTRB(0, 25, 0, 0)),
              Text(
                'Term',
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.w600,
                  color: AppColors.Text,
                ),
              ),
              Text(
                Profile.Term,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Arial',
                  color: AppColors.Text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
