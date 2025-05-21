import 'package:dio/dio.dart';

class ApiService {
  // static const String baseUrl = "http://localhost:5000/api/auth";
  static const String baseUrl = "http://192.168.211.79:5000/api/auth";
  final Dio _dio = Dio();

  // Register User
  Future<Response?> registerUser(
      String name, String email, String password) async {
    try {
      print("$baseUrl/register");
      Response response = await _dio.post("$baseUrl/register", data: {
        "name": name,
        "email": email,
        "password": password,
      });
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Login User
  Future<Response?> loginUser(String email, String password) async {
    try {
      Response response = await _dio.post("$baseUrl/login", data: {
        "email": email,
        "password": password,
      });
      return response;
    } catch (e) {
      return null;
    }
  }

  // Switch to Chef
  Future<Response?> switchToChef(String userId,
      {String? cnic,
      String? certificate,
      List<String>? days,
      String? time,
      String? availabilityType}) async {
    try {
      Response response =
          await _dio.post("$baseUrl/switch-to-chef/$userId", data: {
        "cnic": cnic,
        "cookingCertificate": certificate,
        "availableDays": days,
        "availableTime": time,
        "availabilityType": availabilityType,
      });
      return response;
    } catch (e) {
      return null;
    }
  }

  // Switch to User (Customer)
  Future<Response?> switchToUser(String userId) async {
    try {
      Response response =
          await _dio.post("$baseUrl/switch-to-customer/$userId");
      return response;
    } catch (e) {
      return null;
    }
  }

  // Submit Rating for Chef
  Future<Response?> submitRating(
      String chefId, String customerId, int rating, String review) async {
    try {
      Response response = await _dio.post("$baseUrl/rate-chef/$chefId", data: {
        "customerId": customerId,
        "rating": rating,
        "review": review,
      });
      return response;
    } catch (e) {
      return null;
    }
  }
}
