import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:weather_dashboard/consts/constants.dart';

import '../models/forecast_model.dart';
import '../models/history_forecast_model.dart';

class WeatherProvider extends ChangeNotifier {
  String cityName = "Ha Noi";
  String temperature = "";
  String wind = "";
  String humidity = "";
  String status = "";
  String time = "";
  String iconUrl = "";
  DateTime date = DateTime.now();

  List<ForecastDay> forecastDays = [];
  List<HistoryModel> historyDays = [];

  Future<String> getCityFromCoordinates(
      double latitude, double longitude) async {
    try {
      // Perform reverse geocoding to get the address from coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        // Get the city from the list of placemarks
        Placemark placemark = placemarks.first;
        return placemark.locality ?? 'Da Nang';
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
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> fetchWeatherDataFromUrl(String url, int? day) async {
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
        date = dateTime;
        time =
            "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";

        // Fetch forecast data
        forecastDays = await fetchWeatherForecast(cityName, day!);
        historyDays = await fetchHistoryWeather(cityName, dateTime);
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
  Future<void> fetchCurrentWeather(int day) async {
    Position position = await _getCurrentPosition();
    String? city =
        await getCityFromCoordinates(position.latitude, position.longitude);
    final urlCurrentWeather =
        'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&aqi=no';
    if (kDebugMode) {
      print("Get urlCurrentWeather From: $urlCurrentWeather");
    }
    await fetchWeatherDataFromUrl(urlCurrentWeather, day);
  }

// Fetch weather data for a given city
  Future<void> fetchWeatherData(String city, int day) async {
    final urlWeatherData =
        'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city';
    if (kDebugMode) {
      print("Get urlWeatherData From: $urlWeatherData");
    }
    await fetchWeatherDataFromUrl(urlWeatherData, day);
  }

  Future<List<ForecastDay>> fetchWeatherForecast(String city, int days) async {
    final urlForecastWeather =
        "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=$days&aqi=no&alerts=no";
    if (kDebugMode) {
      print("Get urlForecastWeather From: $urlForecastWeather");
    }

    try {
      final response = await http.get(Uri.parse(urlForecastWeather));
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

  Future<List<HistoryModel>> fetchHistoryWeather(
      String city, DateTime date) async {
    final urlHistory =
        "http://api.weatherapi.com/v1/history.json?key=$apiKey&q=$city&dt=${date.toIso8601String().split('T').first}";
    if (kDebugMode) {
      print("Get urlHistory From: $urlHistory");
    }

    try {
      final response = await http.get(Uri.parse(urlHistory));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        final List<dynamic> daysList =
            data['forecast']['forecastday'][0]['hour'];
        List<HistoryModel> historyModels =
            daysList.map((hour) => HistoryModel.fromJson(hour)).toList();
        //historyDays = historyModels;
        return historyModels;
      } else {
        throw Exception("Failed to load historical weather data");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception("Error fetching historical weather data");
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

  Future<void> saveDataToCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    String id = await getDeviceID();
    await prefs.setString("device_id", id);
    if (kDebugMode) {
      print("Current user ID is: $id");
    }
  }

  Future<String> getDeviceID() async {
    final DeviceInfoPlugin deviceID = DeviceInfoPlugin();
    String? id;
    if (defaultTargetPlatform == TargetPlatform.android) {
      final AndroidDeviceInfo androidID = await deviceID.androidInfo;
      id = androidID.id;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final IosDeviceInfo iosID = await deviceID.iosInfo;
      id = iosID.identifierForVendor ?? "";
    } else {
      var uuid = const Uuid();
      id = uuid.v4();
    }
    return id;
  }

/*  Future<void> saveWeatherDataToDatabase(String cityName, String temperature,
      String wind, String humidity, String status, String iconUrl) async {
    try {
      final deviceId = await getDeviceID();
      final database = FirebaseFirestore.instance;

      final historyWeatherDatabase =
          database.collection("weatherHistoryData").doc(deviceId);
      await historyWeatherDatabase.set({
        "city": cityName,
        "temperature": temperature,
        "wind": wind,
        "humidity": humidity,
        "status": status,
        "iconUrl": iconUrl,
      });

      if (kDebugMode) {
        print("Save weather data to History Successfully");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error when saving data to FireStore: $e");
      }
    }
  }*/
}
