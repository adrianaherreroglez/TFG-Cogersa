import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SalasService {
  static const String baseUrl = 'http://localhost:3000';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String> _getToken() async {
    final token = await _storage.read(key: 'token');

    if (token == null || token.isEmpty) {
      throw Exception('No hay una sesión iniciada');
    }

    return token;
  }

  Future<Map<String, String>> _headers() async {
    final token = await _getToken();

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Generar código al entrar en la pantalla.
  String generarCodigo() {
    const caracteres = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();

    return List.generate(
      6,
      (_) => caracteres[random.nextInt(caracteres.length)],
    ).join();
  }

  // Crear la sala con el código que ya se muestra en Flutter.
  Future<Map<String, dynamic>> crearSala({
    required String codigo,
    required int juegoId,
    required int numJugadores,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/salas'),
      headers: await _headers(),
      body: jsonEncode({
        'codigo': codigo,
        'juego_id': juegoId,
        'num_jugadores': numJugadores,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 201) {
      throw Exception(
        data is Map
            ? data['message'] ?? 'Error creando la sala'
            : 'Error creando la sala',
      );
    }

    return Map<String, dynamic>.from(data['sala']);
  }

  Future<Map<String, dynamic>> unirseSala({required String codigo}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/salas/unirse'),
      headers: await _headers(),
      body: jsonEncode({'codigo': codigo.trim().toUpperCase()}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(data['sala']);
    }

    throw Exception(data['message'] ?? 'No se pudo unir a la sala');
  }

  Future<Map<String, dynamic>> obtenerSala(int salaId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/salas/$salaId'),
      headers: await _headers(),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(data['message'] ?? 'No se pudo cargar la sala');
  }

  Future<void> iniciarSala(int salaId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/salas/$salaId/iniciar'),
      headers: await _headers(),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'No se pudo iniciar la sala');
    }
  }
}
