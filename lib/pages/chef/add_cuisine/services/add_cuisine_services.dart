import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:only_shef/common/constants/global_variable.dart';
import 'package:only_shef/common/constants/http_response.dart';
import 'package:only_shef/provider/user_provider.dart';
import 'package:provider/provider.dart';
import '../../../cuisine/models/cuisines.dart';

class AddCuisineServices {
  Future<bool> addCuisine(
    BuildContext context,
    Cuisine cuisine,
  ) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    try {
      final response = await http.post(
        Uri.parse('$uri/api/addCuisine'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': user.token,
        },
        body: jsonEncode({
          'CuisineType': cuisine.cuisineType,
          'Name': cuisine.name,
          'Ingredients': cuisine.ingredients,
          'Price': cuisine.price,
          'Description': cuisine.description,
          'ImageURL':
              "https://realfood.tesco.com/media/images/Burger-31LGH-a296a356-020c-4969-86e8-d8c26139f83f-0-1400x919.jpg",
        }),
      );
      print(response.body);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cuisine added successfully!')),
        );
        return true;
      } else {
        httpErrorHandling(
          response: response,
          context: context,
          onSuccess: () {}, // Empty callback since we're handling success above
        );
        return false;
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding cuisine: ${error.toString()}')),
      );
      return false;
    }
  }

  Future<bool> updateCuisine(
    BuildContext context,
    Cuisine cuisine,
  ) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    try {
      final response = await http.put(
        Uri.parse('$uri/api/updateCuisine/${cuisine.id}'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': user.token,
        },
        body: jsonEncode({
          'CuisineType': cuisine.cuisineType,
          'Name': cuisine.name,
          'Ingredients': cuisine.ingredients,
          'Price': cuisine.price,
          'Description': cuisine.description,
          'ImageURL': cuisine.imageUrl,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cuisine updated successfully!')),
        );
        return true;
      } else {
        httpErrorHandling(
          response: response,
          context: context,
          onSuccess: () {}, // Empty callback since we're handling success above
        );
        return false;
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating cuisine: ${error.toString()}')),
      );
      return false;
    }
  }
}
