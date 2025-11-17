// app_drawer.dart
import 'package:flutter/material.dart';


Drawer appDrawer(BuildContext context) {
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
          ListTile(
            title: const Text('Hiragana'),
            onTap: () {
              Navigator.of(context).pushNamed('/tracing');
            },
          ),
          ListTile(
            title: const Text('Flashcards'),
            onTap: () {
              Navigator.of(context).pushNamed('/flashcards');
            },
          ),
          ListTile(
            title: const Text('Memory practice'),
            onTap: () {
              Navigator.of(context).pushNamed('/memory_practice');
            },
          ),
        ],
      ),
    );
  }