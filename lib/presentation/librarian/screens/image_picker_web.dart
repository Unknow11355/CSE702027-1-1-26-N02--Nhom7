import 'dart:async';
import 'dart:js_interop';

@JS('document.createElement')
external JSObject _createElement(JSString tagName);

extension type _HtmlInputElement(JSObject _) implements JSObject {
  external set type(JSString value);
  external set accept(JSString value);
  external set onchange(JSFunction? callback);
  external void click();
  external _FileList? get files;
}

extension type _FileList(JSObject _) implements JSObject {
  external int get length;
  external JSObject? item(int index);
}

@JS('FileReader')
extension type _FileReader._(JSObject _) implements JSObject {
  external factory _FileReader();
  external set onload(JSFunction? callback);
  external set onerror(JSFunction? callback);
  external JSAny? get result;
  external void readAsDataURL(JSObject blob);
}

Future<String?> pickCoverImageAsDataUrl() {
  final completer = Completer<String?>();
  final input = _HtmlInputElement(_createElement('input'.toJS));
  input.type = 'file'.toJS;
  input.accept = 'image/*'.toJS;

  input.onchange = ((JSAny? _) {
    final files = input.files;
    if (files == null || files.length == 0) {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
      return;
    }

    final file = files.item(0);
    if (file == null) {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
      return;
    }

    final reader = _FileReader();
    reader.onload = ((JSAny? _) {
      final rawResult = reader.result;
      final dataUrl = (rawResult as JSString?)?.toDart;
      if (!completer.isCompleted) {
        completer.complete(dataUrl);
      }
    }).toJS;
    reader.onerror = ((JSAny? _) {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    }).toJS;
    reader.readAsDataURL(file);
  }).toJS;

  input.click();
  return completer.future;
}
