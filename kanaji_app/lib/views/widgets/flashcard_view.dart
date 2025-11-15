// flashcard_view.dart
import 'package:flutter/material.dart';

class FlashcardView extends StatelessWidget {
  final String text;
  final GestureTapCallback? onTap;
  final GestureDragEndCallback? onHorizontalDragEnd;

  const FlashcardView({
    super.key,
    required this.text,
    required this.onTap,
    required this.onHorizontalDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    const int stackCount = 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double offset = 0.05 * constraints.maxHeight;
        final mainCardSize = constraints.maxHeight - offset * stackCount;

        return GestureDetector(
          onTap: onTap,
          onHorizontalDragEnd: onHorizontalDragEnd,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              for (int i = stackCount; i > 0; i--)
                Positioned(
                  top: offset * (stackCount - i),
                  child: Container(
                    width: mainCardSize - offset * i,
                    height: mainCardSize - offset * i,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              Positioned(
                top: offset * stackCount,
                child: Container(
                  width: mainCardSize,
                  height: mainCardSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final fontSize = constraints.maxHeight * 0.8;
                      return Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize,
                          height: 0.5
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}