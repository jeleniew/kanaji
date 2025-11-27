// flashcard_view.dart
import 'package:flutter/material.dart';

class FlashcardView extends StatelessWidget {
  final String text;
  final GestureTapCallback? onTap;
  final GestureDragEndCallback? onHorizontalDragEnd;

  static const int stackCount = 2;
  static const Color backgroundStackColor = Color(0xFFE0E0E0);
  static const Color backgroundMainColor = Colors.white;
  static const Color borderColor = Colors.black;
  static const double borderWidth = 1.0;
  static const double borderRadius = 4.0;
  static const double offsetFactor = 0.03;

  const FlashcardView({
    super.key,
    required this.text,
    required this.onTap,
    required this.onHorizontalDragEnd,
  });

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        final double offset = offsetFactor * constraints.maxHeight;
        final mainCardSize = constraints.maxHeight - offset * stackCount;
        final mainCardOffset = offset * stackCount;

        return GestureDetector(
          onTap: onTap,
          onHorizontalDragEnd: onHorizontalDragEnd,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              ..._buildStackedCards(offset, mainCardSize),
              _buildMainCard(mainCardOffset, mainCardSize, text),
            ],
          ),
        );
      }
    );
  }

  TextStyle _textStyle(double fontSize) {
    return TextStyle(
      fontSize: fontSize,
      height: 0.5,
    );
  }

  List<Widget> _buildStackedCards(double offset, double mainCardSize) {
    return List.generate(stackCount, (index) {
      final layerIndex = stackCount - index;
      final cardOffset = offset * index;
      final cardSize = mainCardSize - offset * layerIndex;

      return _card(
        offset: cardOffset,
        cardSize: cardSize,
        backgroundColor: backgroundStackColor,
      );
    });
  }

  Widget _buildMainCard(double offset, double mainCardSize, String text) {
    return _card(
      offset: offset,
      cardSize: mainCardSize,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fontSize = constraints.maxHeight * 0.8;
          return Text(
            text,
            textAlign: TextAlign.center,
            style: _textStyle(fontSize),
          );
        },
      ),
    );
  }

  Widget _card({
    required double offset,
    required double cardSize,
    Widget? child,
    Color? backgroundColor,
  }) {
    return Positioned(
      top: offset,
      child: Container(
        width: cardSize,
        height: cardSize,
        decoration: BoxDecoration(
          color: backgroundColor ?? backgroundMainColor,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}