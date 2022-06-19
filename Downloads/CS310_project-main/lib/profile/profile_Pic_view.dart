import 'package:flutter/material.dart';


class ProfilePicView extends StatelessWidget {
  const ProfilePicView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: Colors.pink,
          radius: 45,
        ),
        Positioned(
            top: 65,
            left: 65,
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue,
              ),
              /*
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => {},
                icon: Icon(Icons.add),
                iconSize: 20,
                color: Colors.white,
              ),

               */
            ),
        ),
      ],
    );
  }
}
