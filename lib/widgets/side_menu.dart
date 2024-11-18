import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:weather_dashboard/inner_screens/history_screens.dart';
import 'package:weather_dashboard/inner_screens/subcribse_notification_screens.dart';
import 'package:weather_dashboard/screens/dashboard_screen.dart';
import 'package:weather_dashboard/widgets/text_widget.dart';

import '../providers/dark_theme_provider.dart';
import '../providers/weather_provider.dart';
import '../services/utils.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final TextEditingController _locationSearch = TextEditingController();

  Future<void> requestPermission() async {
    const permission = Permission.location;

    if (await permission.isDenied) {
      await permission.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final themeState = Provider.of<DarkThemeProvider>(context);
    return Drawer(
      backgroundColor: theme ? Colors.black : Colors.white,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset(
              "images/Weather_icon.png",
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _locationSearch,
                  decoration: const InputDecoration(
                    hintText: 'E.g., New York, London, Tokyo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      String locationName = _locationSearch.text.trim();
                      if (locationName.isNotEmpty) {
                        Provider.of<WeatherProvider>(context, listen: false)
                            .fetchWeatherData(locationName, 4);
                        Navigator.of(context).pop();
                      }
                      // Add your search action here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    child: const Text(
                      'Search',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "or",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () async {
                      Provider.of<WeatherProvider>(context, listen: false)
                          .fetchCurrentWeather(4);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.grey, // Set background color to blue
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Use Current Location',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DrawerListTile(
            title: "Main",
            press: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
              );
            },
            icon: Icons.home_filled,
          ),
          DrawerListTile(
            title: "History",
            press: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HistoryScreen()));
            },
            icon: Icons.history,
          ),
          DrawerListTile(
            title: "Subscribe to Notifications",
            press: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const EmailSubscriptionScreen(),
                ),
              );
            },
            icon: Icons.notification_add,
          ),
          SwitchListTile(
              title: Text(
                'Theme',
                style: TextStyle(
                  color: theme ? Colors.white : Colors.black,
                ),
              ),
              secondary: Icon(
                themeState.getDarkTheme
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
                color: theme ? Colors.white : Colors.black,
              ),
              value: theme,
              onChanged: (value) {
                setState(() {
                  themeState.setDarkTheme = value;
                });
              })
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.press,
    required this.icon,
  });

  final String title;
  final VoidCallback press;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    return ListTile(
        onTap: press,
        horizontalTitleGap: 0.0,
        leading: Icon(
          icon,
          size: 18,
          color: theme ? Colors.white : Colors.black,
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: TextWidget(
            text: title,
            color: theme ? Colors.white : Colors.black,
          ),
        ));
  }
}
