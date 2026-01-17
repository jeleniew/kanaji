import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/character.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_select_characters_viewmodel.dart';
import 'package:kanaji/presentation/views/base_page.dart';
import 'package:kanaji/presentation/views/widgets/character_tile.dart';
import 'package:provider/provider.dart';

class SelectCharactersPage extends StatefulWidget {
  const SelectCharactersPage({super.key});

  @override
  State<SelectCharactersPage> createState() => _SelectCharactersPageState();

}

class _SelectCharactersPageState extends State<SelectCharactersPage> {
  late Future<List<Character>> _charactersFuture;
  late ISelectCharactersViewmodel _vm;
  
  @override
  void initState() {
    super.initState();
    _vm = Provider.of<ISelectCharactersViewmodel>(context, listen: false);
    _charactersFuture = _vm.availableCharacters;
  }

  @override
  Widget build(BuildContext context) {

    return BasePage(
      title: 'Select Characters for ${_vm.datasetTitle ?? ''}',
      body: Column(
        children: [
          _buildCharacterGrid(_vm),
          ElevatedButton(
            onPressed: _vm.saveSet,
            child: Text('Save Set'),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterGrid(ISelectCharactersViewmodel vm) {
    return Expanded(
      child: FutureBuilder<List<Character>>(
        future: _charactersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No characters available'));
          } else {
            final characters = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                // TODO: dynamic crossAxisCount based on screen size
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  final character = characters[index];
                  return CharacterTile(character: character);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
  