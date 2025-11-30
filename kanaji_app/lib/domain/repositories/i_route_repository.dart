// i_route_repository.dart

import 'package:kanaji/domain/entities/app_route.dart';

abstract class IRouteRepository {
  List<AppRoute> getAllRoutes();
}