import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class MyShoppingPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var myAppState = context.watch<MyAppState>();
    return Text('Shopping Page');
  }
}