import 'package:flutter/material.dart';
import 'package:light_house/src/models/log_message_model.dart';
import 'package:light_house/src/screens/logs/widgets/logs_widgets.dart';

/// Отображение унифицированной единицы лога на экране [LogsView]
class LogViewItem extends StatefulWidget {
  const LogViewItem(this.log, {super.key});

  final LogMessage log;

  @override
  State<LogViewItem> createState() => _LogViewItemState();
}

class _LogViewItemState extends State<LogViewItem> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    // Таким образом сохраняем состояние открытости или закрытости виджета в рамках этого навигационного экрана
    // т.е. мы можем быть уверены, что удаляя и добавляя виджет мы всегда получим последний [_isExpanded]
    final isExpandedStorage = PageStorage.maybeOf(context)?.readState(context, identifier: widget.key) as bool?;
    _isExpanded = isExpandedStorage ?? _isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final Color boxColor = switch (widget.log.level) {
      MessageLevel.error => Colors.red,
      MessageLevel.info => Colors.blue,
      MessageLevel.debug => Colors.grey,
      MessageLevel.warning => Colors.yellow,
    };
    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: boxColor,
            width: 2,
          ),
        ),
        child: InkWell(
          splashColor: boxColor,
          splashFactory: InkSparkle.splashFactory,
          onTap: _toggleExpanded,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(widget.log.time.toString())),
                    Text(widget.log.level.name),
                  ],
                ),
              ),
              Divider(color: boxColor, height: 0, thickness: 2),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedSize(
                  alignment: Alignment.topCenter,
                  curve: Curves.easeInOutQuint,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    '${widget.log.msg}$_stackTraceErrorText',
                    maxLines: _isExpanded ? null : 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? get _stackTraceErrorText {
    if (widget.log.stackTrace == null) return '';
    return '\nStackTrace:\n${widget.log.stackTrace}';
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      PageStorage.maybeOf(context)?.writeState(context, _isExpanded, identifier: widget.key);
    });
  }
}
