import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/app_route.dart';
import 'package:kanaji/domain/repositories/i_route_repository.dart';

class AppDrawerViewModel extends ChangeNotifier {
  final IRouteRepository _routeRepository;

  AppDrawerViewModel({required IRouteRepository routeRepository})
      : _routeRepository = routeRepository;

  List<AppRoute> get routes => _routeRepository.getAllRoutes();

  void navigateTo(AppRoute appRoute, BuildContext context) {
    Navigator.of(context).pushNamed(appRoute.path);
  }
}