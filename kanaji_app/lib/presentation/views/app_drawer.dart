// app_drawer.dart
import 'package:flutter/material.dart';
import 'package:kanaji/presentation/viewmodels/app_drawer_viewmodel.dart';
import 'package:provider/provider.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AppDrawerViewModel>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
            child: const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/classroom.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Text('Kanaji'),
            ),
          ),
          ...vm.routes.map((appRoute) {
            return ListTile(
              title: Text(appRoute.name),
              onTap: () {
                Navigator.pushNamed(context, appRoute.path);
              },
            );
          }),
        ],
      ),
    );
  }
}