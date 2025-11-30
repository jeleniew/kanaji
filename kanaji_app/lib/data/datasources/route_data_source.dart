import 'package:kanaji/domain/entities/app_route.dart';

class RouteDataSource {
  final List<AppRoute> _routes = [
    AppRoute(name: 'Tracing', path: '/tracing_configuration'),
    AppRoute(name: 'Flashcards', path: '/flashcards'),
    AppRoute(name: 'Memory Practice', path: '/memory_practice'),
  ];

  List<AppRoute> getRoutes() => _routes;
}