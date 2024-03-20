import 'package:flutter/material.dart';
import 'package:light_house/src/widgets/errors_animated_list/errors_animated_lib.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Набор виджетбуков для элементов вывода ошибок - [ErrorForList]

@widgetbook.UseCase(name: 'ErrorForList use case', type: ErrorForList)
Widget errorForListUseCase(BuildContext context) {
  final text = context.knobs.string(label: 'text', initialValue: 'default error');
  return _WidgetbookTest(text);
}

class _WidgetbookTest extends StatefulWidget {
  const _WidgetbookTest(this.text);

  final String text;

  @override
  State<_WidgetbookTest> createState() => _WidgetbookTestState();
}

class _WidgetbookTestState extends State<_WidgetbookTest> {
  var _isTappable = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ErrorForList(
          text: widget.text,
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
