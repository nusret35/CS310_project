import 'package:flutter/material.dart';
import 'package:http/http.dart';

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
                    CircleAvatar(backgroundColor: Colors.red,backgroundImage: NetworkImage(post.profilePictureURL),),
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
                      color: Colors.black
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
                            color: Colors.green,
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
                      color: Colors.blue,
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

