
import 'package:flutter/material.dart';
import 'package:untitled/routes/other_user_profile_view.dart';
import 'package:untitled/routes/topic_posts_view.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/services/crashlytics.dart';
import 'package:untitled/services/db.dart';
import 'package:untitled/util/colors.dart';
import 'package:untitled/routes/location_posts_view.dart';


class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  AuthService _auth = AuthService();
  DBService _db = DBService(uid: '');

  List<Map<String, dynamic>> _allUsers = [
  ];

  List<String> _allTopics = [];

  List<String> _allLocations = [];

  List<Map<String, dynamic>> _foundUsers = [];

  List<String> _foundTopics = [];

  List<String> _foundLocations = [];

  bool keyEntered = false;

  bool searchingForTopics = false;


  Future<void> loadTopics() async{
    _allTopics = await DBService(uid: _auth.userID!).topicSearchResults;
}

Future<void> loadLocations() async {
    _allLocations = await DBService(uid: _auth.userID!).locationSearchResults;
    print(_allLocations.isEmpty);
}



  @override
  void initState() {

    DBService _db = DBService(uid: _auth.userID!);
    _foundUsers = _allUsers;
    loadTopics();
    loadLocations();
    super.initState();
  }

  void _runFilter(String enterdKeyboard) {
    List<Map<String, dynamic>> results = [];
    List<String> topicResults = [];
    List<String> locationResults = [];

    if(enterdKeyboard.isEmpty) {

      setState(() {
        keyEntered = false;
        searchingForTopics  = false;
      });
      results = [];
    } else if (enterdKeyboard[0] == '#') {
      setState(() {
        keyEntered = true;
        searchingForTopics = true;
      });
      topicResults = _allTopics.where((topic) => topic.contains(enterdKeyboard)).toList();
    }
    else{
      setState(() {
        keyEntered = true;
      });
      results = _allUsers.where((user) =>
          user["username"].toString().toLowerCase().contains(enterdKeyboard.toLowerCase())).toList();
      if (results.isEmpty){
        locationResults = _allLocations.where((location) => location.contains(enterdKeyboard)).toList();
      }
    }
    setState(() {
      _foundTopics = topicResults;
    });

    setState(() {
      _foundUsers = results;
    });

    setState(() {
      _foundLocations = locationResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child:
                TextField(
                  onChanged: (value) => _runFilter(value),
                  decoration: const InputDecoration(
                    labelText: 'Search',suffixIcon: Icon(
                    Icons.search,
                  ),
                    )
                  ),
                ),
              StreamBuilder(
                stream: _db.searchResults,
                builder: (BuildContext context, snapshot) {
                  if(snapshot.hasData) {
                    _allUsers = snapshot.data as List<Map<String, dynamic>>;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children:
                          searchingForTopics
                          ?
                          _foundTopics.isNotEmpty
                              ? _foundTopics.map((topic) => SearchTopicResultTile(topic)).toList()
                              :
                              [
                                SizedBox(height:70),
                                Center(
                                  child: const Text('No results found',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                )
                              ]
                              :
                          _foundUsers.isNotEmpty
                            ? _foundUsers.map((user) =>
                            SearchResultTile
                              (
                              user["photoURL"],
                              user["username"],
                              user["fullname"],
                            )
                        ).toList()
                            :
                            _foundLocations.isNotEmpty
                            ? _foundLocations.map((location) =>
                                SearchLocationResultTile(location)
                            ).toList()
                            :
                            keyEntered ?
                              [
                                SizedBox(height:70),
                                Center(
                                  child: const Text('No results found',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                )
                              ]
                           :
                            [
                              SizedBox(height:70),
                              Center(
                                child: const Text('Search',
                                  style: TextStyle(fontSize: 20, color: Colors.grey),
                                ),
                              )
                          ]
                      );
                  }
                  else if (snapshot.hasError) {
                    print("something went wrong");
                    print(snapshot.error.toString());
                    CrashService.recordError(snapshot.error, snapshot.stackTrace, snapshot.error.toString(), false);
                  }
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                            child:
                            CircularProgressIndicator(
                              color: AppColors.primary,
                            )
                        ),
                  );
                }
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget SearchResultTile(String profilePictureUrl,String username, String fullname)
  {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), elevation: 0),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => OtherUserProfileView(username: username)));
        },
      child: Container(
        color: Colors.white,
        child: Column(
            children: [
              SizedBox(height: 10.0,),
              Row(
                children: [
                  SizedBox(width: 10.0,),
                  CircleAvatar(backgroundImage:NetworkImage(profilePictureUrl)),
                  SizedBox(width: 15.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${username}',
                        style: TextStyle(
                            color: Colors.black
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${fullname}',
                        style: TextStyle(
                            color: Colors.grey
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]
                  ),
                ],
              ),
              SizedBox(height: 10.0,),
              Divider(thickness: 1.0,)
            ]
        ),
      ),
    );
  }

  Widget SearchTopicResultTile(String topic)
  {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), elevation: 0),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => TopicPostsView(topic: topic)));
      },
      child: Container(
        color: Colors.white,
        child: Column(
            children: [
              SizedBox(height: 10.0,),
              Row(
                children: [
                  SizedBox(width: 10.0,),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic,
                          style: TextStyle(
                              color: Colors.black
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]
                  ),
                ],
              ),
              SizedBox(height: 10.0,),
              Divider(thickness: 1.0,)
            ]
        ),
      ),
    );
  }

  Widget SearchLocationResultTile(String location)
  {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), elevation: 0),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LocationPostsView(location: location)));
      },
      child: Container(
        color: Colors.white,
        child: Column(
            children: [
              SizedBox(height: 10.0,),
              Row(
                children: [
                  SizedBox(width: 10.0,),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          location,
                          style: TextStyle(
                              color: Colors.black
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]
                  ),
                ],
              ),
              SizedBox(height: 10.0,),
              Divider(thickness: 1.0,)
            ]
        ),
      ),
    );
  }

}










class SearchUserResult {
  final String fullname;
  final String username;
  final String photoURL;

  SearchUserResult({
    required this.fullname,
    required this.username,
    required this.photoURL
  });
}

class SearchTopicResult{
  final String topic;

  SearchTopicResult({
    required this.topic
});
}

