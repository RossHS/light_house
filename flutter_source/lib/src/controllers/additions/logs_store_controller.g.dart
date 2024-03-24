// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logs_store_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LogsStoreController on _LogsStoreControllerBase, Store {
  late final _$logsListAtom =
      Atom(name: '_LogsStoreControllerBase.logsList', context: context);

  @override
  List<LogMessage> get logsList {
    _$logsListAtom.reportRead();
    return super.logsList;
  }

  @override
  set logsList(List<LogMessage> value) {
    _$logsListAtom.reportWrite(value, super.logsList, () {
      super.logsList = value;
    });
  }

  late final _$_LogsStoreControllerBaseActionController =
      ActionController(name: '_LogsStoreControllerBase', context: context);

  @override
  void addLog(LogMessage log) {
    final _$actionInfo = _$_LogsStoreControllerBaseActionController.startAction(
        name: '_LogsStoreControllerBase.addLog');
    try {
      return super.addLog(log);
    } finally {
      _$_LogsStoreControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
logsList: ${logsList}
    ''';
  }
}
