import 'package:kanaji/data/datasources/route_data_source.dart';
import 'package:kanaji/domain/entities/app_route.dart';
import 'package:kanaji/domain/repositories/i_route_repository.dart';

class RouteRepository implements IRouteRepository {
  final Map<AppRoute, String> _routes = RouteDataSource().getRoutes();

  @override
  String getRoute(AppRoute key) => _routes[key] ?? '/';
  
  @override
  Map<AppRoute, String> getAllRoutes() {
    return _routes;
  }
}