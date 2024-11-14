import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/forecast_model.dart';

class WeatherProvider extends ChangeNotifier {
  String cityName = "Ho Chi Minh";
  String temperature = "";
  String wind = "";
  String humidity = "";
  String status = "";
  String time = "";
  String iconUrl = "";
  String date = "";
  final String apiKey = "d5fb044807804190b0d174225241211";
  List<ForecastDay> forecastDays = [];

  Future<String> getCityFromCoordinates(
      double latitude, double longitude) async {
    try {
      // Perform reverse geocoding to get the address from coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        // Get the city from the list of placemarks
        Placemark placemark = placemarks.first;
        return placemark.locality ?? 'Unknown city'; // Return the city name
      } else {
        return 'City not found';
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      return 'Error retrieving city';
    }
  }

  Future<Position> _getCurrentPosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are denied");
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> fetchWeatherDataFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Parse and set weather data
        cityName = data['location']['name'];
        temperature = '${data['current']['temp_c']}°C';
        wind = '${data['current']['wind_kph']} km/h';
        humidity = '${data['current']['humidity']}%';
        status = data['current']['condition']['text'];
        iconUrl = data['current']['condition']['icon'];
        DateTime dateTime = DateTime.parse(data['location']['localtime']);
        time =
            "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";

        if (kDebugMode) {
          print("City name: $cityName");
        }
        // Fetch forecast data
        forecastDays = await fetchWeatherForecast(cityName, 4);
        notifyListeners();
      } else {
        if (kDebugMode) {
          print('Failed to load weather data');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

// Fetch current weather using current location
  Future<void> fetchCurrentWeather() async {
    Position position = await _getCurrentPosition();
    String? city =
        await getCityFromCoordinates(position.latitude, position.longitude);
    final url =
        'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&aqi=no';
    if (kDebugMode) {
      print("Get URL From: $url");
    }
    await fetchWeatherDataFromUrl(url);
  }

// Fetch weather data for a given city
  Future<void> fetchWeatherData(String city) async {
    final url = 'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city';
    if (kDebugMode) {
      print("Get URL From: $url");
    }
    await fetchWeatherDataFromUrl(url);
  }

  Future<List<ForecastDay>> fetchWeatherForecast(String city, int days) async {
    final url =
        "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=$days&aqi=no&alerts=no";
    if (kDebugMode) {
      print("Get URL From: $url");
    }

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        List<dynamic> daysList = data['forecast']['forecastday'];
        List<ForecastDay> forecastDays =
            daysList.map((d) => ForecastDay.fromJson(d)).toList();
        return forecastDays;
      } else {
        throw Exception("Failed to load weather data");
      }
    } catch (e) {
      throw Exception("Failed to load weather data");
    }
  }

  Future<List<ForecastDay>> fetchHistoryWeather(
      String city, DateTime date) async {
    final url =
        "http://api.weatherapi.com/v1/history.json?key=$apiKey&q=$city&dt=${date.toIso8601String().split('T').first}";
    if (kDebugMode) {
      print("Get URL From: $url");
    }

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> daysList = data['forecast']['forecastday'];
        List<ForecastDay> historyDays =
            daysList.map((d) => ForecastDay.fromJson(d)).toList();
        return historyDays;
      } else {
        throw Exception("Failed to load weather data");
      }
    } catch (e) {
      throw Exception("Failed to load weather data");
    }
  }

  Future<void> sendEmailVerificationLink() async {
    final auth = FirebaseAuth.instance;
    try {
      await auth.currentUser?.sendEmailVerification();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
