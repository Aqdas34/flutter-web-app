import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:only_shef/common/constants/global_variable.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../common/constants/http_response.dart';
import '../../../provider/user_provider.dart';
import '../models/chef.dart';
import '../models/cuisines.dart';

class ChefGigServices {
  Future<List<Chef>> getChefProfiles(
    BuildContext context,
    String cuisineDetails,
  ) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    try {
      cuisineDetails = cuisineDetails.replaceFirst(" Cuisine", "");

      // Construct URL with query parameter
      final uri_1 = Uri.parse('$uri/api/listBySpeciality').replace(
        queryParameters: {'speciality': cuisineDetails},
      );

      final response = await http.get(
        uri_1,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': user.token,
        },
      );
      // print(response.body);

      List<Chef> chefProfiles = [];
      httpErrorHandling(
        response: response,
        // ignore: use_build_context_synchronously
        context: context,
        onSuccess: () {
          final List<dynamic> jsonData = jsonDecode(response.body);
          print(jsonData);
          // print(jsonData);
          chefProfiles = jsonData.map((json) => Chef.fromJson(json)).toList();
          // chefProfiles.forEach((element) {
          //   print(element.backgroundImage);
          // });
          print("chefProfiles[0].name${chefProfiles[0].name}");
          print(chefProfiles.length);
          for (var element in chefProfiles) {
            print(element.name);
          }

          // print(chefProfiles[0].toString());
          // Handle the response here (e.g., parse JSON or update state)
        },
      );
      return chefProfiles;
    } catch (error) {
      // Handle any errors (e.g., network errors)

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No Chef Found')),
      );
    }
    return [];
  }

  Future<List<Cuisine>> getChefCuisine(
    BuildContext context,
    String chefId,
  ) async {
    List<Cuisine> cuisine = [];
    final user = Provider.of<UserProvider>(context, listen: false).user;

    try {
      // Construct URL with query parameter
      final uri_1 = Uri.parse('$uri/api/listChefCuisines').replace(
        queryParameters: {'chefId': chefId},
      );

      final response = await http.get(
        uri_1,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': user.token,
        },
      );

      httpErrorHandling(
        response: response,
        // ignore: use_build_context_synchronously
        context: context,
        onSuccess: () {
          final List<dynamic> jsonData = jsonDecode(response.body);
          cuisine = jsonData.map((json) => Cuisine.fromJson(json)).toList();
          // Handle the response here (e.g., parse JSON or update state)
        },
      );
      return cuisine;
    } catch (error) {
      // Handle any errors (e.g., network errors)
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching chef cuisines')),
      );
    }
    return cuisine;
  }
}
