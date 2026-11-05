import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Sustituye a FlutterSecureStorage con los mismos métodos
/// (read, write, delete), así el resto del código no cambia.
///
/// - Android / iOS: usa FlutterSecureStorage como siempre.
/// - Web con [sesionPorPestana] = true: guarda los datos en memoria, que es
///   independiente en cada pestaña (se pierde al recargar la pestaña).
/// - Web con [sesionPorPestana] = false: comportamiento normal, la sesión se
///   comparte entre pestañas y se conserva al recargar.
class AppStorage {
  const AppStorage();


  static const bool sesionPorPestana = true;

  static const FlutterSecureStorage _seguro = FlutterSecureStorage();

  static final Map<String, String> _memoria = {};

  bool get _usarMemoria => kIsWeb && sesionPorPestana;

  Future<String?> read({required String key}) async {
    if (_usarMemoria) return _memoria[key];

    return _seguro.read(key: key);
  }

  Future<void> write({required String key, required String? value}) async {
    if (_usarMemoria) {
      if (value == null) {
        _memoria.remove(key);
      } else {
        _memoria[key] = value;
      }
      return;
    }

    await _seguro.write(key: key, value: value);
  }

  Future<void> delete({required String key}) async {
    if (_usarMemoria) {
      _memoria.remove(key);
      return;
    }

    await _seguro.delete(key: key);
  }
}