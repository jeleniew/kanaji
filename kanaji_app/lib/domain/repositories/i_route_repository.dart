// i_route_repository.dart

import 'package:kanaji/domain/entities/app_route.dart';

abstract class IRouteRepository {
  String getRoute(AppRoute key);
  Map<AppRoute, String> getAllRoutes();
}