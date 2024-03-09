import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:grocery_helper/recipe.dart';
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
  Map<String, List<Recipe>> recipesForDay = HashMap();


  //Calendar Stuff
  String selectedDay = "";

  void setSelectedDay(String day){
    selectedDay = day;
    notifyListeners();
  }


  //Shopping List Stuff
  List<ItemOnList> ingredients = [] ;



  void addToShoppingList(List<Recipe> list){
    for(var rec in list){
      for(var item in rec.ingredients){
        if(!containsIngredient(item)){
          ingredients.add(ItemOnList(ingredient:item, value:false));
        }
      }
    }


    List<ItemOnList> itemsToRemove = [];
    for(ItemOnList i in ingredients){
      if(!ingredientUsedInSavedRecipe(i.ingredient)){
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

  bool ingredientUsedInSavedRecipe(String s){
    for(Recipe rec in savedRecipes){
      for(String ing in rec.ingredients){
        if(s == ing){
          return true;
        }
      }
    }
    return false;
  }

  //end of Shopping List Stuff

  bool isInitialized = false;
  //Buffer
  List<Recipe> recipeList = [];

  int recipeIndex = -1;
  MyAppState(){
    getFirstRecipe(initializeRecipe());
  }

  void getFirstRecipe(Future<void> future) async {
    await future;
    getNextRecipe();
  }

  Future<void> initializeRecipe() async {
    bool newRecipe = false;
    while(!newRecipe) {
      try {
        await fetchRecipe().then((value) =>  recipeList.add(value));
        newRecipe = true;
        notifyListeners();
      } on FormatException {print("Failed to get Recipe");}
    }
     isInitialized = true;
    notifyListeners();
  }


  void getNextRecipe()  {
    recipeIndex++;
    addRecipesToEndOfList();
    notifyListeners();
  }
  void getPreviousRecipe() {
    if(recipeIndex > 0) {
      recipeIndex--;
    }
    notifyListeners();
  }

  void addRecipesToEndOfList() async{
    while(recipeIndex < recipeList.length + 10){
      try {
        await fetchRecipe().then((value) =>  recipeList.add(value));
      } on FormatException {print("Failed to get Recipe");}
    }

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
        child: page,
      ),
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
