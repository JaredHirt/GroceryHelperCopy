import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_timeline_calendar/timeline/provider/instance_provider.dart';
import 'package:flutter_timeline_calendar/timeline/widget/timeline_calendar.dart';
import 'package:intl/intl.dart';
import 'recipe.dart';
import 'package:provider/provider.dart';

import 'MyCalendarPage.dart';
import 'MyRecipePage.dart';
import 'MyShoppingPage.dart';

void main()  => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Grocery Helper',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightGreen,
            primary: const Color.fromRGBO(45, 155, 64, 100),
            onPrimary: const Color.fromRGBO(0, 0, 0, 100),
          ),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var savedRecipes = <Recipe>[];
   var favouritedRecipes = <Recipe>[];


  //Calendar Stuff
  DateTime selectedDay = DateTime.now();
  DateTimeRange range = DateTimeRange(start: DateTime.now(), end: DateTime.now());


  //Gets a list of DateTime in a range
  List<DateTime> getDaysInBetween(DateTimeRange range) {
    DateTime startDate = range.start;
    DateTime endDate = range.end;
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(
        DateTime(
          startDate.year,
          startDate.month,
          startDate.day + i)
      );
    }
    return days;
}

  Map<String, List<Recipe>> recipesForDay = HashMap();

  String formatDate(DateTime day){
    return DateFormat('EEEE, MMMM d, y').format(day);
  }

  void setSelectedDay(DateTime day){
    selectedDay = day;
    notifyListeners();
  }

  List<Recipe> getRecipesForDay(DateTime day){
    if(recipesForDay[formatDate(day)] == null){
      return [];
    }
    return recipesForDay[formatDate(day)]!;
  }

  void addRecipeToDay(DateTime day, Recipe rec){
    if(recipesForDay[formatDate(day)] == null){
      recipesForDay[formatDate(day)] = [];
    }
    if(!recipesForDay[formatDate(day)]!.contains(rec)) {
      recipesForDay[formatDate(day)]!.add(rec);
    }
    notifyListeners();
  }
  void removeRecipeFromDay(DateTime day, Recipe rec){
    if(recipesForDay[formatDate(day)] == null){
      recipesForDay[formatDate(day)] = [];
    }
    if(recipesForDay[formatDate(day)]!.contains(rec)) {
      recipesForDay[formatDate(day)]!.remove(rec);
    }
    notifyListeners();
  }


  //Shopping List Stuff
  List<ItemOnList> ingredients = [] ;



  void refreshShoppingList(){
    List<DateTime> dates = getDaysInBetween(range);
    for(var date in dates) {
      var list = getRecipesForDay(date);
      for (var rec in list) {
        for (var item in rec.ingredients) {
          if (!containsIngredient(item)) {
            ingredients.add(ItemOnList(
                key: Key("List Item Key"), ingredient: item, value: false));
          }
        }
      }
    }


    List<ItemOnList> itemsToRemove = [];
    for(ItemOnList i in ingredients){
      if(!ingredientUsedInDateRange(i.ingredient)){
        itemsToRemove.add(i);
      }
    }

    for(ItemOnList item in itemsToRemove){
      ingredients.remove(item);
    }



    ingredients.sort( (a,b) => a.getString().compareTo(b.getString()));
  }

  bool containsIngredient(String s){
    for(var i in ingredients) {
      if(i.getString() == s) {
        return true;
      }
    }
    return false;
  }

  bool ingredientUsedInDateRange(String s) {
  List<DateTime> dates = getDaysInBetween(range);
    for (var date in dates) {
      var list = getRecipesForDay(date);
      for (Recipe rec in list) {
        for (String ing in rec.ingredients) {
          if (s == ing) {
            return true;
          }
        }
      }
    }
    return false;
  }

  //end of Shopping List Stuff

  bool isInitialized = false;
  //Buffer
  List<Recipe> recipeList = [];

  setDateTimeRange(DateTimeRange dateRange){
    range = dateRange;
    notifyListeners();
  }


  Future<void> addRecipesToEndOfList() async{
    if(isInitialized == false){
     TimelineCalendar.calendarProvider = createInstance();
      selectedDay = TimelineCalendar.calendarProvider.getDateTime().toDateTime();
    }
    int recipesLeftToAdd = 10;
    while(recipesLeftToAdd > 0){
      try {
        await fetchRecipe().then((value) =>  recipeList.add(value));
        recipesLeftToAdd--;
      } on FormatException {print("Failed to get Recipe");}
    }
    print('Recipes Added To End Of List');
    isInitialized = true;
    notifyListeners();
  }



  void toggleInSavedRecipes(Recipe r) {
    if (!savedRecipes.contains(r)) {
      savedRecipes.add(r);
    }
    else {
      savedRecipes.remove(r);
    }
      notifyListeners();
  }

    void toggleInFavouritedRecipes(Recipe r) {
    if (!favouritedRecipes.contains(r)) {
      favouritedRecipes.add(r);
    }
    else {
      favouritedRecipes.remove(r);
    }
      notifyListeners();
  }
}







class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var pageIndex = 0;
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var myAppState = context.watch<MyAppState>();
    if(myAppState.isInitialized == false) {

      myAppState.addRecipesToEndOfList();
      return Scaffold(
        body: Center(
          child: Image.asset(
              'assets/grocery_logo.png'), // Replace with your image path
        ),
      );
    }
    var theme = Theme.of(context);
    Widget page;

    NavigationDestinationLabelBehavior labelBehavior =
        NavigationDestinationLabelBehavior.onlyShowSelected;

    switch (pageIndex) {
      case 0:
        page = const MyRecipePage();
        break;
      case 1:
        page = MyCalendarPage();
        break;
      case 2:
        page = const MyShoppingPage();
        break;
      case 3:
        page = const Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $pageIndex');
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Grocery Helper', style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: theme.colorScheme.onPrimary,
        backgroundColor: theme.colorScheme.primary,
        actions: <Widget>[
          IconButton(
            color: theme.colorScheme.primary,
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              setState(() {
                if (pageIndex == 3) {
                  pageIndex = selectedIndex;
                } else {
                  pageIndex = 3;
                }
              });
            },
          ),
        ],
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 9/16,
            child: page,
        ),
      ),
      backgroundColor: theme.colorScheme.background,
      bottomNavigationBar: NavigationBar(
        labelBehavior: labelBehavior,
        selectedIndex: selectedIndex,
        backgroundColor: theme.colorScheme.primary,
        onDestinationSelected: (value) {
          setState(() {
            pageIndex = value;
            selectedIndex = value;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            selectedIcon: Icon(Icons.restaurant_menu_outlined),
            label: 'Recipes',
          ),
          NavigationDestination(
            icon: Icon(Icons.today),
            selectedIcon: Icon(Icons.today_outlined),
            label: 'Meal Plan',
          ),
          NavigationDestination(
            icon: Icon(Icons.price_check),
            selectedIcon: Icon(Icons.price_check_outlined),
            label: 'Shopping Lists',
          ),
        ],
      ),
    );
  }
}
