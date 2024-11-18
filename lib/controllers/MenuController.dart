import 'package:flutter/material.dart';

class CustomMenuController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _gridScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _weatherScaffoldKey =
      GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _dashboardScaffoldKey =
      GlobalKey<ScaffoldState>();
  // Getters
  GlobalKey<ScaffoldState> get getScaffoldKey => _scaffoldKey;
  GlobalKey<ScaffoldState> get getgridscaffoldKey => _gridScaffoldKey;
  GlobalKey<ScaffoldState> get getWeatherScaffoldKey => _weatherScaffoldKey;
  GlobalKey<ScaffoldState> get getDashboardScaffoldKey => _dashboardScaffoldKey;
  // Callbacks
  void controlDashboarkMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  void controlHistoryMenu() {
    if (!_gridScaffoldKey.currentState!.isDrawerOpen) {
      _gridScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlNotificationMenu() {
    if (!_weatherScaffoldKey.currentState!.isDrawerOpen) {
      _weatherScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlDashBoardWeather() {
    if (!_dashboardScaffoldKey.currentState!.isDrawerOpen) {
      _dashboardScaffoldKey.currentState!.openDrawer();
    }
  }
}
