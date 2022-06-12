import 'package:flutter/material.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/services/db.dart';
import 'package:untitled/services/storage.dart';
import 'package:untitled/util/colors.dart';
import 'package:untitled/util/styles.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}


class _NotificationViewState extends State<NotificationView> {

  AuthService _auth = AuthService();

  Future<List<Map<String,String>>> loadRequests(List<String> requests) async {
    List<Map<String,String>> fRequests = [];
    for (int i=0; i< requests.length; i++)
      {
        final req  = {
          "username": requests[i],
          "photoURL": await StorageService().profilePictureUrlByUsername(requests[i])
        };
        fRequests.add(req);
      }
    return fRequests;
  }

  @override
  void initState() {
    DBService(uid: _auth.userID!).friendRequests;
    super.initState();
  }
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
              FutureBuilder(
                  future: DBService(uid: _auth.userID!).friendRequests,
                  builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData)
                      {
                        final List<String> requests = snapshot.data ?? [];
                        return FutureBuilder(
                            future: loadRequests(requests),
                            builder: (BuildContext context, AsyncSnapshot<List<Map<String,String>>> data){
                              if (snapshot.hasData == true) {
                                List<Map<String, String>> friendRequests = data
                                    .data ?? [];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .stretch,
                                  children: friendRequests.map((e) =>
                                      friendRequest(
                                          e["photoURL"]!, e["username"]!))
                                      .toList(),
                                );
                              }
                              return Center(child:
                                CircularProgressIndicator(color: AppColors.primary,
                              )
                              );
                        }
                        );
                      }
                    return Center(child:
                      CircularProgressIndicator(color: AppColors.primary,
                      )
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
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
                InputChip(
                  onPressed: () {
                    DBService(uid: _auth.userID!).acceptFriendRequest(username);
                    setState(() {
                    });
                    },
                  label: Text(
                    'Accept',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: AppColors.primary,
                ),
                SizedBox(width: 10.0,),
                InputChip(
                  onPressed: () {
                    DBService(uid: _auth.userID!).declineFriendRequest(username);
                    setState(() {
                    });
                    },
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
}

