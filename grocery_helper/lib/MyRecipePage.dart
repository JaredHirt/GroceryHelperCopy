import 'package:cached_network_image/cached_network_image.dart';
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
 final _controller = PageController();
 int _page = 0;

  void updateRecipeCards(List<Recipe> list){
    for(int i = recipeCards.length; i <= list.length; i++){
      recipeCards.add(RecipeCard(index:i));
    }
  }

  @override
  void initState(){
    super.initState();
    _controller.addListener(() => setState(() {
    }));
  }

  @override
  Widget build(BuildContext context) {
    var myAppState = context.watch<MyAppState>();
    updateRecipeCards(myAppState.recipeList);

    IconData likeIcon;


      if(myAppState.savedRecipes.contains(myAppState.recipeList[_page])) {
      likeIcon = Icons.favorite;
    }
    else {likeIcon = Icons.favorite_border_outlined;}


    return Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              key: const PageStorageKey('RecipeFinder'),
              controller: _controller,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
                myAppState.currentRecipe = myAppState.recipeList[index];
                  _page = index;
                return recipeCards[index];
            },
            ),
        Align(
          alignment: Alignment.bottomRight,
            child: ElevatedButton(
                onPressed: () {
                    myAppState.toggleInSavedRecipes(myAppState.currentRecipe);
                    },
                child:  Icon(
                  likeIcon,

                )
            )
            ),
          ],
        ),
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
    ThemeData theme = Theme.of(context);
    Recipe recipe = myAppState.recipeList[index];
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,

      body: Center(
        child: Card(
        child: Column(
          children: [
            Text(recipe.title),
            CachedNetworkImage(
              imageUrl: recipe.thumbnail,
            ),

        ]
        )
            ),
      )

    );
  }
}


