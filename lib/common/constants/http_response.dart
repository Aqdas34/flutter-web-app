import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:only_shef/widgets/snack_bar_util.dart';

void httpErrorHandling({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showError(context, jsonDecode(response.body)['message']);
      break;
    case 500:
      showError(context, jsonDecode(response.body)['error']);
      break;
    default:
      final decodedBody = jsonDecode(response.body);
      showError(
          context,
          decodedBody is Map
              ? decodedBody['message'] ??
                  decodedBody['error'] ??
                  'An error occurred'
              : decodedBody.toString());
  }
}
