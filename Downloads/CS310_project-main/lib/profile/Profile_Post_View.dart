
import 'package:flutter/material.dart';





class ProfilePostView extends StatelessWidget {
  const ProfilePostView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 2,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context ,index){
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            color: Colors.pink[100],
          ),

        );
      },
    );
  }
}
