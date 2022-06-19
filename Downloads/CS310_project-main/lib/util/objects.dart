import 'package:flutter/material.dart';
import 'package:untitled/util/colors.dart';

class FormPost {
  final String title;
  final String content;
  final String time;
  int likes;
  int comments;
  final String profilePictureURL;
  bool postFavorited = false;
  final String? mediaURL;
  final String docID;
  final String? location;

  FormPost({
  required this.docID,
  required this.title,
  required this.content,
  required this.time,
  required this.likes,
  required this.comments,
  required this.profilePictureURL,
  this.mediaURL,
  this.location,
  });
}



class PostCard extends StatelessWidget {
  final FormPost post;
  final VoidCallback likeButtonAction;
  final VoidCallback commentButtonAction;
  final VoidCallback starButtonAction;
  final VoidCallback reportButtonAction;

  PostCard(
      this.post, {
        required this.likeButtonAction,
        required this.commentButtonAction,
        required this.starButtonAction,
        required this.reportButtonAction,
      });

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert!!"),
          content: Text("Do you want to report this user ?"),
          actions: [
            MaterialButton(
              child: Text("OK"),
              onPressed: () {
                reportButtonAction;
                Text("reportButtonPressed");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      //margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
      // margin: EdgeInsets.fromLTRB(0,8,0,8),
        elevation: 8,
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                (post.location=='') ?
                SizedBox()
                :
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Icon(Icons.location_pin, color: AppColors.primary),
                    SizedBox(width: 5.0,),
                    Text(post.location!,
                      style: TextStyle(color: Colors.grey)
                      ,),
                  ],
                  ),
                ),
                Row(
                    children:[
                      CircleAvatar(backgroundColor: AppColors.colorRed,backgroundImage: NetworkImage(post.profilePictureURL),),
                      const SizedBox(width: 10.0,),
                      Flexible(
                        child: Text(
                          post.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          post.time,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                child: Text('Report User'),
                              onTap: reportButtonAction,
                            )
                          ],
                        ),
                      ),
                    ]
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(post.content,
                    style: TextStyle(
                      fontSize: 17.0,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                Container(
                child: (post.mediaURL != '') ?
                    Image(image:NetworkImage(post.mediaURL!))
                :
                    SizedBox()
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(5.0),

                      child: TextButton.icon(
                          onPressed: likeButtonAction,
                          icon: Icon(
                            Icons.thumb_up,
                            size: 14.0,
                            color: AppColors.color_green,
                          ),
                          label: Text(
                            post.likes.toString(),
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300
                            ),
                          )
                      ),
                    ),
                    const SizedBox(width: 8),

                    IconButton(
                      icon: Icon(Icons.chat_bubble_outline),

                      color: AppColors.color_blue,
                      onPressed: commentButtonAction,
                    ),


                    const SizedBox(width: 8),

                    IconButton(
                      iconSize: 14,
                      onPressed: starButtonAction,
                      icon: Icon(Icons.star, size: 14, color: post.postFavorited ? Colors.yellow:Colors.grey,),
                    ),
                  ],
                )
              ],
            )
        )
    );
  }
}

class Day
{
  final String day;
  bool isSelected = false;
  Day(this.day);
}


//Schedule View Objects
class DayBox extends StatelessWidget {

  final Day day;
  final VoidCallback changeDayProgram;

  DayBox({required this.day, required this.changeDayProgram});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      width: 45.0,
      color: day.isSelected ? AppColors.secondary : AppColors.primary,
      child: Padding(
        padding: EdgeInsets.all(0),
        child: TextButton(
          onPressed: changeDayProgram,
          child: Center(
            child: Text(
              day.day,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: Colors.white
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Event {
  final String event;
  final String time;

  Event({
    required this.event,
    required this.time
  });
}

class DailyProgram {
  final String day;
  List<Event> program = [];

  DailyProgram(this.program,{required this.day,});

  DailyProgram.onlyDay({required this.day});

}

class DailyProgramView extends StatelessWidget {

  final DailyProgram dailyProgram;

  DailyProgramView({required this.dailyProgram});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          dailyProgram.day,
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
          ),
        ),
        Column(
          children: dailyProgram.program.isNotEmpty ? dailyProgram.program.map((event) => EventCard(event)).toList() :
          [
            Padding(
              padding: const EdgeInsets.fromLTRB(0,50,0,0),
              child: Text(
                'No event on this day',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class EventCard extends StatelessWidget {

  final Event event;

  EventCard(this.event);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0,8,0,8),
      child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      event.event,
                      style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 17.0
                      ),
                    ),
                    Spacer(),
                    Text(
                      event.time,
                      style:TextStyle(
                          color: AppColors.primary,
                          fontSize: 17.0
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
      ),
    );
  }
}

/*
PopupMenuButton<int>(

                          itemBuilder: (context) => [
                          // PopupMenuItem 1
                          PopupMenuItem(
                            value: 1,
                          child: Row(
                            children: [
                              Icon(Icons.report_outlined),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Report User")
                            ],
                          ),
                        ),
                      ],
                        onSelected: (value) {
                          reportButtonAction;
                        },
                      ),
 */

/*
TextButton.icon(
                            onPressed: reportButtonAction,
                            icon: Icon(
                              Icons.report_outlined,
                              size: 14.0,
                              color: AppColors.color_green,
                            ),
                            label: Text(
                              'Report User',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300
                              ),
                            )
                        ),
 */