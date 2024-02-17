import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MyCalendarPage.dart';
import 'MyRecipePage.dart';
import 'MyShoppingPage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Grocery Helper',
        theme: ThemeData(
          useMaterial3: true,

          //Need to add all of the colors to the colorscheme
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightGreen,
             primary: const Color.fromRGBO(45, 155, 64, 100),
            onPrimary: const Color.fromRGBO(0, 0, 0, 100)
          )
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var shoppingList = <String>[];


  //Variables in MyAppState are effectively shared
  //You should only modify them through these setters, that way it notifies the listeners
  void addToShoppingList(String s){
    if(!shoppingList.contains(s)){
      shoppingList.add(s);
      notifyListeners();
    }
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {

    //Variable for what page we are on
    var pageIndex = 0;
    //Variable for what icon on the navigation bar is selected
    var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var myAppState = context.watch<MyAppState>();
    var theme = Theme.of(context);
    // This variable holds the page which is displayed in the middle
    Widget page;

    NavigationDestinationLabelBehavior labelBehavior =
        NavigationDestinationLabelBehavior.onlyShowSelected;
    //Logic between switching between states
    switch(pageIndex) {
      case 0:
        page = MyRecipePage();
        break;
      case 1:
        page = MyCalendarPage();
        break;
      case 2:
        page = MyShoppingPage();
        break;
      case 3:
        //Settings Page
        page = Placeholder();
      default:
        throw UnimplementedError('no widget for $pageIndex');
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Grocery Helper',
        style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: theme.colorScheme.onPrimary,
        backgroundColor: theme.colorScheme.primary,
        actions: <Widget>[
          IconButton(
            color: theme.colorScheme.primary,
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              setState(() {
                if(pageIndex == 3){
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
      )
    );
  }
}
