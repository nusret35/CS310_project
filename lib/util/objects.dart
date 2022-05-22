import 'package:flutter/material.dart';
import 'package:untitled/util/colors.dart';

class FormPost {
  final String topic;
  final String description;
  final String time;
  int likes;
  int comments;
  final String profilePictureURL;
  bool postFavorited = false;

  FormPost(this.topic,
      this.description,this.time,this.likes,this.comments,this.profilePictureURL);
}

class PostCard extends StatelessWidget {
  final FormPost post;
  final VoidCallback likeButtonAction;
  final VoidCallback comment;
  final VoidCallback starButtonAction;

  PostCard(
      this.post, {
        required this.likeButtonAction,
        required this.comment,
        required this.starButtonAction,
      });

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
                Row(
                    children:[
                      CircleAvatar(backgroundColor: AppColors.colorRed,backgroundImage: NetworkImage(post.profilePictureURL),),
                      const SizedBox(width: 10.0,),
                      Text(
                        post.topic,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        post.time,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ]
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(post.description,
                    style: TextStyle(
                      fontSize: 17.0,
                      color: AppColors.textColor,
                    ),
                  ),
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

                    const Icon(
                      Icons.comment,
                      size: 14.0,
                      color: AppColors.color_blue,
                    ),

                    const SizedBox(width: 5),

                    Text(
                      post.comments.toString(),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300
                      ),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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