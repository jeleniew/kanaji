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
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/classroom.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Text('Drawer Header'),
          ),
          ...vm.routes.entries.map((entry) {
            return ListTile(
              title: Text(entry.key.toString()),
              onTap: () {
                Navigator.pushNamed(context, entry.value);
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}