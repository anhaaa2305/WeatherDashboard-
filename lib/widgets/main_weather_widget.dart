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
        .fetchWeatherData('Ho Chi Minh');
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return Row(
      children: [
        Expanded(
          child: Container(
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
                  children: [
                    weatherProvider.iconUrl != ""
                        ? Image.network(weatherProvider.iconUrl)
                        : Image.network(
                            "https://www.stellarphotorecoverysoftware.com/blog/wp-content/uploads/2015/10/error-803716_1280.png"),
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
