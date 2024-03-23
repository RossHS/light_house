import 'dart:math' as math;

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:light_house/src/widgets/errors_widgets/errors_widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Набор виджетбуков для элементов вывода ошибок - [ErrorsNotification]

//-----------------Вывод самих плашек с ошибками----------------------------//
@widgetbook.UseCase(name: 'ErrorsNotification use case', type: ErrorsNotification)
Widget errorsNotificationUseCase(BuildContext context) {
  final text = context.knobs.string(label: 'text', initialValue: 'default error');
  return _ErrorsNotificationWidgetbookTest(text);
}

class _ErrorsNotificationWidgetbookTest extends StatefulWidget {
  const _ErrorsNotificationWidgetbookTest(this.text);

  final String text;

  @override
  State<_ErrorsNotificationWidgetbookTest> createState() => _ErrorsNotificationWidgetbookTestState();
}

class _ErrorsNotificationWidgetbookTestState extends State<_ErrorsNotificationWidgetbookTest> {
  var _isTappable = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ErrorsNotification.text(text: 'text ${widget.text}'),
        const SizedBox(height: 20),
        ErrorsNotification.button(
          text: 'button ${widget.text}',
          // ignore: avoid_print
          onPressed: _isTappable ? () => print('pressed') : null,
        ),
        const SizedBox(height: 20),
        Switch(
          value: _isTappable,
          onChanged: (value) => setState(() => _isTappable = value),
        ),
      ],
    );
  }
}

//-----------------Вывод списка ошибок----------------------------//
@widgetbook.UseCase(name: 'ErrorsAnimatedList use case', type: ErrorsAnimatedList)
Widget errorsAnimatedListUseCase(BuildContext context) => const _ErrorsAnimatedListWidgetbookTest();

class _ErrorsAnimatedListWidgetbookTest extends StatefulWidget {
  const _ErrorsAnimatedListWidgetbookTest();

  @override
  State<_ErrorsAnimatedListWidgetbookTest> createState() => _ErrorsAnimatedListWidgetbookTestState();
}

class _ErrorsAnimatedListWidgetbookTestState extends State<_ErrorsAnimatedListWidgetbookTest> {
  final _errorsList = <Widget>[
    const ErrorsNotification.text(key: ValueKey('presets ${1}'), text: '1 - random error'),
    const ErrorsNotification.text(key: ValueKey('presets ${2}'), text: '2 - random error'),
    const ErrorsNotification.text(key: ValueKey('presets ${3}'), text: '3 - random error'),
  ];

  final _rnd = math.Random();

  int get _rndIndex => _rnd.nextInt(_errorsList.length);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          runSpacing: 5,
          spacing: 5,
          children: [
            ElevatedButton(
              onPressed: _removeTap,
              child: const Text('Remove'),
            ),
            ElevatedButton(
              onPressed: _addTap,
              child: const Text('Add'),
            ),
            ElevatedButton(
              onPressed: _add3ItemsTap,
              child: const Text('Add 3 error'),
            ),
            ElevatedButton(
              onPressed: _addWithTimerTap,
              child: const Text('Add with timer'),
            ),
          ],
        ),
        Expanded(
          child: ErrorsAnimatedList(
            children: _errorsList,
          ),
        ),
      ],
    );
  }

  void _removeTap() {
    if (_errorsList.isEmpty) return;
    setState(() {
      final index = _rndIndex;
      // ignore: avoid_print
      print('removed. Index: $index');
      _errorsList.removeAt(index);
    });
  }

  void _addTap() {
    final index = _errorsList.isEmpty ? 0 : _rndIndex;
    final key = _rnd.nextInt(1000000);
    // ignore: avoid_print
    print('added.Index: $index. Text: $index - random error. key - $key');
    setState(
      () => _errorsList.insert(
        index,
        ErrorsNotification.text(key: ValueKey(key), text: '$index - random error. key - $key'),
      ),
    );
  }

  void _add3ItemsTap() {
    // ignore: avoid_print
    print('add 3 items');
    for (int i = 0; i < 3; i++) {
      final index = _errorsList.isEmpty ? 0 : _rndIndex;
      final key = _rnd.nextInt(1000000);
      // ignore: avoid_print
      print('added.Index: $index. Text: $index - random error. key - $key');
      _errorsList.insert(
        index,
        ErrorsNotification.text(key: ValueKey(key), text: '$index - random error. key - $key'),
      );
    }
    setState(() {});
  }

  void _addWithTimerTap() {
    final index = _errorsList.isEmpty ? 0 : _rndIndex;
    final key = _rnd.nextInt(1000000);
    // ignore: avoid_print
    print('added with timer.Index: $index. Text: $index - random error. key - $key');
    setState(
      () => _errorsList.insert(
        index,
        ErrorsNotification.text(key: ValueKey(key), text: '$index - random error. key - $key. With timer'),
      ),
    );
    RestartableTimer(
      const Duration(seconds: 3),
      () {
        if (!mounted) return;
        setState(() {
          _errorsList.removeWhere((element) => element.key == ValueKey(key));
        });
      },
    );
  }
}
