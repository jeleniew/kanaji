import 'package:flutter/widgets.dart';
import 'package:kanaji/presentation/views/base_page.dart';

class DatasetsPage extends StatefulWidget {
  final String title;
  const DatasetsPage({super.key, required this.title});

  @override
  State<DatasetsPage> createState() => _DatasetsPageState();

}

class _DatasetsPageState extends State<DatasetsPage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: widget.title,
      body: Center(
        child: Text('Datasets Page Content Here'),
      ),
    );
  }
}