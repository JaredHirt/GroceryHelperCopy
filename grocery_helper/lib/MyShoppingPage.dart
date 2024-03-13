import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class MyShoppingPage extends StatefulWidget{
  const MyShoppingPage({super.key});


  @override
  State<MyShoppingPage> createState() => _MyShoppingPageState();
}

class _MyShoppingPageState extends State<MyShoppingPage> {



  @override
  Widget build(BuildContext context) {
    var myAppState = context.watch<MyAppState>();
    var ingredients = myAppState.ingredients;

    myAppState.refreshShoppingList();
    return Scaffold(
      body:Column(
            children: [
                ElevatedButton(
                  child: Text('Select Dates For Shopping'),
                  onPressed: () async {
                    DateTime firstDate = DateTime(myAppState.selectedDay.year - 5 );
                    DateTime lastDate = DateTime(myAppState.selectedDay.year + 5 );
                    DateTimeRange? range = await showDateRangePicker(context: context, firstDate: firstDate, lastDate: lastDate);
                    if(range != null){
                      myAppState.setDateTimeRange(range);
                    }
                  },
              ),

               Expanded(
                 child: ListView.builder(
                    key: const PageStorageKey('Shopping List'),
                    itemCount:ingredients.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ingredients[index];
                  },
                  ),
               ),
            ],
          ),
        );
  }
}

class ItemOnList extends StatefulWidget {
  ItemOnList({
    super.key,
    required this.ingredient,
    required this.value,
  });

  final String ingredient;

  bool value;
  String getString(){
    return ingredient;
  }

  @override
  State<ItemOnList> createState() => _ItemOnListState();
}

class _ItemOnListState extends State<ItemOnList> {




  @override
  Widget build(BuildContext context) {
    TextDecoration decoration;
    if(widget.value){
      decoration = TextDecoration.lineThrough;
    }
    else{
      decoration = TextDecoration.none;
    }
    return CheckboxListTile(
      value: widget.value,
      title: Text(widget.ingredient, style: TextStyle(decoration: decoration)),
      onChanged: (bool? value) {
        setState(() {
          widget.value = value!;
        });


      },
    );
  }

}