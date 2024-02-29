import 'package:flutter/material.dart';
import 'package:grocery_helper/recipe.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class MyShoppingPage extends StatefulWidget{
  const MyShoppingPage({super.key});

  @override
  State<MyShoppingPage> createState() => _MyShoppingPageState();
}

class _MyShoppingPageState extends State<MyShoppingPage> {
  List<String> ingredients = [] ;
  void addToShoppingList(List<Recipe> list){
    for(var rec in list){
      for(var item in rec.ingredients){
        if(!ingredients.contains(item)){
          ingredients.add(item);
        }
      }
    }
    ingredients.sort( (a,b) => a.compareTo(b));
  }


  @override
  Widget build(BuildContext context) {
    var myAppState = context.watch<MyAppState>();
    addToShoppingList(myAppState.savedRecipes);
    return ListView(
      children: [
        const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Shopping List'),
            ),
          ),
        for( var item in ingredients)
          ItemOnList(ingredient: item),
      ],
    );
  }
}

class ItemOnList extends StatelessWidget {
  const ItemOnList({
    super.key,
    required this.ingredient,
  });

  final String ingredient;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(ingredient,
                  textAlign: TextAlign.center,),
      ),
    );
  }
}