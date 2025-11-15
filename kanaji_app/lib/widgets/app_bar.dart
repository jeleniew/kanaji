// app_bar.py
import 'package:flutter/material.dart';


AppBar appBar() {
  return AppBar(
    title: Text('Japanese writing'),
    leading: Builder(
      builder: (context) {
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      },
      // Kod do obsługi kliknięcia w lewą ikonę
    ),
    // actions: [
    //   _buildAppBarIcon(() {
    //     // Kod do obsługi kliknięcia w prawą ikonę
    //   }),
    // ],
  );
}