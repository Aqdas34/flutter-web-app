import 'package:only_shef/pages/cuisine/models/chef.dart';

class Appointment {
  final String id;
  final String chefId;
  final Chef chefInfo;
  final Map<String, dynamic> userId;
  final DateTime date;
  final String time;
  final List<String> selectedCuisines;
  final int numberOfPersons;
  final double price;
  final String comments;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Appointment({
    required this.id,
    required this.chefId,
    required this.chefInfo,
    required this.userId,
    required this.date,
    required this.time,
    required this.selectedCuisines,
    required this.numberOfPersons,
    required this.price,
    required this.comments,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['_id'] ?? '',
      chefId: json['chefId'] ?? '',
      chefInfo: Chef.fromJson(json['chefInfo'] ?? {}),
      userId: json['userId'] ?? {},
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      time: json['time'] ?? '',
      selectedCuisines: List<String>.from(json['selectedCuisines'] ?? []),
      numberOfPersons: json['numberOfPersons'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      comments: json['comments'] ?? '',
      status: json['status'] ?? '',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class AppointmentResponse {
  final List<Appointment> appointments;
  final Map<String, List<Appointment>> grouped;
  final int total;
  final Map<String, int> stats;

  AppointmentResponse({
    required this.appointments,
    required this.grouped,
    required this.total,
    required this.stats,
  });

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentResponse(
      appointments: (json['appointments'] as List)
          .map((appointment) => Appointment.fromJson(appointment))
          .toList(),
      grouped: {
        'pending': (json['grouped']['pending'] as List)
            .map((appointment) => Appointment.fromJson(appointment))
            .toList(),
        'accepted': (json['grouped']['accepted'] as List)
            .map((appointment) => Appointment.fromJson(appointment))
            .toList(),
        'completed': (json['grouped']['completed'] as List)
            .map((appointment) => Appointment.fromJson(appointment))
            .toList(),
        'cancelled': (json['grouped']['cancelled'] as List)
            .map((appointment) => Appointment.fromJson(appointment))
            .toList(),
        'rejected': (json['grouped']['rejected'] as List)
            .map((appointment) => Appointment.fromJson(appointment))
            .toList(),
      },
      total: json['total'] ?? 0,
      stats: Map<String, int>.from(json['stats'] ?? {}),
    );
  }
}
