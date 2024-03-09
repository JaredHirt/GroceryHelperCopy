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
      itemCount: ingredients.length,
      itemBuilder: (context, index) => ingredients[index]
    ),
        Text("Replace Me With Recipe Select Button")
    ],
    );
  }
}
