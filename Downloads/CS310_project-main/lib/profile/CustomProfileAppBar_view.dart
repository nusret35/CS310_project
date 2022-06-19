
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/services/crashlytics.dart';
import 'package:untitled/util/styles.dart';
import 'package:untitled/model/user.dart';
import 'package:untitled/routes/edit_profile_view.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/services/db.dart';
import 'package:untitled/util/colors.dart';
import '../services/analytics.dart';
import 'package:image_picker/image_picker.dart';


class CustomProfileAppBar extends StatelessWidget {
  const CustomProfileAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      centerTitle: false,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Icon(Icons.https_outlined, size: 18,),
        ),
        Text('stackedlist', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
      ],
      ),
      actions: [
        IconButton(onPressed: () => {}, icon: Icon(Icons.add_box_outlined)),
        IconButton(onPressed: () => {}, icon: Icon(Icons.dehaze_outlined)),
      ], systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }
}
