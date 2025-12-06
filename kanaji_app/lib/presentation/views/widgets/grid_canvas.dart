// grid_canvas.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GridCanvas extends StatelessWidget {
  final String character;
  final Future<String>? svgData;

  const GridCanvas({
    super.key,
    required this.character,
    this.svgData,
  });

  static const gridLineColor = Color(0xFF424242);
  static const gridBackgroundColor = Color(0xFFFFDDE9);
  static const hintTextColor = Color.fromARGB(255, 158, 158, 158);
  static const fontSizeFactor = 0.8;

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
                  child: svgData != null
                    ? FutureBuilder<String>(
                      future: svgData!,
                      builder:(context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox.shrink();
                        }
                        return SvgPicture.string(
                          snapshot.data!,
                          width: size * fontSizeFactor,
                          height: size * fontSizeFactor,
                          colorFilter: const ColorFilter.mode(
                            hintTextColor,
                            BlendMode.srcIn,
                          ),
                        );
                      },
                    )
                    : const SizedBox.shrink(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}