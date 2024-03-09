import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
   class Recipe{
     final List<String> ingredients;
     final List<String> measures;
     final String title;
     final String category;
     final List<String> instructions;
     final String id;
     final String thumbnail;
     final String tags;






      const Recipe({
       required this.ingredients,
        required this.measures,
       required this.title,
       required this.category,
       required this.instructions,
       required this.id,
       required this.thumbnail,
       required this.tags,
  });










   factory Recipe.fromJson(Map<String, dynamic> json) {

      final ingredients = <String>[];
      final measures = <String>[];
      final instructions;
      for(int i = 1; i <= 20; i++){
        if(json['strIngredient$i'] != null && json['strIngredient$i'] != '') {
          ingredients.add(json['strIngredient$i']);
          measures.add(json['strMeasure$i']);
        }
      }
      instructions = json['strInstructions'].toString().split('\r\n');

    return switch (json) {
      {
        'strMeal': String title,
      'idMeal': String id,
      'strCategory': String category,
      'strMealThumb': String thumbnail,
      'strTags': String tags,

      } =>
      
      
        Recipe(
          ingredients: ingredients,
          measures: measures,
          title: title,
          category: category,
          instructions: instructions,
          id: id,
          thumbnail: thumbnail,
          tags: tags,
        ),
      _ => throw const FormatException('Failed to load recipe.'),
    };
  }
}


  Future<Recipe> fetchRecipe() async {
    final response = await http
        .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Recipe.fromJson(jsonDecode(response.body.substring(10, response.body.length - 2)) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load recipe');
    }
  }

