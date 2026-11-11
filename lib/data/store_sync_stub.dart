class StoreSyncAdapter {
  StoreSyncAdapter(this._onRemoteData);

  // ignore: unused_field
  final void Function(String json) _onRemoteData;

  String? loadInitialData() => null;

  void publishData(String json) {}

  void dispose() {}
}
