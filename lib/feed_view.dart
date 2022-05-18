import 'package:flutter/material.dart';
import 'package:untitled/post.dart';

class FeedView extends StatefulWidget {
  const FeedView({Key? key}) : super(key: key);

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  List<FormPost> posts = [
    FormPost('CS310 Project', 'Hey guys can you help me with my project?', '10 minutes ago', 10, 3),
    FormPost('HUM202 Report', 'When is the due date?', 'Yesterday', 120, 30),
    FormPost('SUSail Trip', 'Who is coming to trip tomorrow?', '2 days ago', 67, 24),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        bottomNavigationBar: menu(),
        appBar: AppBar(
          title: Text(
            'UniForm',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35.0,
            ),
          ),
          leading: GestureDetector (
            onTap: () => {},
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: CircleAvatar(
                backgroundColor: Colors.greenAccent,
              ),
            ),
          ),
          centerTitle: true,
          foregroundColor: Color(0xFF6034A8),
          backgroundColor: Colors.white,
          elevation: 10.0,

        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {},
          backgroundColor: Color(0xFF6034A8),
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: posts.map((post) => PostCard(
                  post,
                  like: (){
                    print('liked');
                }, comment: (){
                    print('comment');
                }, star: (){
                    print('star');
                },
                )
                ).toList(),
              ),
            ),
          ),
        ),
      ),
    );

  }

  Widget menu() {
    return Container(
        color: Colors.white,
      child: TabBar(
        labelColor: Color(0xFF6034A8),
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Color(0xFF6034A8),
        tabs: [
            Tab(
              text: "Home",
              icon: Icon(Icons.home),
            ),
            Tab(
              text: "Search",
              icon: Icon(Icons.search),
            ),
            Tab(
              text: "Chat",
              icon: Icon(Icons.chat),
            ),
            Tab(
              text: "Schedule",
              icon: Icon(Icons.calendar_month_outlined),
            ),
             Tab(
               text: "Profile",
               icon: Icon(Icons.person),
              ),
        ],
      ),
    );
  }
}
