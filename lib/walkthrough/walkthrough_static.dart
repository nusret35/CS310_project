import 'package:flutter/material.dart';
import 'package:untitled/util/colors.dart';

List<Map<String, Object>> WALKTHROUGH_ITEMS = [
  {
    'image' : 'assets/logo.png',
    'button_text' : 'Continue',
    'description_rich': RichText(text: TextSpan(children: [
      TextSpan(
          text: "you're here to experience the brand new way of comunication in university.",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)
      )

    ])),
    'title': RichText(text: TextSpan(children: [
      TextSpan(text: "Welcome to ", style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        fontFamily: 'Gothic',
      )),
      TextSpan(text: " UniFrom ", style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        fontFamily: 'Gothic',
        color: AppColors.color_green_Walkthrogh,
      )),


    ])),

  },
  {
    'image' : 'assets/search_icon.png',
    'button_text' : 'Next',
    'description_rich': RichText(text: TextSpan(children: [
      TextSpan(
          text: "You will have chance to communicate with students from other universities via the Campus World section of the UniForm.",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)
      )

    ])),
    'title': RichText(text: TextSpan(children: [
      TextSpan(text: "UniFrom ", style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        fontFamily: 'Gothic',
        color: AppColors.color_green_Walkthrogh,
      )),
      TextSpan(text: "will let you connect to the world of students ", style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        fontFamily: 'Gothic',

      )),


    ])),
  },
  {
    'image' : 'assets/group_icon.png',
    'button_text' : 'Next',
    'description_rich': RichText(text: TextSpan(children: [
      TextSpan(
          text: "No need to  worry about others having your number because of having groups related to the courses, UniForm will allow you to create or be part of a group just by your User name.",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)
      )

    ])),
    'title': RichText(text: TextSpan(children: [
      TextSpan(text: "Final station of having group chats is ", style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        fontFamily: 'Gothic',
      )),
      TextSpan(text: " UniFrom ", style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        fontFamily: 'Gothic',
        color: AppColors.color_green_Walkthrogh,
      )),


    ])),
  },
  {
    'image' : 'assets/start_icon.png',
    'button_text' : "Let's Start",
    'description_rich': RichText(text: TextSpan(children: [
      TextSpan(
          text: "You will be able to ask anything from the CampusNet section to listen to others opinion.",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)
      )

    ])),
    'title': RichText(text: TextSpan(children: [
      TextSpan(text: "Need others voice, join ", style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        fontFamily: 'Gothic',
      )),
      TextSpan(text: " CampusNet ", style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        fontFamily: 'Gothic',
        color: AppColors.color_green_Walkthrogh,
      )),


    ])),
  }
];