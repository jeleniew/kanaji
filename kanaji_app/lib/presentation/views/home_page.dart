// home_page.dart
import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/attempt_result.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_home_viewmodel.dart';
import 'package:kanaji/presentation/views/base_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<IHomeViewModel>(context);

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return BasePage(
      title: title,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),

            _section('Practice – last sessions'),
            _barChart(vm.lastPracticeAccuracies),

            const SizedBox(height: 24),

            _section('Newly learned characters'),
            vm.newlyLearnedGlyphs.isEmpty
                ? const Text('No new characters yet')
                : Wrap(
                    spacing: 12,
                    children: vm.newlyLearnedGlyphs
                        .map((g) => Text(g, style: const TextStyle(fontSize: 32)))
                        .toList(),
                  ),

            const SizedBox(height: 24),

            _section('Tests – last results'),
            _barChart(vm.lastTestAccuracies),
          ],
        ),
      ),
    );
  }

  Widget _barChart(List<AttemptResult> data) {
    if (data.isEmpty) {
      return const Text('No data yet');
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.reversed.map((e) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('${(e.accuracy * 100).toInt()}%'),
              Container(
                width: 24,
                height: 100 * e.accuracy,
                decoration: BoxDecoration(
                  color: e.accuracy >= 0.8
                      ? Colors.green
                      : e.accuracy >= 0.5
                          ? Colors.orange
                          : Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _section(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}