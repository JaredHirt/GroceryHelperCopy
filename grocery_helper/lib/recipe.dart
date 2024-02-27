import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
   class Recipe{
     final List<String> ingredients;
     final String title;
     final String category;
     final String instructions;
     final String id;
     final String thumbnail;
     final String tags;






      const Recipe({
       required this.ingredients,
       required this.title,
       required this.category,
       required this.instructions,
       required this.id,
       required this.thumbnail,
       required this.tags,
  });










   factory Recipe.fromJson(Map<String, dynamic> json) {

      final ingredients = <String>[];
    return switch (json) {
      {
        'strMeal': String title,
      'idMeal': String id,
      'strCategory': String category,
      'strInstructions': String instructions,
      'strMealThumb': String thumbnail,
      'strTags': String tags,

      } =>
        Recipe(
          ingredients: ingredients,
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

