import 'package:flutter/material.dart';
import 'package:untitled/feed_view.dart';
import 'package:untitled/routes/notification_view.dart';
import 'package:untitled/routes/profile_view.dart';
import 'package:untitled/routes/schedule_view.dart';
import 'package:untitled/settings/settings_view.dart';
import 'package:untitled/util/colors.dart';
import 'package:untitled/routes/search_view.dart';

class TabView extends StatelessWidget {
  const TabView({Key? key}) : super(key: key);

  static const routename = '/tabview';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: Image(
              image: AssetImage('assets/logo.png'),
              width: 200,
            ),
            actions: [
              IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsView(title: 'Settings')));
                },
                icon: Icon(Icons.settings)
              ),
            ],
            centerTitle: true,
            foregroundColor: AppColors.primary,
            backgroundColor: AppColors.whiteTextColor,
            elevation: 10.0,

          ),
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              FeedView(),SearchView(),ScheduleView(),NotificationView(),ProfileView()
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
            text: 'Search',
            icon: Icon(Icons.search),
          ),
          Tab(
            text: "Schedule",
            icon: Icon(Icons.calendar_today),
          ),
          Tab(
            text: "Activity",
            icon: Icon(Icons.newspaper),
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
