import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:only_shef/common/constants/global_variable.dart';
import 'package:only_shef/pages/cuisine/models/chef.dart';
import 'package:provider/provider.dart';

import '../../../provider/user_provider.dart';

class SearchServices {
  // static const String baseUrl =
  //     'YOUR_API_BASE_URL'; // Replace with your actual API base URL

  Future<List<Chef>> searchByAvailability(
    BuildContext context,
    String startDate,
    String endDate,
  ) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      final response = await http.get(
        Uri.parse(
            '$uri/api/searchByAvailability?startDate=$startDate&endDate=$endDate'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': user.token,
        },
      );
      print(
          "$uri/api/searchByAvailability?startDate=$startDate&endDate=$endDate");

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> data = json.decode(response.body);

        return data.map((chef) => Chef.fromJson(chef)).toList();
      } else {
        print(response.body);
        throw Exception('Failed to search chefs: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error searching chefs: $e');
    }
  }
}
