import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../consts/constants.dart';
import '../providers/weather_provider.dart';
import 'forecast_widget.dart';

class HistoryGridWeathers extends StatefulWidget {
  const HistoryGridWeathers(
      {super.key,
      this.crossAxisCount = 4,
      this.childAspectRatio = 1,
      this.isInMain = true,
      required this.city,
      required this.dateTime});

  final int crossAxisCount;
  final double childAspectRatio;
  final bool isInMain;
  final String city;
  final DateTime dateTime;

  @override
  State<HistoryGridWeathers> createState() => _HistoryGridWeathersState();
}

class _HistoryGridWeathersState extends State<HistoryGridWeathers> {
  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return weatherProvider.historyDays.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: weatherProvider.historyDays.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              childAspectRatio: widget.childAspectRatio,
              crossAxisSpacing: defaultPadding,
              mainAxisSpacing: defaultPadding,
            ),
            itemBuilder: (context, index) {
              final historyDay = weatherProvider.historyDays[index];
              DateTime castToDateTime = DateTime.parse(historyDay.time);
              String formatTime = DateFormat('HH:mm').format(castToDateTime);
              return ForecastBox(
                date: formatTime,
                temp: historyDay.temperature,
                wind: historyDay.wind,
                humidity: historyDay.humidity,
                image: "https:${historyDay.iconUrl}",
              );
            },
          );
  }
}
