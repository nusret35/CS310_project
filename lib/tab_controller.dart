import 'package:flutter/material.dart';
import 'package:untitled/feed_view.dart';
import 'package:untitled/routes/profile_view.dart';
import 'package:untitled/util/colors.dart';

class TabView extends StatelessWidget {
  const TabView({Key? key}) : super(key: key);

  static const routename = '/tabview';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Image(
              image: AssetImage('assets/logo.png'),
              width: 200,
            ),
            leading: GestureDetector (
              onTap: () => {},
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: CircleAvatar(
                  backgroundColor: AppColors.greenAccent_tab_control,
                  backgroundImage: NetworkImage('https://i1.rgstatic.net/ii/profile.image/279526891376650-1443655812881_Q512/Baris-Altop.jpg'),
                ),
              ),
            ),
            centerTitle: true,
            foregroundColor: AppColors.primary,
            backgroundColor: AppColors.whiteTextColor,
            elevation: 10.0,

          ),
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              FeedView(),ProfileView(),
            ],
          ),
        )
    );
  }


  Widget menu() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteTextColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey_tab_control,
            blurRadius: 10.0,
            spreadRadius: 0.0,
            offset: Offset(0, 2.0)
          )
        ]
      ),
      child: TabBar(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.grey_tab_control,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: AppColors.primary,
        tabs: [
          Tab(
            text: "Home",
            icon: Icon(Icons.home),
          ),
          Tab(
            text: "Profile",
            icon: Icon(Icons.person),
          ),
        ],

      ),
    );
  }
  /*
  Widget bottomNavBar() {
    return BottomNavigationBar(
        selectedItemColor: Color(0xFF6034A8),
        unselectedItemColor: Colors.grey,
        elevation: 20.0,
        ğ
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Person',
          )
        ],
    );
  }

   */
}
