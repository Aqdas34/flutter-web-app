import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:only_shef/common/constants/global_variable.dart';
import 'package:only_shef/common/constants/http_response.dart';
import 'package:only_shef/pages/chef_appointments/models/appointment.dart';
import 'package:provider/provider.dart';
import 'package:only_shef/provider/user_provider.dart';

class ChefAppointmentService {
  Future<AppointmentResponse> getChefAppointments(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
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
      stats: {},
    );

    try {
      final response = await http.get(
        Uri.parse('$uri/api/chefAppointments'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': user.token,
        },
      );
      print(response.statusCode);
      print(response.body);

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {
          final List<dynamic> data = jsonDecode(response.body);
          final List<Appointment> appointments = data
              .map((appointment) => Appointment.fromJson(appointment))
              .toList();

          // Group appointments by status
          final Map<String, List<Appointment>> grouped = {
            'pending': appointments
                .where((a) => a.status.toLowerCase() == 'pending')
                .toList(),
            'accepted': appointments
                .where((a) => a.status.toLowerCase() == 'accepted')
                .toList(),
            'completed': appointments
                .where((a) => a.status.toLowerCase() == 'completed')
                .toList(),
            'cancelled': appointments
                .where((a) => a.status.toLowerCase() == 'cancelled')
                .toList(),
            'rejected': appointments
                .where((a) => a.status.toLowerCase() == 'rejected')
                .toList(),
          };

          // Calculate stats
          final Map<String, int> stats = {
            'pending': grouped['pending']!.length,
            'accepted': grouped['accepted']!.length,
            'completed': grouped['completed']!.length,
            'cancelled': grouped['cancelled']!.length,
            'rejected': grouped['rejected']!.length,
          };

          appointmentResponse = AppointmentResponse(
            appointments: appointments,
            grouped: grouped,
            total: appointments.length,
            stats: stats,
          );
        },
      );
      return appointmentResponse;
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching appointments: $error')),
      );
      return appointmentResponse;
    }
  }

  Future<bool> updateAppointmentStatus(
    BuildContext context,
    String appointmentId,
    String status,
  ) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    bool success = false;

    try {
      final response = await http.post(
        Uri.parse('$uri/api/updateAppointmentStatus'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': user.token,
        },
        body: json.encode({
          'appointmentId': appointmentId,
          'status': status,
        }),
      );

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {
          final Map<String, dynamic> data = jsonDecode(response.body);
          success = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(data['message'] ??
                    'Appointment status updated successfully')),
          );
        },
      );
      return success;
    } catch (error) {
      print('Error updating appointment status: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating appointment status: $error')),
      );
      return false;
    }
  }
}
