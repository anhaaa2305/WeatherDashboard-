import 'package:flutter/material.dart';
import 'package:weather_dashboard/widgets/text_widget.dart';

class ForecastBox extends StatelessWidget {
  final String date;
  final String temp;
  final String wind;
  final String humidity;
  final String icon;
  const ForecastBox({
    super.key,
    required this.date,
    required this.temp,
    required this.wind,
    required this.humidity,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          TextWidget(
            text: date,
            color: Colors.white,
            isTitle: true,
          ),
          const SizedBox(height: 16),
          Image.network(icon), // Replace with relevant icon for each day
          const SizedBox(height: 8),
          TextWidget(text: 'Temp: $temp', color: Colors.white),
          TextWidget(text: 'Wind: $wind', color: Colors.white),
          TextWidget(text: 'Humidity: $humidity', color: Colors.white),
        ],
      ),
    );
  }
}
