import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


//Calendar Import
import 'package:flutter_timeline_calendar/timeline/dictionaries/dictionary.dart';
import 'package:flutter_timeline_calendar/timeline/dictionaries/en.dart';
import 'package:flutter_timeline_calendar/timeline/dictionaries/fa.dart';
import 'package:flutter_timeline_calendar/timeline/dictionaries/pt.dart';
import 'package:flutter_timeline_calendar/timeline/flutter_timeline_calendar.dart';
import 'package:flutter_timeline_calendar/timeline/handlers/calendar_monthly_utils.dart';
import 'package:flutter_timeline_calendar/timeline/handlers/translator.dart';
import 'package:flutter_timeline_calendar/timeline/model/calendar_options.dart';
import 'package:flutter_timeline_calendar/timeline/model/datetime.dart';
//import 'package:flutter_timeline_calendar/timeline/model/day_options.dart';
import 'package:flutter_timeline_calendar/timeline/model/headers_options.dart';
import 'package:flutter_timeline_calendar/timeline/model/select_month_options.dart';
import 'package:flutter_timeline_calendar/timeline/model/select_year_options.dart';
//import 'package:flutter_timeline_calendar/timeline/model/selected_day_options.dart';
import 'package:flutter_timeline_calendar/timeline/provider/calendar_provider.dart';
import 'package:flutter_timeline_calendar/timeline/provider/gregorian_calendar.dart';
import 'package:flutter_timeline_calendar/timeline/provider/instance_provider.dart';
import 'package:flutter_timeline_calendar/timeline/utils/calendar_types.dart';
import 'package:flutter_timeline_calendar/timeline/utils/calendar_utils.dart';
import 'package:flutter_timeline_calendar/timeline/utils/datetime_extension.dart';
import 'package:flutter_timeline_calendar/timeline/utils/style_provider.dart';
import 'package:flutter_timeline_calendar/timeline/widget/calendar_daily.dart';
import 'package:flutter_timeline_calendar/timeline/widget/calendar_monthly.dart';
import 'package:flutter_timeline_calendar/timeline/widget/day.dart';
import 'package:flutter_timeline_calendar/timeline/widget/header.dart';
import 'package:flutter_timeline_calendar/timeline/widget/select_day.dart';
import 'package:flutter_timeline_calendar/timeline/widget/select_month.dart';
import 'package:flutter_timeline_calendar/timeline/widget/select_year.dart';
import 'package:flutter_timeline_calendar/timeline/widget/timeline_calendar.dart';

import 'main.dart';
import 'recipe.dart';


class MyCalendarPage extends StatefulWidget {
  @override
  _MyCalendarPageState createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<MyCalendarPage> {
  late CalendarDateTime selectedDateTime;
  late DateTime? weekStart;
  late DateTime? weekEnd;
  @override
  void initState() {
    super.initState();
    TimelineCalendar.calendarProvider = createInstance();
    selectedDateTime = TimelineCalendar.calendarProvider.getDateTime();
    getLatestWeek();
  }

  getLatestWeek() {
    setState(() {
      weekStart = selectedDateTime.toDateTime().findFirstDateOfTheWeek();
      weekEnd = selectedDateTime.toDateTime().findLastDateOfTheWeek();
    });
  }

    @override
    Widget build(BuildContext context) {
      var myAppState = context.watch<MyAppState>();
      ThemeData theme = Theme.of(context);
      myAppState.selectedDay = (DateFormat('EEEE, MMMM d, y').format(
                    selectedDateTime.toDateTime()));

      return Column(
        children: [
          TimelineCalendar(
            calendarType: CalendarType.GREGORIAN,
            calendarLanguage: "en",
            calendarOptions: CalendarOptions(
              viewType: ViewType.DAILY,
              toggleViewType: false,
              headerMonthElevation: 10,
              headerMonthShadowColor: Colors.black26,
              headerMonthBackColor: Colors.transparent,
            ),
            dayOptions: DayOptions(
              compactMode: true,
              weekDaySelectedColor: theme.colorScheme.primary,
              todayBackgroundColor: theme.colorScheme.primary,
              todayTextColor: theme.colorScheme.primary,
              selectedBackgroundColor: theme.colorScheme.primary,
              disableDaysBeforeNow: false,
            ),
            headerOptions: HeaderOptions(
              weekDayStringType: WeekDayStringTypes.SHORT,
              monthStringType: MonthStringTypes.FULL,
              calendarIconColor: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.primary,
              headerTextColor: Colors.black,
            ),
          onChangeDateTime: (datetime) {
                String selectedDayText = DateFormat('EEEE, MMMM d, y').format(
                    datetime.toDateTime());
                myAppState.setSelectedDay(selectedDayText);
                selectedDateTime = datetime;
                getLatestWeek();
            },
        onDateTimeReset: (resetDateTime) {
          selectedDateTime = resetDateTime;
          getLatestWeek();
        },
        onMonthChanged: (monthDateTime) {
          selectedDateTime = monthDateTime;
          getLatestWeek();
        },
        onYearChanged: (yearDateTime) {
          selectedDateTime = yearDateTime;
          getLatestWeek();
        },
      dateTime: selectedDateTime,
          ),
          Expanded(child:DayPage()),
        ],
      );
    }
  }

class DayPage extends StatelessWidget {
  const DayPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var myAppState = context.watch<MyAppState>();
    var ingredients = myAppState.ingredients;
    return ListView(
      children:[
        ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: myAppState.getRecipesForDay(myAppState.selectedDay).length,
      itemBuilder: (context, index) => DetailedRecipeCard(recipe:myAppState.getRecipesForDay(myAppState.selectedDay)[index])
    ),
        ElevatedButton(onPressed: (){
          showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return ListView.builder(
              itemCount: myAppState.savedRecipes.length,
              itemBuilder: (context, index){
                Recipe recipe = myAppState.savedRecipes[index];
                return ListTile(
                  title: Text(recipe.title),
                  onTap: () {
                    myAppState.addRecipeToDay(
                      myAppState.selectedDay,
                      recipe,
                    );
                    Navigator.of(context).pop();
                  },
                );
              },
          );
          },
          );
        }, child: Text("Add Recipes"))
    ],
    );
  }
}

class DetailedRecipeCard extends StatelessWidget {
  const DetailedRecipeCard({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;


  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(recipe.title),
                  CachedNetworkImage(
                  imageUrl: recipe.thumbnail,
                  ),
                  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:Column(
                    children: [
                  for(int i = 0; i < recipe.ingredients.length; i++)
                    if(recipe.ingredients[i] != null)
                      Text("${recipe.measures[i]} ${recipe.ingredients[i]}"),
          ],
        ),
              ),
                  for(int i = 0; i < recipe.instructions.length; i++)
                    Align(
                      alignment: Alignment.centerLeft,
                        child: Text((i+1).toString() + ". " + recipe.instructions[i] + "\n")),

                ],
              ),
            )));
  }
}
