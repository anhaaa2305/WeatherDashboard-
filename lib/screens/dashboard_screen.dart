import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_dashboard/widgets/main_weather_widget.dart';
import 'package:weather_dashboard/widgets/text_widget.dart';

import '../consts/constants.dart';
import '../controllers/MenuController.dart';
import '../providers/weather_provider.dart';
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/buttons.dart';
import '../widgets/grid_weathers.dart';
import '../widgets/header.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int displayCount = 4; // Default display count

  void toggleDisplayCount(String cityName) {
    setState(() {
      // Toggle between 4 and 10 days
      displayCount = displayCount == 4 ? 10 : 4;
      Provider.of<WeatherProvider>(context, listen: false)
          .fetchWeatherData(cityName, displayCount);
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    Size size = Utils(context).getScreenSize;
    final color = Utils(context).color;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              title: "Weather Dashboard",
              fct: () {
                context.read<CustomMenuController>().controlDashboarkMenu();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(2.0),
              child: MainWeatherWidget(),
            ),
            const SizedBox(height: defaultPadding),
            TextWidget(
              text: '$displayCount-Day Forecast',
              color: color,
              isTitle: true,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  //flex: 5,
                  child: Column(
                    children: [
                      Responsive(
                        mobile: WeatherGrid(
                          crossAxisCount: size.width < 650 ? 2 : 4,
                          childAspectRatio:
                              size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                          city: "Ha Noi",
                          displayCount: displayCount,
                        ),
                        desktop: WeatherGrid(
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.08,
                          city: "Ha Noi",
                          displayCount: displayCount,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ButtonsWidget(
                        onPressed: () {
                          toggleDisplayCount(weatherProvider.cityName);
                        },
                        text: displayCount == 4
                            ? "More"
                            : "Less", // Update button text
                        icon: displayCount == 4 ? Icons.add : Icons.remove,
                        backgroundColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
