import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:only_shef/common/constants/global_variable.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../common/constants/http_response.dart';
import '../../../provider/user_provider.dart';

class SendOfferServices {
  Future<bool> bookChef({
    required BuildContext context,
    required String chefId,
    required String date,
    required String time,
    required List<String> selectedCuisines,
    required int numberOfPersons,
    required double price,
    String? comments,
  }) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    try {
      print('Sending offer to: $uri/api/bookChef');
      final response = await http.post(
        Uri.parse('$uri/api/bookChef'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': user.token,
        },
        body: jsonEncode({
          'chefId': chefId,
          'date': date,
          'time': time,
          'selectedCuisines': selectedCuisines,
          'numberOfPersons': numberOfPersons,
          'price': price,
          'comments': comments,
        }),
      );
      print('object');
      print('Response: ${response.body}');

      bool success = false;
      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {
          success = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking Offer sent successfully!')),
          );
        },
      );
      return success;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error booking chef')),
      );
      return false;
    }
  }
}
