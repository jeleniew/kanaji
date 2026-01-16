import 'package:flutter/material.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_datasets_viewmodel.dart';
import 'package:kanaji/presentation/views/base_page.dart';
import 'package:provider/provider.dart';

class DatasetsPage extends StatefulWidget {
  final String title;
  const DatasetsPage({super.key, required this.title});

  @override
  State<DatasetsPage> createState() => _DatasetsPageState();

}

class _DatasetsPageState extends State<DatasetsPage> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<IDatasetsViewmodel>(context);

    return BasePage(
      title: widget.title,
      body: FutureBuilder(
        future: vm.getAvailableCharacterSets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final datasets = snapshot.data!;
            return ListView.builder(
              itemCount: datasets.length,
              itemBuilder: (context, index) {
                final dataset = datasets[index];
                return ListTile(
                  title: Text(dataset.name),
                  subtitle: Text(dataset.description),
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }

        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-dataset');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}