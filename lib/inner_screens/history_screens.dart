import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_dashboard/models/history_forecast_model.dart';

import '../controllers/MenuController.dart';
import '../providers/weather_provider.dart';
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/header.dart';
import '../widgets/history_grid_weathers.dart';
import '../widgets/side_menu.dart';
import '../widgets/text_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime selectedDate =
      DateTime.now().subtract(const Duration(days: 1)); // Default to yesterday

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020), // Set your range for date picker
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return Scaffold(
      key: context.read<CustomMenuController>().getgridscaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(child: SideMenu()),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextWidget(
                        text:
                            "${weatherProvider.cityName} (${DateFormat('yyyy-MM-dd').format(weatherProvider.date)})",
                        color: color,
                        isTitle: true,
                      ),
                    ),
                    Header(
                      title: "Weather History",
                      fct: () {
                        context
                            .read<CustomMenuController>()
                            .controlHistoryMenu();
                      },
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text("Select Date: ${selectedDate.toLocal()}"
                          .split(' ')[0]),
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<List<HistoryModel>>(
                      future: weatherProvider.fetchHistoryWeather(
                          weatherProvider.cityName, selectedDate),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading historical data'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No historical data available'));
                        } else {
                          return Responsive(
                            mobile: HistoryGridWeathers(
                              crossAxisCount: size.width < 650 ? 2 : 4,
                              childAspectRatio:
                                  size.width < 650 && size.width > 350
                                      ? 1.1
                                      : 0.8,
                              isInMain: false,
                              city: weatherProvider.cityName,
                              dateTime: selectedDate,
                            ),
                            desktop: HistoryGridWeathers(
                              crossAxisCount: size.width < 650 ? 2 : 4,
                              childAspectRatio:
                                  size.width < 650 && size.width > 350
                                      ? 1.1
                                      : 0.8,
                              isInMain: false,
                              city: weatherProvider.cityName,
                              dateTime: selectedDate,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
