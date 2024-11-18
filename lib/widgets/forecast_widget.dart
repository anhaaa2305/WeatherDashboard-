import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weather_dashboard/widgets/text_widget.dart';

class ForecastBox extends StatelessWidget {
  final String date;
  final String temp;
  final String wind;
  final String humidity;
  final String image;

  const ForecastBox({
    super.key,
    required this.date,
    required this.temp,
    required this.wind,
    required this.humidity,
    required this.image,
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
          const SizedBox(height: 2),
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.width * 0.1,
            imageUrl: image,
            // Replace with your image URL
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(height: 8),
          TextWidget(text: 'Temp: $temp', color: Colors.white),
          TextWidget(text: 'Wind: $wind', color: Colors.white),
          TextWidget(text: 'Humidity: $humidity', color: Colors.white),
        ],
      ),
    );
  }
}
