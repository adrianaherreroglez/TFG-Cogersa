import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../models/message.dart';

class MessagesService {
  static const String baseUrl =
      'http://localhost:3000';

  final FlutterSecureStorage _storage =
      const FlutterSecureStorage();

  io.Socket? _socket;

  Future<String> _getToken() async {
    final token = await _storage.read(
      key: 'token',
    );

    if (token == null) {
      throw Exception(
        'No hay una sesión iniciada',
      );
    }

    return token;
  }

  Future<int> obtenerIdUsuario(
    String username,
  ) async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse(
        '$baseUrl/users/username/${Uri.encodeComponent(username)}',
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data['message'] ??
            'Error obteniendo usuario',
      );
    }

    return data['user']['id'];
  }

  Future<List<Message>> obtenerMensajes(
    int userId,
  ) async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse(
        '$baseUrl/messages/$userId',
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data['message'] ??
            'Error obteniendo mensajes',
      );
    }

    final List<dynamic> lista =
        data['messages'];

    return lista
        .map(
          (json) => Message.fromJson(
            Map<String, dynamic>.from(json),
          ),
        )
        .toList();
  }

  Future<void> conectar({
    required Function(Message) onNuevoMensaje,
    Function(String)? onError,
  }) async {
    final token = await _getToken();

    _socket = io.io(
      baseUrl,
      io.OptionBuilder()
          .setTransports([
            'websocket',
          ])
          .setAuth({
            'token': token,
          })
          .disableAutoConnect()
          .build(),
    );

    _socket!.on(
      'new_message',
      (data) {
        if (data == null) {
          return;
        }

        final mensaje = Message.fromJson(
          Map<String, dynamic>.from(data),
        );

        onNuevoMensaje(mensaje);
      },
    );

    _socket!.on(
      'message_error',
      (data) {
        if (onError != null) {
          onError(
            data['message'] ??
                'Error enviando mensaje',
          );
        }
      },
    );

    _socket!.onConnectError(
      (error) {
        if (onError != null) {
          onError(
            'No se pudo conectar al chat',
          );
        }
      },
    );

    _socket!.connect();
  }

  void enviarMensaje({
    required int receiverId,
    required String message,
  }) {
    if (_socket == null ||
        !_socket!.connected) {
      throw Exception(
        'No se pudo conectar al chat',
      );
    }

    _socket!.emit(
      'send_message',
      {
        'receiverId': receiverId,
        'message': message,
      },
    );
  }

  void desconectar() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}

