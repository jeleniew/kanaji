import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/progress_mode.dart';
import 'package:kanaji/presentation/viewmodels/result_viewmodel.dart';
import 'package:kanaji/presentation/views/base_page.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final vm = Provider.of<ResultViewmodel>(context, listen: false);

      vm.load(
        setId: args['setId'] as int,
        mode: args['mode'] as ProgressMode,
      );

      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ResultViewmodel>();

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final total = vm.total;
    final correct = vm.correct;
    final accuracy = vm.accuracy;

    Color accuracyColor() {
      if (accuracy >= 0.8) return Colors.green;
      if (accuracy >= 0.5) return Colors.orange;
      return Colors.red;
    }

    return BasePage(
      title: 'Results',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: CircularProgressIndicator(
                      value: accuracy,
                      strokeWidth: 10,
                      color: accuracyColor(),
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '${(accuracy * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Accuracy',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 32,
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$correct / $total correct',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${vm.incorrect} incorrect',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
