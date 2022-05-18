import 'package:flutter/material.dart';
import 'package:http/http.dart';

class FormPost {
  final String topic;
  final String description;
  final String time;
  final int likes;
  final int comments;

  FormPost(this.topic,
    this.description,this.time,this.likes,this.comments);
}

class PostCard extends StatelessWidget {
  final FormPost post;
  final VoidCallback like;
  final VoidCallback comment;
  final VoidCallback star;

  PostCard(
      this.post, {
        required this.like,
        required this.comment,
        required this.star,
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
                    CircleAvatar(backgroundColor: Colors.red,),
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
                          onPressed: () => {},
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
                      onPressed: () => {},
                      icon: const Icon(Icons.star, size: 14, color: Colors.yellowAccent,),
                    ),
                  ],
                )
              ],
            )
        )
    );
  }
}

