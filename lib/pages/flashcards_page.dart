import 'package:flutter/material.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({super.key});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  final List<String> hiragana = ['あ', 'い', 'う', 'え', 'お'];
  final List<String> polish = ['a', 'i', 'u', 'e', 'o'];

  int currentIndex = 0;
  bool showingHiragana = true;

  void _nextFlashcard() {
    setState(() {
      currentIndex = (currentIndex + 1) % hiragana.length;
      showingHiragana = false;
    });
  }

  void _toggleSign() {
    setState(() {
      showingHiragana = !showingHiragana;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
      _nextFlashcard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fiszki')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
              onTap: _toggleSign,
              onHorizontalDragEnd: _onHorizontalDragEnd,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(0),
                ),
                alignment: Alignment.center,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final fontSize = constraints.maxHeight * 0.8;
                    return Baseline(
                      baseline: constraints.maxHeight / 2,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        showingHiragana ? hiragana[currentIndex] : polish[currentIndex],
                        style: TextStyle(fontSize: fontSize),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
