import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_dashboard/widgets/main_weather_widget.dart';
import 'package:weather_dashboard/widgets/text_widget.dart';

import '../consts/constants.dart';
import '../controllers/MenuController.dart';
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
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
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
            //TextWidget(text: "Latest Product", color: color),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: MainWeatherWidget(),
            ),
            const SizedBox(height: defaultPadding),
            TextWidget(
              text: '4-Day Forecast',
              color: Colors.black,
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
                          city: "Ho Chi Minh",
                        ),
                        desktop: WeatherGrid(
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.08,
                          city: "Ho Chi Minh",
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ButtonsWidget(
                        onPressed: () {},
                        text: "More",
                        icon: Icons.add,
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
