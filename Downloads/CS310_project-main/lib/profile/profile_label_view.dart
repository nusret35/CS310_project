
import 'package:flutter/material.dart';




class profileLabelView extends StatelessWidget {
  const profileLabelView({Key? key, required this.labelText}) : super(key: key);
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(labelText, style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            ),
          ),


    ],
    ),
    );
  }
}

