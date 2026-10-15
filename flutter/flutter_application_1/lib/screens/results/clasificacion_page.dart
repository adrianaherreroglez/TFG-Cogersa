
// ignore_for_file: unused_local_variable, unused_element, unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/game/service/datos_partida.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/salas_service.dart';
import '../../widgets/nav_bar.dart';


class ClasificacionPage extends StatefulWidget {
  final int salaId;
  final bool esAnfitrion;
  final DatosPartida? datosPartida;

  const ClasificacionPage({
    super.key,
    required this.salaId,
    required this.esAnfitrion,
    this.datosPartida,
  });

  @override
  State<ClasificacionPage> createState() => _ClasificacionPageState();
}
 
class _ClasificacionPageState extends State<ClasificacionPage> {
  final SalasService _service = SalasService();

  Timer? _timer;
  String _orden = 'puntos';
  bool _cargando = true;
  bool _cerrando = false;
  String? _error;
  List<Map<String, dynamic>> _jugadores = [];
  String _estadoSala = 'jugando';

  @override
  void initState() {
    super.initState();
    _actualizar();
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _actualizar(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _actualizar() async {
    try {
      final data = await _service.obtenerClasificacion(
        salaId: widget.salaId,
        orden: _orden,
      );

      if (!mounted) return;

      final sala = Map<String, dynamic>.from(data['sala']);
      final jugadores = List<Map<String, dynamic>>.from(
        (data['clasificacion'] as List).map(
          (item) => Map<String, dynamic>.from(item),
        ),
      );

      setState(() {
        _jugadores = jugadores;
        _estadoSala = sala['estado']?.toString() ?? 'jugando';
        _cargando = false;
        _error = null;
      });

      // Si el anfitrión cierra la sala, los jugadores que están
      // en esta pantalla ven el cambio en la siguiente actualización.
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _cerrarSala() async {
    setState(() => _cerrando = true);

    try {
      await _service.cerrarSala(widget.salaId);
      _timer?.cancel();

      if (!mounted) return;

      setState(() {
        _estadoSala = 'cerrada';
        _cerrando = false;
      });

      await _actualizar();
    } catch (e) {
      if (!mounted) return;

      setState(() => _cerrando = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  String _formatearTiempo(dynamic segundos) {
    final total = (segundos as num?)?.toInt() ?? 0;
    final minutos = total ~/ 60;
    final resto = total % 60;
    return '${minutos.toString().padLeft(2, '0')}:'
        '${resto.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final cerrada = _estadoSala == 'cerrada';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F8EF),
      body: SafeArea(
        child: Column(
          children: [
            const NavBar(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    cerrada
                        ? 'Sala cerrada'
                        : '¡Mira cómo va la partida!',
                    style: GoogleFonts.quicksand(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _orden,
                    decoration: const InputDecoration(
                      labelText: 'Clasificar por',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'puntos',
                        child: Text('Puntos'),
                      ),
                      DropdownMenuItem(
                        value: 'tiempo',
                        child: Text('Tiempo'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _orden = value;
                        _cargando = true;
                      });
                      _actualizar();
                    },
                  ),
                ],
              ),
            ),
            if (_cargando)
              const LinearProgressIndicator(),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'No se pudo actualizar el ranking: $_error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            Expanded(
              child: _jugadores.isEmpty && !_cargando
                  ? const Center(
                      child: Text('Todavía no hay resultados.'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _jugadores.length,
                      itemBuilder: (context, index) {
                        final jugador = _jugadores[index];
                        final terminado =
                            jugador['terminado'] == true;

                        final detalle = _orden == 'puntos'
                            ? '${jugador['puntos'] ?? 0} puntos'
                            : terminado
                                ? _formatearTiempo(
                                    jugador['tiempo_segundos'],
                                  )
                                : 'Jugando…';

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            title: Text(
                              jugador['nombre']?.toString() ??
                                  'Jugador',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              terminado
                                  ? 'Terminado · ${jugador['intentos'] ?? 0} intentos'
                                  : 'Partida pendiente',
                            ),
                            trailing: Text(
                              detalle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.esAnfitrion && !cerrada)
                    ElevatedButton(
                      onPressed: _cerrando ? null : _cerrarSala,
                      child: Text(
                        _cerrando ? 'Cerrando…' : 'Cerrar Sala',
                      ),
                    ),
                  if (widget.datosPartida != null)
                    ElevatedButton(
                      onPressed: () {
                        context.go( 
                          '/mygame',
                          extra: widget.datosPartida,
                        );
                      },
                      child: const Text('Mi Partida'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
