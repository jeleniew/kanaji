import 'package:flutter/material.dart';
import 'paper_decorator.dart';
import 'finger_pen.dart';

class Paper extends StatefulWidget {
  final bool showGrid;
  final bool showSymbol;
  final String? backgroundSymbol;

  const Paper({
    super.key,
    this.showGrid = true,
    this.showSymbol = false,
    this.backgroundSymbol,
  });

  @override
  PaperState createState() => PaperState();
}

class PaperState extends State<Paper> {
  List<Offset?> points = [];
  String? backgroundSymbol;
  bool _useStrokeOrderFont = false;

  @override
  void initState() {
    super.initState();
    backgroundSymbol = widget.backgroundSymbol;
  }

  void changeBackgroundSymbol(String? newSymbol) {
    setState(() {
      backgroundSymbol = newSymbol;
    });
  }

  void toggleFont() {
    setState(() {
      _useStrokeOrderFont = !_useStrokeOrderFont;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          points.add(details.localPosition);
        });
      },
      onPanEnd: (details) => {
        setState(() {
          points.add(null);
        })
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromARGB(255, 255, 221, 233),
        child: Stack(
          children:[
            CustomPaint(
              size: Size.infinite,
              painter: PaperDecorator(
                showGrid: widget.showGrid,
                showSymbol: widget.showSymbol,
                backgroundSymbol: backgroundSymbol,
                useStrokeOrderFont: _useStrokeOrderFont,
              ),
            ),
            CustomPaint(
              painter: FingerPen(points),
            ),
          ]
        )
      )
    );
  }

  void clear() {
    setState(() {
      points.clear();
    });
  }
}
