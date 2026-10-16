
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
  final ScrollController _scrollController = ScrollController();

  Timer? _timer;

  String _orden = 'puntos';
  bool _cargando = true;
  bool _cerrando = false;
  String? _error;

  List<Map<String, dynamic>> _jugadores = [];
  String _estadoSala = 'jugando';

  // Paleta de EcoKids.
  static const Color verde = Color(0xFF298133);
  static const Color verdeOscuro = Color(0xFF285C32);
  static const Color verdeClaro = Color(0xFFE8F5E9);
  static const Color verdeSuave = Color(0xFFF1F8EC);
  static const Color fondo = Color(0xFFFAFDF4);
  static const Color borde = Color(0xFFDDEEDB);
  static const Color textoSecundario = Color(0xFF69806A);
  static const Color amarillo = Color(0xFFFFF0C2);
  static const Color naranja = Color(0xFFFFE6CF);

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
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _actualizar() async {
    try {
      final data = await _service.obtenerClasificacion(
        salaId: widget.salaId,
        orden: _orden,
      );

      if (!mounted) return;

      final sala = Map<String, dynamic>.from(data['sala'] ?? {});
      final jugadores = List<Map<String, dynamic>>.from(
        (data['clasificacion'] as List? ?? []).map(
          (item) => Map<String, dynamic>.from(item),
        ),
      );

      setState(() {
        _jugadores = jugadores;
        _estadoSala = sala['estado']?.toString() ?? 'jugando';
        _cargando = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cargando = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _cerrarSala() async {
    if (_cerrando) return;

    setState(() {
      _cerrando = true;
      _error = null;
    });

    try {
      await _service.cerrarSala(widget.salaId);

      if (!mounted) return;

      _timer?.cancel();

      setState(() {
        _estadoSala = 'cerrada';
        _cerrando = false;
      });

      await _actualizar();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cerrando = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo cerrar la sala: $_error',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: verdeOscuro,
          behavior: SnackBarBehavior.floating,
        ),
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

  Color _colorPosicion(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFE7A3);
      case 1:
        return const Color(0xFFE3E9E3);
      case 2:
        return const Color(0xFFFFDCC2);
      default:
        return verdeClaro;
    }
  }

  Color _colorTextoPosicion(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF8A6500);
      case 1:
        return const Color(0xFF526454);
      case 2:
        return const Color(0xFF98552D);
      default:
        return verdeOscuro;
    }
  }

  String _medalla(int index) {
    switch (index) {
      case 0:
        return '🥇';
      case 1:
        return '🥈';
      case 2:
        return '🥉';
      default:
        return '${index + 1}';
    }
  }

  Widget _construirJugadorCard(
    Map<String, dynamic> jugador,
    int index,
  ) {
    final terminado = jugador['terminado'] == true;
    final nombre = jugador['nombre']?.toString() ?? 'Jugador';
    final intentos = jugador['intentos'] ?? 0;

    final detalle = _orden == 'puntos'
        ? '${jugador['puntos'] ?? 0} puntos'
        : terminado
            ? _formatearTiempo(jugador['tiempo_segundos'])
            : 'Jugando…';

    final esPrimero = index == 0;
    final colorPosicion = _colorPosicion(index);
    final colorTexto = _colorTextoPosicion(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: esPrimero
              ? const Color(0xFFEBD58B)
              : borde,
          width: esPrimero ? 1.6 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: verdeOscuro.withValues(alpha: 0.045),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        child: Row(
          children: [
            // Posición en la clasificación.
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorPosicion,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _medalla(index),
                style: GoogleFonts.quicksand(
                  fontSize: index < 3 ? 23 : 16,
                  fontWeight: FontWeight.w800,
                  color: colorTexto,
                ),
              ),
            ),
            const SizedBox(width: 13),

            // Nombre y estado.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: verdeOscuro,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        terminado
                            ? Icons.check_circle_rounded
                            : Icons.hourglass_top_rounded,
                        size: 14,
                        color: terminado
                            ? verde
                            : const Color(0xFFB88726),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          terminado
                              ? 'Completado · $intentos intentos'
                              : 'Partida pendiente',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: textoSecundario,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Puntuación o tiempo.
            Container(
              constraints: const BoxConstraints(minWidth: 75),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: esPrimero ? amarillo : verdeSuave,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    detalle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: esPrimero
                          ? const Color(0xFF8A6500)
                          : verdeOscuro,
                    ),
                  ),
                  if (_orden == 'tiempo' && terminado)
                    Text(
                      'TIEMPO',
                      style: GoogleFonts.quicksand(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: textoSecundario,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirSelectorOrden() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borde),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: verdeClaro,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: verde,
                  size: 21,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ordenar clasificación',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: verdeOscuro,
                      ),
                    ),
                    Text(
                      'Elige cómo quieres ver los resultados',
                      style: GoogleFonts.quicksand(
                        fontSize: 11,
                        color: textoSecundario,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            initialValue: _orden,
            isExpanded: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: verdeSuave,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 13,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: borde),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: verde,
                  width: 1.5,
                ),
              ),
            ),
            icon: const Icon(
              Icons.expand_more_rounded,
              color: verde,
            ),
            items: const [
              DropdownMenuItem(
                value: 'puntos',
                child: Text('Puntuación'),
              ),
              DropdownMenuItem(
                value: 'tiempo',
                child: Text('Tiempo de finalización'),
              ),
            ],
            onChanged: (value) {
              if (value == null || value == _orden) return;

              setState(() {
                _orden = value;
                _cargando = true;
              });

              _actualizar();
            },
          ),
        ],
      ),
    );
  }

  Widget _construirEncabezado(bool cerrada) {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: verdeClaro,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: borde),
          ),
          child: Icon(
            cerrada
                ? Icons.emoji_events_rounded
                : Icons.leaderboard_rounded,
            size: 42,
            color: verde,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          cerrada ? '¡Partida finalizada!' : '¡Mira cómo va la partida!',
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: verdeOscuro,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          cerrada
              ? 'Estos son los resultados finales de tu equipo.'
              : 'Cada punto cuenta. ¡Descubre quién va ganando!',
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(
            fontSize: 14,
            color: textoSecundario,
          ),
        ),
        const SizedBox(height: 17),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: cerrada ? naranja : verdeClaro,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                cerrada
                    ? Icons.flag_rounded
                    : Icons.autorenew_rounded,
                size: 16,
                color: cerrada
                    ? const Color(0xFF98552D)
                    : verde,
              ),
              const SizedBox(width: 7),
              Text(
                cerrada ? 'Sala cerrada' : 'Actualización automática',
                style: GoogleFonts.quicksand(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: cerrada
                      ? const Color(0xFF98552D)
                      : verdeOscuro,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _construirEstadoVacio() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 32,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borde),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: verdeClaro,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.emoji_events_outlined,
              size: 38,
              color: verde,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Todavía no hay resultados',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: verdeOscuro,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Cuando los jugadores completen la partida, '
            'sus resultados aparecerán aquí.',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 13,
              color: textoSecundario,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirError() {
    if (_error == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEEE),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFF4CACA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFB3261E),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'No se pudo actualizar la clasificación:\n$_error',
              style: GoogleFonts.quicksand(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF9D2520),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Reintentar',
            onPressed: () {
              setState(() => _cargando = true);
              _actualizar();
            },
            icon: const Icon(
              Icons.refresh_rounded,
              color: Color(0xFF9D2520),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirBotones(bool cerrada) {
    if (!widget.esAnfitrion && widget.datosPartida == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borde),
        boxShadow: [
          BoxShadow(
            color: verdeOscuro.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.esAnfitrion && !cerrada)
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _cerrando ? null : _cerrarSala,
                icon: _cerrando
                    ? const SizedBox(
                        width: 19,
                        height: 19,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.lock_rounded),
                label: Text(
                  _cerrando ? 'Cerrando sala…' : 'Cerrar sala',
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: verde,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF9EBA9F),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          if (widget.esAnfitrion && !cerrada &&
              widget.datosPartida != null)
            const SizedBox(height: 10),
          if (widget.datosPartida != null)
            SizedBox(
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.go(
                    '/mygame',
                    extra: widget.datosPartida,
                  );
                },
                icon: const Icon(Icons.sports_esports_rounded),
                label: Text(
                  'Mi partida',
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: verde,
                  side: const BorderSide(
                    color: Color(0xFFB8DAB8),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cerrada = _estadoSala == 'cerrada';

    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: Column(
          children: [
            const NavBar(),

            Expanded(
              child: Stack(
                children: [
                  // Scroll de todo el contenido.
                  // La barra ocupa el ancho disponible y queda
                  // en el extremo derecho, no junto a la tarjeta.
                  Positioned.fill(
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      interactive: true,
                      thickness: 6,
                      radius: const Radius.circular(10),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 26,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 760,
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                              children: [
                                _construirEncabezado(cerrada),
                                const SizedBox(height: 25),

                                // Tarjeta principal de clasificación.
                                Container(
                                  padding: const EdgeInsets.all(22),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(26),
                                    border: Border.all(color: borde),
                                    boxShadow: [
                                      BoxShadow(
                                        color: verdeOscuro.withValues(
                                          alpha: 0.07,
                                        ),
                                        blurRadius: 25,
                                        offset: const Offset(0, 9),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: verdeClaro,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: const Icon(
                                              Icons.emoji_events_rounded,
                                              color: verde,
                                              size: 22,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Clasificación',
                                                  style:
                                                      GoogleFonts.quicksand(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w800,
                                                    color: verdeOscuro,
                                                  ),
                                                ),
                                                Text(
                                                  '${_jugadores.length} '
                                                  '${_jugadores.length == 1 ? 'jugador' : 'jugadores'} en el ranking',
                                                  style:
                                                      GoogleFonts.quicksand(
                                                    fontSize: 12,
                                                    color: textoSecundario,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 20),
                                      _construirSelectorOrden(),
                                      const SizedBox(height: 20),

                                      if (_cargando)
                                        const Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 16,
                                          ),
                                          child: LinearProgressIndicator(
                                            color: verde,
                                            backgroundColor: verdeClaro,
                                            minHeight: 3,
                                          ),
                                        ),

                                      _construirError(),

                                      if (_jugadores.isEmpty && !_cargando)
                                        _construirEstadoVacio()
                                      else
                                        ..._jugadores.asMap().entries.map(
                                          (entry) => _construirJugadorCard(
                                            entry.value,
                                            entry.key,
                                          ),
                                        ),

                                      if (_jugadores.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4,
                                          ),
                                          child: Text(
                                            '¡Seguid jugando y aprendiendo '
                                            'con EcoKids!',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.quicksand(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: textoSecundario,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 18),

                                _construirBotones(cerrada),

                                const SizedBox(height: 20),

                                Text(
                                  'EcoKids · Aprender jugando, cuidar el planeta',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: textoSecundario,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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
