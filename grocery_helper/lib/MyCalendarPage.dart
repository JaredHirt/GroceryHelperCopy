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

void main() {
  runApp(
    MaterialApp(
      home: MyCalendarPage(),
    ),
  );
}


class MyAppState extends ChangeNotifier {
  String _selectedDayText = "";

  String get selectedDayText => _selectedDayText;

  void updateSelectedDay(String newSelectedDay) {
    _selectedDayText = newSelectedDay;
    notifyListeners();
  }
}

class MyCalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAppState>(create: (_) => MyAppState()),
        // Add other providers if needed
      ],
      child: _MyCalendarPage(),
    );
  }
}

class _MyCalendarPage extends StatefulWidget {
  @override
  _MyCalendarPageState createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<_MyCalendarPage> {
  @override
  Widget build(BuildContext context) {
    var myAppState = context.watch<MyAppState>();

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
            weekDaySelectedColor: const Color(0xff3AC3E2),
            disableDaysBeforeNow: true,
          ),
          headerOptions: HeaderOptions(
            weekDayStringType: WeekDayStringTypes.SHORT,
            monthStringType: MonthStringTypes.FULL,
            backgroundColor: const Color(0xff3AC3E2),
            headerTextColor: Colors.black,
          ),
          onChangeDateTime: (datetime) {
            String selectedDayText = DateFormat('EEEE, MMMM d, y').format(datetime.toDateTime());
            myAppState.updateSelectedDay(selectedDayText);
          },
        ),
        SizedBox(height: 10),
        Consumer<MyAppState>(
          builder: (context, myAppState, child) {
            return Text(
              myAppState.selectedDayText,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            );
          },
        ),
      ],
    );
  }
}
