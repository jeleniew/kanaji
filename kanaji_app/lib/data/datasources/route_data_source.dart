import 'package:kanaji/domain/entities/app_route.dart';

class RouteDataSource {
  final Map<AppRoute, String> _routes = {
    AppRoute.tracing: '/tracing',
    AppRoute.flashcards: '/flashcards',
    AppRoute.memoryPractice: '/memory_practice',
  };

  Map<AppRoute, String> getRoutes() => _routes;
}