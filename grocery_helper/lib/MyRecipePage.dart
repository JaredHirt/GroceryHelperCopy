import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'recipe.dart';
class MyRecipePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var myAppState = context.watch<MyAppState>();
    return Column(
      children: [
        Text('Recipe Page'),
        ElevatedButton(
            onPressed: () {
                myAppState.addToShoppingList(myAppState.currentRecipe.title);
                myAppState.getNextRecipe();

                },
            child: Text('Add Recipe To Shopping List')),
        RecipeCard(),
      ],
    );
  }
}

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var myAppState = context.watch<MyAppState>();
    Recipe recipe = myAppState.currentRecipe;
    return Card(
      child: Column(
        children: [
          Text(recipe.title),
          Image.network(recipe.thumbnail),
      ]
      )
    );
  }
}