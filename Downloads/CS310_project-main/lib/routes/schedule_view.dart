import 'package:flutter/material.dart';
import 'package:untitled/util/objects.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({Key? key}) : super(key: key);

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {

  int programIndex = 0;

  void _changeDay(int dayIndex)
  {
    setState(() {
      for (int i = 0; i<days.length; i++)
        {
          if (days[i].isSelected == true)
            {
              days[i].isSelected = false;
            }
        }
      programIndex = dayIndex;
      days[dayIndex].isSelected = true;
    });
  }

  List<Day> days = [Day('MON'),Day('TUE'),Day('WED'),Day('THU'),Day('FRI'),Day('SAT'),Day('SUN')];
  
  List<Event> mondayProgram = [Event(event: 'CS303', time: '08.40-09.30'), Event(event: 'ECON202', time: '09.40-11.30')];
  List<Event> tuesdayProgram = [Event(event: 'ECON202', time: '14.40-15.30')];
  List<Event> wednesdayProgram = [Event(event: 'CS303-LAB', time: '08.40-10.30'),Event(event: 'HUM202', time: '10.40-12.30'),Event(event: 'CS310', time: '12.40-13.30')];
  List<Event> thurdayProgram = [Event(event: 'FIN403', time: '08.40-10.30'),Event(event: 'HUM202-DISCUSSION', time: '10.40-11.30'),Event(event: 'CS310', time: '12.40-14.30'),Event(event: 'CS303', time: '14.40-16.30')];
  List<Event> fridayProgram = [Event(event: 'CS310-RECIT', time: '08.40-09.30'),Event(event: 'ECON202-RECIT', time: '11.40-12.30')];

  List<DailyProgram> weeklyProgram = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weeklyProgram = [DailyProgram(mondayProgram,day: 'Monday'),DailyProgram(tuesdayProgram,day: 'Tuesday',),DailyProgram(wednesdayProgram,day: 'Wednesday'),DailyProgram(thurdayProgram,day: 'Thursday'),DailyProgram(fridayProgram, day: 'Friday'), DailyProgram.onlyDay(day: 'Saturday'), DailyProgram.onlyDay(day: 'Sunday')];
    days[0].isSelected = true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  elevation: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Schedule',
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: days.map((day) => DayBox(
                                day: day, changeDayProgram: (){
                                  _changeDay(days.indexOf(day));
                                  },
                            )
                            ).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.0,),
                DailyProgramView(dailyProgram: weeklyProgram[programIndex]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
