import 'package:kanaji/data/datasources/route_data_source.dart';
import 'package:kanaji/domain/entities/app_route.dart';
import 'package:kanaji/domain/repositories/i_route_repository.dart';

class RouteRepository implements IRouteRepository {
  final List<AppRoute> _routes = RouteDataSource().getRoutes();
  
  @override
  List<AppRoute> getAllRoutes() {
    return _routes;
  }
}