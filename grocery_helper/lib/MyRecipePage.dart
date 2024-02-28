import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'recipe.dart';
class MyRecipePage extends StatefulWidget{
  const MyRecipePage({super.key});

  @override
  State<MyRecipePage> createState() => _MyRecipePageState();
}

class _MyRecipePageState extends State<MyRecipePage> {

 List<RecipeCard> recipeCards = [];

  void updateRecipeCards(List<Recipe> list){
    for(int i = recipeCards.length; i <= list.length; i++){
      recipeCards.add(RecipeCard(index:i));
    }
  }

  @override
  Widget build(BuildContext context) {
    var myAppState = context.watch<MyAppState>();
    updateRecipeCards(myAppState.recipeList);



    return Column(
      children: [
        const Text('Recipe Page'),
        recipeCards[myAppState.recipeIndex],
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                    myAppState.addToShoppingList(myAppState.currentRecipe.title);
                    myAppState.getPreviousRecipe();
                    },
                child: const Icon(
                  Icons.arrow_back
                  )
                  ),
            ElevatedButton(
                onPressed: () {
                    myAppState.addToShoppingList(myAppState.currentRecipe.title);
                    myAppState.getNextRecipe();
                    },
                child: const Icon(
                  Icons.favorite
                )),
            ElevatedButton(
                onPressed: () {
                    myAppState.getNextRecipe();
                    },
                child: const Icon( Icons.arrow_forward),
            )
          ],
        ),
      ],
    );
  }
}

class RecipeCard extends StatelessWidget {
  final int index;
  const RecipeCard({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    var myAppState = context.watch<MyAppState>();
    Recipe recipe = myAppState.recipeList[index];
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


