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

  Future<Map<String, dynamic>> _obtenerPerfil() async {
    final token = await _obtenerToken();

    final response = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      String mensaje = 'Error al obtener el perfil';

      try {
        final errorData = jsonDecode(response.body);
        if (errorData is Map && errorData['message'] != null) {
          mensaje = errorData['message'].toString();
        }
      } catch (_) {
        // Se conserva el mensaje predeterminado.
      }

      throw Exception(mensaje);
    }

    final data = jsonDecode(response.body);

    if (data is! Map<String, dynamic>) {
      throw Exception('La respuesta del perfil no es válida');
    }

    return data;
  }

  Future<String> getNombreUsuario() async {
    final usuario = await _obtenerPerfil();
    final username = usuario['username'];

    if (username == null) {
      throw Exception('No se encontró el nombre de usuario');
    }

    return username.toString();
  }

  Future<String> getPassword() async {
    // Las contraseñas están almacenadas como hashes bcrypt
    // No se puede recuperar la contraseña original
    await _obtenerToken();
    return '********';
  }
}
