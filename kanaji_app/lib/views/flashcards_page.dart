// flashcards_page.dart
import 'package:flutter/material.dart';
import 'package:kanaji/viewmodels/flashcards_viewmodel.dart';
import 'package:kanaji/viewmodels/interfaces/i_flashcards_viewmodel.dart';
import 'package:kanaji/views/widgets/flashcard_view.dart';
import 'package:provider/provider.dart';

class FlashcardsPage extends StatelessWidget {
  const FlashcardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<IFlashcardsViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Fiszki')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: FlashcardView(
              text: vm.currentCard,
              onTap: vm.toggleSign,
              onHorizontalDragEnd: vm.onHorizontalDragEnd,
            ),
          ),
        ),
      ),
    );
  }
}