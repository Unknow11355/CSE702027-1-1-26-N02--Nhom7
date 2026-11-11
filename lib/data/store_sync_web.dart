import 'dart:async';
import 'dart:js_interop';

@JS('window.localStorage.getItem')
external JSString? _localStorageGetItem(JSString key);

@JS('window.localStorage.setItem')
external void _localStorageSetItem(
  JSString key,
  JSString value,
);

@JS('window.addEventListener')
external void _windowAddEventListener(
  JSString type,
  JSFunction listener,
);

class StoreSyncAdapter {
  StoreSyncAdapter(this._onRemoteData) {
    _initListeners();
  }

  static const String _storageKey = 'library_shared_store_v1';

  final void Function(String json) _onRemoteData;
  String? _lastKnownJson;
  Timer? _pollTimer;

  void _initListeners() {
    final callback = ((JSAny? _) {
      _checkAndSyncFromStorage();
    }).toJS;

    _windowAddEventListener('storage'.toJS, callback);
    _windowAddEventListener('focus'.toJS, callback);
    _windowAddEventListener('visibilitychange'.toJS, callback);

    _pollTimer = Timer.periodic(
      const Duration(milliseconds: 600),
      (_) => _checkAndSyncFromStorage(),
    );
  }

  void _checkAndSyncFromStorage() {
    final raw = loadInitialData();
    if (raw == null || raw.isEmpty || raw == _lastKnownJson) {
      return;
    }
    _lastKnownJson = raw;
    _onRemoteData(raw);
  }

  String? loadInitialData() {
    try {
      final result = _localStorageGetItem(_storageKey.toJS);
      final dartStr = result?.toDart;
      if (dartStr != null && dartStr.isNotEmpty) {
        _lastKnownJson ??= dartStr;
      }
      return dartStr;
    } catch (_) {
      return null;
    }
  }

  void publishData(String json) {
    try {
      _lastKnownJson = json;
      _localStorageSetItem(
        _storageKey.toJS,
        json.toJS,
      );
    } catch (_) {
      // Ignore storage quota or private mode errors.
    }
  }

  void dispose() {
    _pollTimer?.cancel();
  }
}
