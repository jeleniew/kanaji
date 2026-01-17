import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/character.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_select_characters_viewmodel.dart';
import 'package:provider/provider.dart';

class CharacterTile extends StatelessWidget {
  final Character character;

  const CharacterTile({
    super.key, 
    required this.character,
  });
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ISelectCharactersViewmodel>(
      builder: (context, vm, child) {
        final isSelected = vm.checkIfSelected(character);
        
        return GestureDetector(
          onTap: () => vm.toggleCharacterSelection(character),
          child: GridTile(
            child:  Container(
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFFFDDE9) : Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(character.glyph, style: TextStyle(fontSize: 32)),
                  SizedBox(height: 8.0),
                  Text(character.meaning),
                ],
              ),
            )
          ),
        );
      }
    );
  }
}