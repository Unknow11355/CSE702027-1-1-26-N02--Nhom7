import 'dart:async';

class StoreSyncAdapter {
  StoreSyncAdapter(this._onRemoteData);

  // ignore: unused_field
  final void Function(String json) _onRemoteData;

  String? loadInitialData() => null;

  void publishData(String json) {}

  Future<T> runExclusive<T>(FutureOr<T> Function() action) async {
    return await action();
  }

  void dispose() {}
}
