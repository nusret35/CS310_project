import 'package:flutter/material.dart';
import 'package:untitled/post.dart';

class FeedView extends StatefulWidget {
  const FeedView({Key? key}) : super(key: key);
  static const String routename = '/feedView';

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {

  void increamentLike(FormPost post){
    setState(() {
      post.likes++;
    });
  }

  void favoritePost(FormPost post){
    setState(() {
      if (post.postFavorited == false)
        {
          post.postFavorited = true;
        }
      else
        {
          post.postFavorited = false;
        }
    });
  }


  List<FormPost> posts = [
    FormPost('CS310 Project', 'Hey guys can you help me with my project?', '10 minutes ago', 10, 3, 'http://2.bp.blogspot.com/-0j7kHlU-NtI/UpD00rkd3TI/AAAAAAAADtU/9u_vcILav6M/s1600/BB-S5B-Walt-590.jpg'),
    FormPost('HUM202 Report', 'When is the due date?', 'Yesterday', 120, 30, 'https://dazedimg-dazedgroup.netdna-ssl.com/592/azure/dazed-prod/1060/8/1068776.jpg'),
    FormPost('SUSail Trip', 'Who is coming to the island trip tomorrow?', '2 days ago', 67, 24, 'https://pbs.twimg.com/profile_images/2603710564/dp3ln37ptpcb6lhz54ql_400x400.jpeg'),
    FormPost('PROJ201 Final Report', 'Is there any chance to reschedule the deadline?', '3 days ago', 238, 55, 'https://static.wikia.nocookie.net/lotr/images/e/e7/Gandalf_the_Grey.jpg/revision/latest?cb=20121110131754'),
    FormPost('Party on Saturday', 'We are organizing a party on Saturday at Lucca with Koç University. You can contact me if you want to come.', '3 days ago', 1123, 576, 'https://tr.web.img4.acsta.net/c_310_420/pictures/15/11/23/09/37/018271.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              children: [
                Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: posts.map((post) => PostCard(
                  post,
                  likeButtonAction: (){
                    increamentLike(post);
                }, comment: (){;
                }, starButtonAction: (){
                    favoritePost(post);
                    },
                    )
                    ).toList(),
                  ),
                SizedBox(height: 50.0,)
                ]
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
