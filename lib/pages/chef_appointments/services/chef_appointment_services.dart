import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:only_shef/common/constants/show_snack_bar.dart';
import 'package:only_shef/pages/cuisine/models/chef.dart';
import 'package:only_shef/pages/chef_appointments/models/appointment.dart';
import 'package:provider/provider.dart';

import '../../../common/constants/global_variable.dart';
import '../../../common/constants/http_response.dart';
import '../../../provider/user_provider.dart';

class ChefAppointmentServices {
  Future<List<Chef>> getAvailableChefsByDate(
    BuildContext context,
    String date,
  ) async {
    List<Chef> chefList = [];

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/searchByDate?date=$date'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandling(
        response: res,
        // ignore: use_build_context_synchronously
        context: context,
        onSuccess: () {
          final List<dynamic> jsonData = jsonDecode(res.body);

          chefList = jsonData.map((json) => Chef.fromJson(json)).toList();
        },
      );
    } catch (e) {
      // ignore: use_build_context_synchronously

      showSnackBar(context, e.toString());
    }
    return chefList;
  }

  Future<AppointmentResponse> getAppointments(
    BuildContext context,
  ) async {
    AppointmentResponse appointmentResponse = AppointmentResponse(
      appointments: [],
      grouped: {
        'pending': [],
        'accepted': [],
        'completed': [],
        'cancelled': [],
        'rejected': [],
      },
      total: 0,
      stats: {
        'pending': 0,
        'accepted': 0,
        'completed': 0,
        'cancelled': 0,
        'rejected': 0,
      },
    );
    final user = Provider.of<UserProvider>(context, listen: false).user;

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/userappointments'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token,
        },
      );
      print(res.body);

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          final Map<String, dynamic> jsonData = jsonDecode(res.body);

          // Parse appointments list
          final List<dynamic> appointmentsJson = jsonData['appointments'] ?? [];
          final List<Appointment> appointments = appointmentsJson
              .map((json) => Appointment.fromJson(json))
              .toList();

          print(appointments[0].chefInfo.profileImage);

          // Parse grouped appointments
          final Map<String, List<Appointment>> grouped = {
            'pending': (jsonData['grouped']['pending'] as List? ?? [])
                .map((json) => Appointment.fromJson(json))
                .toList(),
            'accepted': (jsonData['grouped']['accepted'] as List? ?? [])
                .map((json) => Appointment.fromJson(json))
                .toList(),
            'completed': (jsonData['grouped']['completed'] as List? ?? [])
                .map((json) => Appointment.fromJson(json))
                .toList(),
            'cancelled': (jsonData['grouped']['cancelled'] as List? ?? [])
                .map((json) => Appointment.fromJson(json))
                .toList(),
            'rejected': (jsonData['grouped']['rejected'] as List? ?? [])
                .map((json) => Appointment.fromJson(json))
                .toList(),
          };

          // Parse stats
          final Map<String, int> stats =
              Map<String, int>.from(jsonData['stats'] ?? {});

          appointmentResponse = AppointmentResponse(
            appointments: appointments,
            grouped: grouped,
            total: jsonData['total'] ?? 0,
            stats: stats,
          );
          print(appointmentResponse.appointments[0].chefInfo.profileImage);
        },
      );
    } catch (e) {
      print(e);
      showSnackBar(context, e.toString());
    }
    return appointmentResponse;
  }
}
