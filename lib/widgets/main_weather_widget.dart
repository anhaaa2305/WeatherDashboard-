import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_dashboard/widgets/text_widget.dart';

import '../providers/weather_provider.dart';

class MainWeatherWidget extends StatefulWidget {
  const MainWeatherWidget({super.key});

  @override
  State<MainWeatherWidget> createState() => _MainWeatherWidgetState();
}

class _MainWeatherWidgetState extends State<MainWeatherWidget> {
  WeatherProvider? weatherProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<WeatherProvider>(context, listen: false)
        .fetchWeatherData('Ha Noi', 4);
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Row(
      children: [
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text:
                          "${weatherProvider.cityName} (${weatherProvider.time})",
                      color: Colors.white,
                      isTitle: true,
                    ),
                    const SizedBox(height: 8),
                    TextWidget(
                        text: 'Temperature: ${weatherProvider.temperature}',
                        color: Colors.white),
                    TextWidget(
                        text: 'Wind: ${weatherProvider.wind}',
                        color: Colors.white),
                    TextWidget(
                        text: 'Humidity: ${weatherProvider.humidity}',
                        color: Colors.white),
                  ],
                ),
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          "https:${weatherProvider.iconUrl}", // Replace with your image URL
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    const SizedBox(height: 8),
                    TextWidget(
                        text: weatherProvider.status, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
