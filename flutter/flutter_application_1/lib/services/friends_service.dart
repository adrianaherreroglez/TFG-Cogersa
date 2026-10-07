import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/friend.dart';

class FriendsService {
  static const String baseUrl =
      'http://localhost:3000';

  final FlutterSecureStorage _storage =
      const FlutterSecureStorage();



  // TOKEN
  Future<String> _getToken() async {
    final token =
        await _storage.read(
      key: 'token',
    );

    if (token == null) {
      throw Exception(
        'No hay una sesión iniciada',
      );
    }

    return token;
  }



  // HEADERS
  Future<Map<String, String>> _headers()
      async {
    final token =
        await _getToken();

    return {
      'Content-Type':
          'application/json',

      'Authorization':
          'Bearer $token',
    };
  }


 
  // OBTENER AMIGOS
  Future<List<Friend>> obtenerAmigos()
      async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/friends',
      ),
      headers:
          await _headers(),
    );

    final data =
        jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data['message'] ??
            'Error obteniendo amigos',
      );
    }

    final List<dynamic> lista =
        data['friends'];

    return lista
        .map(
          (json) =>
              Friend.fromJson(json),
        )
        .toList();
  }


  // BUSCAR USUARIOS
  Future<List<Friend>> buscarUsuarios(
    String username,
  ) async {
    final response =
        await http.get(
      Uri.parse(
        '$baseUrl/users/search'
        '?username='
        '${Uri.encodeComponent(username)}',
      ),
      headers:
          await _headers(),
    );

    final data =
        jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data['message'] ??
            'Error buscando usuarios',
      );
    }

    final List<dynamic> lista =
        data['users'];

    return lista
        .map(
          (json) =>
              Friend.fromJson(json),
        )
        .toList();
  }



  // SOLICITUDES RECIBIDAS
  Future<List<Friend>>
      obtenerSolicitudesRecibidas()
      async {
    final response =
        await http.get(
      Uri.parse(
        '$baseUrl/friends/requests/received',
      ),
      headers:
          await _headers(),
    );

    final data =
        jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data['message'] ??
            'Error obteniendo solicitudes recibidas',
      );
    }

    final List<dynamic> lista =
        data['requests'];

    return lista
        .map(
          (json) =>
              Friend.fromJson(json),
        )
        .toList();
  }


  // SOLICITUDES ENVIADAS
  Future<List<Friend>>
      obtenerSolicitudesEnviadas()
      async {
    final response =
        await http.get(
      Uri.parse(
        '$baseUrl/friends/requests/sent',
      ),
      headers:
          await _headers(),
    );

    final data =
        jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data['message'] ??
            'Error obteniendo solicitudes enviadas',
      );
    }

    final List<dynamic> lista =
        data['requests'];

    return lista
        .map(
          (json) =>
              Friend.fromJson(json),
        )
        .toList();
  }



  // ENVIAR SOLICITUD
  Future<void> enviarSolicitud(
    int receiverId,
  ) async {
    final response =
        await http.post(
      Uri.parse(
        '$baseUrl/friends/requests',
      ),
      headers:
          await _headers(),
      body: jsonEncode({
        'receiverId':
            receiverId,
      }),
    );

    final data =
        jsonDecode(response.body);

    if (response.statusCode != 201) {
      throw Exception(
        data['message'] ??
            'Error enviando solicitud',
      );
    }
  }



  // ACEPTAR SOLICITUD
  Future<void> aceptarSolicitud(
    int requestId,
  ) async {
    final response =
        await http.put(
      Uri.parse(
        '$baseUrl/friends/requests/'
        '$requestId/accept',
      ),
      headers:
          await _headers(),
    );

    final data =
        jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data['message'] ??
            'Error aceptando solicitud',
      );
    }
  }


 
  // RECHAZAR SOLICITUD
  Future<void> rechazarSolicitud(
    int requestId,
  ) async {
    final response =
        await http.delete(
      Uri.parse(
        '$baseUrl/friends/requests/'
        '$requestId',
      ),
      headers:
          await _headers(),
    );

    final data =
        jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data['message'] ??
            'Error rechazando solicitud',
      );
    }
  }
}

