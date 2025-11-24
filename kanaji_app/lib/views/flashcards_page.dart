// flashcards_page.dart
import 'package:flutter/material.dart';
import 'package:kanaji/pages/base_page.dart';
import 'package:kanaji/viewmodels/interfaces/i_flashcards_viewmodel.dart';
import 'package:kanaji/views/widgets/flashcard_view.dart';
import 'package:provider/provider.dart';

class FlashcardsPage extends StatelessWidget {
  final String title;
  const FlashcardsPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<IFlashcardsViewModel>(context);

    return BasePage(
      title: title,
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