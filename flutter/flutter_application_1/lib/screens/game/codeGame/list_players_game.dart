import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_application_1/services/salas_service.dart';
import 'package:flutter_application_1/screens/game/service/datos_partida.dart';
import 'package:flutter_application_1/widgets/nav_bar.dart';

class ListPlayersGame extends StatefulWidget {
  final int salaId;

  const ListPlayersGame({super.key, required this.salaId});

  @override
  State<ListPlayersGame> createState() => _ListPlayersGameState();
}

class _ListPlayersGameState extends State<ListPlayersGame> {
  final SalasService _salasService = SalasService();

  Timer? _timer;

  bool _cargando = true;
  bool _iniciando = false;
  bool _navegando = false;

  String? _error;
  String _estado = 'esperando';
  String _codigo = '';

  bool _esAnfitrion = false;
  int _juegoId = 0;

  List<Map<String, dynamic>> _miembros = [];

  @override
  void initState() {
    super.initState();

    _actualizarSala();

    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _actualizarSala(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _actualizarSala() async {
    if (_navegando) return;

    try {
      final data = await _salasService.obtenerSala(widget.salaId);

      if (!mounted || _navegando) return;

      // La respuesta del backend contiene sala, miembros
      // y es_anfitrion.
      final sala = Map<String, dynamic>.from(data['sala'] ?? data);

      final miembros = List<Map<String, dynamic>>.from(
        (data['miembros'] as List? ?? []).map(
          (m) => Map<String, dynamic>.from(m),
        ),
      );

      final estado = sala['estado']?.toString() ?? 'esperando';

      setState(() {
        _codigo = sala['codigo']?.toString() ?? '';
        _estado = estado;
        _juegoId = int.tryParse(sala['juego_id']?.toString() ?? '') ?? 0;

        _esAnfitrion = data['es_anfitrion'] == true;
        _miembros = miembros;
        _cargando = false;
        _error = null;
      });

      if (estado == 'cerrada') {
        _irAClasificacion();
      } else if (estado == 'jugando') {
        if (_esAnfitrion) {
          _irAClasificacion();
        } else {
          _irAlJuego();
        }
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cargando = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _iniciarPartida() async {
    if (_iniciando || _navegando) return;

    setState(() {
      _iniciando = true;
      _error = null;
    });

    try {
      await _salasService.iniciarSala(widget.salaId);

      if (!mounted) return;

      // El anfitrión NO juega.
      _irAClasificacion();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _iniciando = false;
        _error = e.toString();
      });
    }
  }

  void _irAClasificacion() {
    if (_navegando || !mounted) return;

    _navegando = true;
    _timer?.cancel();

    context.go(
      '/clasificacion',
      extra: {'salaId': widget.salaId, 'esAnfitrion': _esAnfitrion},
    );
  }

  void _irAlJuego() {
    if (_navegando || !mounted) return;

    _navegando = true;
    _timer?.cancel();

    final datosPartida = DatosPartida();

    if (_juegoId == 1) {
      context.go(
        '/first',
        extra: {'salaId': widget.salaId, 'datosPartida': datosPartida},
      );
    } else {
      _navegando = false;

      setState(() {
        _error = 'El juego $_juegoId no está configurado.';
      });
    }
  }

  Future<void> _copiarCodigo() async {
    await Clipboard.setData(ClipboardData(text: _codigo));

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Código copiado')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFDF4),

      body: SafeArea(
        child: _cargando
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const NavBar(),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        Text(
                          '¡Preparados para jugar!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF298133),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  'Código de la sala',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SelectableText(
                                      _codigo,
                                      style: GoogleFonts.quicksand(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 5,
                                        color: const Color(0xFF298133),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: _copiarCodigo,
                                      icon: const Icon(Icons.copy),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Comparte este código con tus compañeros.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.quicksand(),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          'Jugadores (${_miembros.length})',
                          style: GoogleFonts.quicksand(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        ..._miembros.map((miembro) {
                          final esAnfitrion = miembro['es_anfitrion'] == true;

                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFFD8EDD5),
                                child: Icon(
                                  esAnfitrion
                                      ? Icons.workspace_premium
                                      : Icons.person,
                                  color: const Color(0xFF298133),
                                ),
                              ),
                              title: Text(
                                miembro['nombre']?.toString() ?? 'Jugador',
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: esAnfitrion
                                  ? const Chip(label: Text('Anfitrión'))
                                  : null,
                            ),
                          );
                        }),

                        const SizedBox(height: 12),

                        if (_error != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),

                        if (_estado == 'esperando' && !_esAnfitrion)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 10),
                                  Text('Esperando al anfitrión…'),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  if (_esAnfitrion && _estado == 'esperando')
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _iniciando ? null : _iniciarPartida,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF298133),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            _iniciando
                                ? 'Iniciando partida…'
                                : 'Iniciar partida',
                            style: GoogleFonts.quicksand(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
