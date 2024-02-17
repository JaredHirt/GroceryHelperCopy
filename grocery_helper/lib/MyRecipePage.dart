import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
class MyRecipePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var myAppState = context.watch<MyAppState>();
    return Text('Times Went to Recipe Page');
  }
}