
import 'dart:convert';
import 'dart:math';

import 'package:flutter_application_1/app_config.dart';
import 'package:flutter_application_1/services/app_storage.dart';
import 'package:http/http.dart' as http;

class SalasService {
  static const String baseUrl = AppConfig.baseUrl;

  final AppStorage _storage = const AppStorage();

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

  Map<String, dynamic> _decodeResponse(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return {};
    } catch (_) {
      return {};
    }
  }

  String _mensajeError(
    Map<String, dynamic> data,
    String mensajePredeterminado,
  ) {
    return data['message']?.toString() ??
        data['error']?.toString() ??
        mensajePredeterminado;
  }

  // GENERAR CÓDIGO
  String generarCodigo() {
    const caracteres = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();

    return List.generate(
      6,
      (_) => caracteres[random.nextInt(caracteres.length)],
    ).join();
  }

  // CREAR SALA
  Future<Map<String, dynamic>> crearSala({
    required String codigo,
    required int juegoId,
    required int numJugadores,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/salas'),
      headers: await _headers(),
      body: jsonEncode({
        'codigo': codigo.trim().toUpperCase(),
        'juego_id': juegoId,
        'num_jugadores': numJugadores,
      }),
    );

    final data = _decodeResponse(response);

    if (response.statusCode == 201) {
      return Map<String, dynamic>.from(data['sala'] ?? data);
    }

    throw Exception(
      _mensajeError(data, 'Error creando la sala'),
    );
  }

  // UNIRSE A UNA SALA
  Future<Map<String, dynamic>> unirseSala({
    required String codigo,
  }) async {
    final codigoNormalizado = codigo.trim().toUpperCase();

    if (codigoNormalizado.isEmpty) {
      throw Exception('Introduce el código de la sala');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/salas/unirse'),
      headers: await _headers(),
      body: jsonEncode({
        'codigo': codigoNormalizado,
      }),
    );

    final data = _decodeResponse(response);

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return Map<String, dynamic>.from(data['sala'] ?? data);
    }

    throw Exception(
      _mensajeError(data, 'No se pudo unir a la sala'),
    );
  }

  // OBTENER INFORMACIÓN DE LA SALA
  Future<Map<String, dynamic>> obtenerSala(int salaId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/salas/$salaId'),
      headers: await _headers(),
    );

    final data = _decodeResponse(response);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      _mensajeError(data, 'No se pudo cargar la sala'),
    );
  }

  // INICIAR PARTIDA
  Future<void> iniciarSala(int salaId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/salas/$salaId/iniciar'),
      headers: await _headers(),
    );

    final data = _decodeResponse(response);

    if (response.statusCode != 200) {
      throw Exception(
        _mensajeError(data, 'No se pudo iniciar la sala'),
      );
    }
  }

  // GUARDAR RESULTADO
  Future<Map<String, dynamic>> guardarResultado({
    required int salaId,
    required int puntos,
    required int tiempoSegundos,
    required int intentos,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/salas/$salaId/resultados'),
      headers: await _headers(),
      body: jsonEncode({
        'puntos': puntos,
        'tiempo_segundos': tiempoSegundos,
        'intentos': intentos,
      }),
    );

    final data = _decodeResponse(response);

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return Map<String, dynamic>.from(
        data['resultado'] ?? data,
      );
    }

    throw Exception(
      _mensajeError(data, 'No se pudo guardar el resultado'),
    );
  }

  // OBTENER CLASIFICACIÓN
  Future<Map<String, dynamic>> obtenerClasificacion({
    required int salaId,
    String orden = 'puntos',
  }) async {
    final uri = Uri.parse(
      '$baseUrl/salas/$salaId/clasificacion',
    ).replace(
      queryParameters: {'orden': orden},
    );

    final response = await http.get(
      uri,
      headers: await _headers(),
    );

    final data = _decodeResponse(response);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      _mensajeError(data, 'No se pudo cargar la clasificación'),
    );
  }

  // CERRAR SALA
  Future<void> cerrarSala(int salaId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/salas/$salaId/cerrar'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return;
    }

    final data = _decodeResponse(response);

    throw Exception(
      _mensajeError(data, 'No se pudo cerrar la sala'),
    );
  }
}
