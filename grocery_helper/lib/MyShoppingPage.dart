import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class MyShoppingPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var myAppState = context.watch<MyAppState>();
    return ListView(
      children: [
        Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Shopping List'),
            ),
          ),
        for( var item in myAppState.shoppingList)
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