// grid_canvas.dart
import 'package:flutter/material.dart';

class GridCanvas extends StatelessWidget {
  final String character;
  final String? font;

  // TODO: check if super is needed
  const GridCanvas({Key? key, required this.character, this.font}) : super(key: key);
  static const gridLineColor = Color(0xFF424242);
  static const gridBackgroundColor = Color(0xFFFFDDE9);
  static const hintTextColor = Color.fromARGB(255, 158, 158, 158);
  static const fontSizeFactor = 0.8;

  TextStyle _textStyle(double fontSize) {
    print(font);
    return TextStyle(
      fontFamily: font,
      fontSize: fontSize,
      height: 0.5,
      color: hintTextColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            // TODO: fix for horizontal orientation
            final size = constraints.biggest.shortestSide;

            return SizedBox(
              width: size,
              height: size,
              child: GridPaper(
                interval: size / 4,
                divisions: 1,
                subdivisions: 1,
                color: gridLineColor,
                child: Container(
                  color: gridBackgroundColor,
                  alignment: Alignment.center,
                  child: Text(
                    character,
                    style: _textStyle(size * fontSizeFactor),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}