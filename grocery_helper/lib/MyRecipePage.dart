import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

import 'main.dart';
class MyRecipePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var myAppState = context.watch<MyAppState>();
    return Column(
      children: [
        Text('Recipe Page'),
        ElevatedButton(
            onPressed: () {
                myAppState.addToShoppingList(WordPair.random().toString());
                },
            child: Text('Add Random Word To Shopping List')),
      ],
    );
  }
}