import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


//Calendar Import
import 'package:flutter_timeline_calendar/timeline/flutter_timeline_calendar.dart';
//import 'package:flutter_timeline_calendar/timeline/model/day_options.dart';
//import 'package:flutter_timeline_calendar/timeline/model/selected_day_options.dart';
import 'package:flutter_timeline_calendar/timeline/provider/instance_provider.dart';
import 'package:flutter_timeline_calendar/timeline/utils/datetime_extension.dart';

import 'main.dart';
import 'recipe.dart';


class MyCalendarPage extends StatefulWidget {
  @override
  _MyCalendarPageState createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<MyCalendarPage>  with AutomaticKeepAliveClientMixin<MyCalendarPage>{
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
      var selectedDay = myAppState.selectedDay;
      selectedDateTime = CalendarDateTime(year: selectedDay.year, month: selectedDay.month, day: selectedDay.day);
      ThemeData theme = Theme.of(context);

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
                myAppState.setSelectedDay(datetime.toDateTime());
                selectedDateTime = datetime;
                getLatestWeek();
            },
        onDateTimeReset: (resetDateTime) {
          myAppState.setSelectedDay(resetDateTime.toDateTime());
          selectedDateTime = resetDateTime;
          getLatestWeek();
        },
        onMonthChanged: (monthDateTime) {
              myAppState.setSelectedDay(monthDateTime.toDateTime());
          selectedDateTime = monthDateTime;
          getLatestWeek();
        },
        onYearChanged: (yearDateTime) {
              myAppState.setSelectedDay(yearDateTime.toDateTime());
          selectedDateTime = yearDateTime;
          getLatestWeek();
        },
      dateTime: selectedDateTime,
          ),
          Expanded(child:DayPage()),
        ],
      );
    }

  @override
  bool get wantKeepAlive => true;
  }

class DayPage extends StatelessWidget {
  const DayPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var myAppState = context.watch<MyAppState>();
    return ListView(
      children:[
        ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: myAppState.getRecipesForDay(myAppState.selectedDay).length,
      itemBuilder: (context, index) => DetailedRecipeCard(recipe:myAppState.getRecipesForDay(myAppState.selectedDay)[index])
    ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(onPressed: (){
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
                            myAppState.toggleInSavedRecipes(recipe);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                  );
                  },
                  );
                }, child: Text("Saved")),
              ),
               Expanded(
                 child: ElevatedButton(onPressed: (){
                  showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ListView.builder(
                      itemCount: myAppState.favouritedRecipes.length,
                      itemBuilder: (context, index){
                        Recipe recipe = myAppState.favouritedRecipes[index];
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
                               }, child: Text("Favorite")),
               ),
            ],
          ),
    ],
    );
  }
}

class DetailedRecipeCard extends StatefulWidget {
  const DetailedRecipeCard({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  State<DetailedRecipeCard> createState() => _DetailedRecipeCardState();
}

class _DetailedRecipeCardState extends State<DetailedRecipeCard> {
  @override
  Widget build(BuildContext context) {
   var myAppState = context.watch<MyAppState>();
   IconData icon = Icons.star_border;
   if(myAppState.favouritedRecipes.contains(widget.recipe)){
     icon = Icons.star;
   }
    return Center(
        child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(widget.recipe.title)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                            onPressed: (){
                                setState(() {
                                  myAppState.toggleInFavouritedRecipes(widget.recipe);
                                  print(myAppState.favouritedRecipes);
                                            });
                              },
                            child: Icon(
                          icon,
                        )),
                      )
                    ],
                  ),
                  CachedNetworkImage(
                  imageUrl: widget.recipe.thumbnail,
                  ),
                  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:Column(
                    children: [
                  for(int i = 0; i < widget.recipe.ingredients.length; i++)
                    Text("${widget.recipe.measures[i]} ${widget.recipe.ingredients[i]}"),
          ],
        ),
              ),
                  for(int i = 0; i < widget.recipe.instructions.length; i++)
                    Align(
                      alignment: Alignment.centerLeft,
                        child: Text((i+1).toString() + ". " + widget.recipe.instructions[i] + "\n")),
                  ElevatedButton(onPressed: (){
                    setState(() {
                      myAppState.removeRecipeFromDay(myAppState.selectedDay, widget.recipe);
                    });
                  },
                      child: Text("Remove Recipe")
                  )

                ],
              ),
            )));
  }
}
