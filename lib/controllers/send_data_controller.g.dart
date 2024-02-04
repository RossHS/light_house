// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_data_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SendDataController on _SendDataControllerBase, Store {
  late final _$_lastSendDataAtom =
      Atom(name: '_SendDataControllerBase._lastSendData', context: context);

  @override
  AsyncValue<String> get _lastSendData {
    _$_lastSendDataAtom.reportRead();
    return super._lastSendData;
  }

  @override
  set _lastSendData(AsyncValue<String> value) {
    _$_lastSendDataAtom.reportWrite(value, super._lastSendData, () {
      super._lastSendData = value;
    });
  }

  late final _$writeDataAsyncAction =
      AsyncAction('_SendDataControllerBase.writeData', context: context);

  @override
  Future<void> writeData(DataHeader header, String data) {
    return _$writeDataAsyncAction.run(() => super.writeData(header, data));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
