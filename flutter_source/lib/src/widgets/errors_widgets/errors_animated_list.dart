import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Вывод списка ошибок на экран пользователя,
/// для корректно работы крайне важно передавать ключи [Key] в виджетах [children],
/// без них возможны различные баги
class ErrorsAnimatedList extends StatefulWidget {
  const ErrorsAnimatedList({super.key, required this.children});

  final List<Widget> children;

  @override
  State<ErrorsAnimatedList> createState() => _ErrorsAnimatedListState();
}

class _ErrorsAnimatedListState extends State<ErrorsAnimatedList> {
  late List<Widget> _localChildren;

  // Т.к. надо получить доступ для анимированного списка
  final _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _localChildren = [...widget.children];
  }

  @override
  void didUpdateWidget(covariant ErrorsAnimatedList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Если списки не равны, то проверяем их на наличие новых и удаленных элементов,
    // дабы обновить данные в AnimatedList соответствии с widget.children
    final diffs = _searchDiffs(_localChildren, widget.children);
    if (diffs.isNotEmpty) {
      _localChildren = [...widget.children];
      for (var difElement in diffs) {
        if (!difElement.isAdded) {
          _listKey.currentState!.removeItem(
            difElement.index,
            (context, animation) => _removeIt(
              difElement.widget,
              animation,
            ),
          );
        } else {
          _listKey.currentState!.insertItem(difElement.index);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      clipBehavior: Clip.none,
      key: _listKey,
      initialItemCount: _localChildren.length,
      itemBuilder: _addIt,
    );
  }

  /// Анимация добавления элемента на экран
  Widget _addIt(BuildContext context, int index, Animation<double> animation) {
    final child = _localChildren[index];
    return SizeTransition(
      key: ObjectKey(child),
      sizeFactor: animation,
      child: child,
    );
  }

  /// В аргументе удаленная модель, т.к. в реальном списке моделей уже ее нет,
  /// а анимация еще не началась Поэтому передаем удаленный элемент,
  /// т.е. используем что-то на подобии муляжа
  Widget _removeIt(Widget child, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: child,
    );
  }

  /// Алгоритм поиска различий в списках по ключам
  /// где [local] - это локальный список, который хранится в state
  /// [origin] - новопришедший список виджетов
  /// возвращает следующее значение
  /// index - индекс добавленного, или удаленного виджета, который необходимо подставить в [local]
  /// isAdded - проверка, добавлен или удален виджет
  /// widget - сам отличительный виджет
  List<({int index, bool isAdded, Widget widget})> _searchDiffs(List<Widget> local, List<Widget> origin) {
    final diffList = <({int index, bool isAdded, Widget widget})>[];
    Map<Key, Widget> genKeysList(List<Widget> list) => {for (var e in list) e.key!: e};

    final localMap = genKeysList(local);
    final originMap = genKeysList(origin);
    if (const ListEquality().equals(localMap.keys.toList(), originMap.keys.toList())) {
      return diffList;
    }

    // Поиск и добавление в [diffList] отличных элементов
    void runDiffs(Map<Key, Widget> firstMap, Map<Key, Widget> secondMap, bool isAdded) {
      final firstEntry = firstMap.entries.toList();

      // Поиск изменённых элементов
      final List<Key> diffItems = firstMap.keys.toSet().difference(secondMap.keys.toSet()).toList();
      // Добавление удаленных элементов
      for (int i = 0; i < firstMap.length; i++) {
        final entry = firstEntry[i];
        if (diffItems.contains(entry.key)) {
          diffList.add((index: i, isAdded: isAdded, widget: entry.value));
        }
      }
    }

    runDiffs(localMap, originMap, false);
    runDiffs(originMap, localMap, true);

    return diffList;
  }
}
