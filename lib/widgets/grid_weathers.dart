import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../consts/constants.dart';
import '../providers/weather_provider.dart';
import 'forecast_widget.dart';

class WeatherGrid extends StatelessWidget {
  const WeatherGrid(
      {super.key,
      required this.city,
      this.crossAxisCount = 4,
      this.childAspectRatio = 1,
      this.isInMain = true});

  final int crossAxisCount;
  final double childAspectRatio;
  final bool isInMain;
  final String city;

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return weatherProvider.forecastDays.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: isInMain && weatherProvider.forecastDays.length > 4
                ? 4
                : weatherProvider.forecastDays.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: defaultPadding,
              mainAxisSpacing: defaultPadding,
            ),
            itemBuilder: (context, index) {
              final forecast = weatherProvider.forecastDays[index];
              return ForecastBox(
                date: forecast.date,
                temp: forecast.temperature,
                wind: forecast.wind,
                humidity: forecast.humidity,
                icon: forecast.iconUrl,
              );
            },
          );
  }
}
