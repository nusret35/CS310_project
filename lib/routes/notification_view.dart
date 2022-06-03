import 'package:flutter/material.dart';
import 'package:untitled/util/colors.dart';
import 'package:untitled/util/styles.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                    'Activity',
                  style: kAppViewTitleTextStyle,
                ),
              ),
              friendRequest('https://dazedimg-dazedgroup.netdna-ssl.com/592/azure/dazed-prod/1060/8/1068776.jpg', 'tyler'),
              friendRequest('https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Cate_Blanchett_Cannes_2018_2_%28cropped_2%29.jpg/640px-Cate_Blanchett_Cannes_2018_2_%28cropped_2%29.jpg', 'cateblanchett'),
              friendRequest('https://i.imgur.com/r1lA6yX.jpg', 'michaelscott'),
              notification('http://2.bp.blogspot.com/-0j7kHlU-NtI/UpD00rkd3TI/AAAAAAAADtU/9u_vcILav6M/s1600/BB-S5B-Walt-590.jpg', 'walterwhite', 'liked your post "Does anyone sell any type of "'),
              notification('https://dazedimg-dazedgroup.netdna-ssl.com/592/azure/dazed-prod/1060/8/1068776.jpg', 'tyler', 'commented on your post: That is dope'),
              notification('https://m.media-amazon.com/images/M/MV5BMTM0ODU5Nzk2OV5BMl5BanBnXkFtZTcwMzI2ODgyNQ@@._V1_UY317_CR4,0,214,317_AL_.jpg', 'johnny', 'commented on your post: Absolutely'),
              notification('https://i.imgur.com/r1lA6yX.jpg', 'michaelscott', 'commented on your post: Thats what she said'),
              notification('https://upload.wikimedia.org/wikipedia/commons/4/4b/Serena_Williams_at_2013_US_Open.jpg', 'serenawilliams', 'liked your post "Tennis tournament"'),
              notification('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_Ks6CQk3ZIUSnwHM6BYNjyyQIFObcGSjXCUHdf6qG3Jc5oMRLr1Z9VRWvp1OfD2lpLj0&usqp=CAU', 'zuck', 'commented on your post: Aliens will takeover our world and make humans their pets.'),
              
            ],
          ),
        ),
      ),
    );
  }
}

Widget friendRequest(String profilePictureUrl, String username)
{
  return Container(
    color: Colors.white,
    child: Column(
        children: [
          SizedBox(height: 7.0,),
          Row(
            children: [
              SizedBox(width: 10.0,),
              CircleAvatar(backgroundImage:NetworkImage(profilePictureUrl)),
              SizedBox(width: 15.0,),
              Container(
                width: 180.0,
                child: Text(
                  '${username} wants to be your friend',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),
              ),
              SizedBox(width: 10.0,),
              Chip(
                label: Text(
                  'Accept',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: AppColors.primary,
              ),
              SizedBox(width: 10.0,),
              Chip(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                label: Text(
                  'Delete',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,)
            ],
          ),
          SizedBox(height: 7.0,),
          Divider(thickness: 1.0,)
        ]
    ),
  );
}

Widget notification(String profilePictureUrl,String username, String description)
{
  return Container(
    color: Colors.white,
    child: Column(
      children: [
        SizedBox(height: 10.0,),
        Row(
        children: [
          SizedBox(width: 10.0,),
          CircleAvatar(backgroundImage:NetworkImage(profilePictureUrl)),
          SizedBox(width: 15.0,),
          Flexible(
            child: Text(
                '${username} ${description}',
              style: TextStyle(
                color: Colors.black
                ),
              overflow: TextOverflow.ellipsis,
              ),
          ),
          ],
        ),
        SizedBox(height: 10.0,),
        Divider(thickness: 1.0,)
      ]
    ),
  );
}