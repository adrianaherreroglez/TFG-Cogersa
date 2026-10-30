import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  static const String baseUrl = 'http://localhost:3000';

  final FlutterSecureStorage _storage =
      const FlutterSecureStorage();

  Future<String> _obtenerToken() async {
    final token = await _storage.read(key: 'token');

    if (token == null || token.isEmpty) {
      throw Exception('No hay una sesión iniciada');
    }

    return token;
  }

  Future<Map<String, dynamic>> _peticion({
    required String metodo,
    required String ruta,
    Map<String, dynamic>? body,
  }) async {
    final token = await _obtenerToken();

    final uri = Uri.parse('$baseUrl$ruta');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    late http.Response response;

    if (metodo == 'GET') {
      response = await http.get(uri, headers: headers);
    } else {
      response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(body ?? {}),
      );
    }

    Map<String, dynamic> data;

    try {
      final decoded = jsonDecode(response.body);
      data = Map<String, dynamic>.from(decoded as Map);
    } catch (_) {
      throw Exception('El servidor devolvió una respuesta no válida');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        data['message'] ?? 'Error al comunicarse con el servidor',
      );
    }

    return data;
  }

  Future<String> getNombreUsuario() async {
    final data = await _peticion(
      metodo: 'GET',
      ruta: '/users/me',
    );

    final username = data['username'];

    if (username == null) {
      throw Exception('No se encontró el nombre de usuario');
    }

    return username.toString();
  }

  Future<Map<String, dynamic>> actualizarPerfil({
    required String username,
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
  }) async {
    final body = <String, dynamic>{
      'username': username.trim(),
    };

    if (newPassword != null && newPassword.isNotEmpty) {
      body['currentPassword'] = currentPassword ?? '';
      body['newPassword'] = newPassword;
      body['confirmPassword'] = confirmPassword ?? '';
    }

    final data = await _peticion(
      metodo: 'PUT',
      ruta: '/users/me',
      body: body,
    );

    return Map<String, dynamic>.from(data['user'] as Map);
  }


  Future<String> getPassword() async {
    // Las contraseñas están almacenadas como hashes bcrypt
    // No se puede recuperar la contraseña original
    await _obtenerToken();
    return '********';
  }
}
