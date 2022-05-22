import 'package:flutter/material.dart';
import 'package:untitled/util/colors.dart';

class Dimension {
  static const double parentMargin = 16.0;

  static get regularPadding => EdgeInsets.all(parentMargin);
}

class EditProfileView extends StatefulWidget {
  static const routename = '/editProfile';

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}
class _EditProfileViewState extends State<EditProfileView>
{

  String dropDownText = 'Choose your term';

  Future _saveChangesAndPop() async {
    print('changes are saved');
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        actions: [
          IconButton(
              onPressed: _saveChangesAndPop,
              icon: Icon(Icons.done),
              color: Colors.white,
          ),
        ],
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0
          ) ,
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(35, 25, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  'Name and Surname',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 5, 0, 0)),
                Container(
                  width: 350.0,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your name and surname',
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 0)),
                Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 5, 0, 0)),
                Container(
                  width: 350.0,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your username',
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 0)),

                Text(
                  'University',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 5, 0, 0)),
                Container(
                  width: 350.0,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your university',
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 0)),
                Text(
                  'Major',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 5, 0, 0)),
                Container(
                  width: 350.0,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your major',
                    ),
                  ),
                ),

                Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 0)),
                Text(
                  'Term',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 5, 0, 0)),
                DropdownButton(
                  hint: Text(dropDownText),

                  items: <String>['Prep', 'Freshman', 'Sophomore', 'Junior', 'Senior'].map((String value) {
                    return DropdownMenuItem<String>(

                      value: value,
                      child: Text(value),
                    );

                  }).toList(),
                  onChanged: (term) {
                    setState(() {
                      dropDownText = term.toString();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}