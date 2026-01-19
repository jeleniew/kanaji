import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/test_task.dart';
import 'package:kanaji/domain/entities/test_task_type.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_test_viewmodel.dart';
import 'package:kanaji/presentation/views/base_page.dart';
import 'package:provider/provider.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  
  @override
  State<TestPage> createState() {
    return _TestPageState();
  }
}

class _TestPageState extends State<TestPage> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_initialized) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final vm = Provider.of<ITestViewmodel>(context, listen: false);

      vm.load(args['setId'] as int);

      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ITestViewmodel>();

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.isFinished) {
      return BasePage(
        title: 'Test Finished',
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🎉 Test completed!'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Return to Home'),
              ),
            ],
          ),
        ),
      );
    }

    return BasePage(
      title: 'Test',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...vm.tasks.asMap().entries.map((entry) {
            final index = entry.key;
            final task = entry.value;

            switch (task.type) {
              case TestTaskType.multipleChoice:
                return _multipleChoice(task, index, vm);
              case TestTaskType.textInput:
                return _textInput(task, index, vm);
              case TestTaskType.matching:
                return _matching(task, index, vm);
            }
          }),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => vm.submitAnswer(null),
            child: const Text('Finish Test'),
          ),
        ],
      ),
    );
  }

  Widget _multipleChoice(
    TestTask task,
    int taskIndex,
    ITestViewmodel vm,
  ) {
    return Wrap(
      children: [
        Text(task.characters.first, style: const TextStyle(fontSize: 48)),
        const SizedBox(height: 16),
        ...task.options!.map(
          (o) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton(
              onPressed: () {
                vm.setAnswer(
                  taskIndex,
                  task.correctCharacterId,
                  o == task.correctAnswer,
                );
              },
              child: Text(o),
            ),
          ),
        ),
      ],
    );
  }

  Widget _textInput(TestTask task, int taskIndex, ITestViewmodel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          task.characters.first,
          style: const TextStyle(fontSize: 48),
        ),
        const SizedBox(height: 24),
        TextField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            hintText: 'Type answer',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            final isCorrect = value.trim() == task.correctAnswer;
            vm.setAnswer(
              taskIndex,
              task.correctCharacterId,
              isCorrect,
            );
          },
        ),
      ],
    );
  }

  Widget _matching(TestTask task, int taskIndex, ITestViewmodel vm) {
    final Map<String, String> answers = {};

    return Column(
      children: [
        ...task.characters.map((c) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Text(c, style: const TextStyle(fontSize: 32)),
                const Spacer(),
                DropdownButton<String>(
                  value: answers[c],
                  items: task.matchingOptions!
                      .map((o) => DropdownMenuItem(
                            value: o.keys.first,
                            child: Text(o.values.first),
                          ))
                      .toList(),
                  onChanged: (val) {
                    vm.setAnswer(
                      taskIndex,
                      task.correctCharacterId,
                      val == task.correctAnswer,
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ]
    );
  }
}