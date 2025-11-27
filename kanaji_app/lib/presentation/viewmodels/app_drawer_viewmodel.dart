import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/app_route.dart';
import 'package:kanaji/domain/repositories/i_route_repository.dart';

class AppDrawerViewModel extends ChangeNotifier {
  final IRouteRepository _routeRepository;

  AppDrawerViewModel({required IRouteRepository routeRepository})
      : _routeRepository = routeRepository;

  String getRoute(AppRoute key) => _routeRepository.getRoute(key);

  Map<AppRoute, String> get routes => _routeRepository.getAllRoutes();

  void navigateTo(AppRoute routeName, BuildContext context) {
    final route = getRoute(routeName);
    Navigator.of(context).pushNamed(route);
  }
}