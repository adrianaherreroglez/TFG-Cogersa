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
  final String rutaJuego;

  const ListPlayersGame({
    super.key,
    required this.salaId,
    required this.rutaJuego,
  });

  @override
  State<ListPlayersGame> createState() => _ListPlayersGameState();
}

class _ListPlayersGameState extends State<ListPlayersGame> {
  final SalasService _salasService = SalasService();
  final ScrollController _scrollController = ScrollController();

  Timer? _timer;

  bool _cargando = true;
  bool _iniciando = false;
  bool _navegando = false;

  String? _error;
  String _estado = 'esperando';
  String _codigo = '';

  bool _esAnfitrion = false;
  int _maxJugadores = 10;

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
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _actualizarSala() async {
    if (_navegando) return;

    try {
      final data = await _salasService.obtenerSala(widget.salaId);

      if (!mounted || _navegando) return;

      final sala = Map<String, dynamic>.from(data['sala'] ?? data);

      final miembros = List<Map<String, dynamic>>.from(
        (data['miembros'] as List? ?? []).map(
          (m) => Map<String, dynamic>.from(m),
        ),
      );

      final estado = sala['estado']?.toString() ?? 'esperando';

      // Capacidad máxima de jugadores devuelta por el backend.
      final maxJugadores = int.tryParse(
        sala['num_jugadores']?.toString() ?? '',
      );

      setState(() {
        _codigo = sala['codigo']?.toString() ?? '';
        _estado = estado;

        _maxJugadores = maxJugadores ?? _maxJugadores;
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

      // El anfitrión no juega.
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

    context.go(
      widget.rutaJuego,
      extra: {
        'salaId': widget.salaId,
        'esAnfitrion': _esAnfitrion,
        'datosPartida': datosPartida,
      },
    );
  }

  Future<void> _copiarCodigo() async {
    await Clipboard.setData(ClipboardData(text: _codigo));

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Código copiado')));
  }

  @override
  Widget build(BuildContext context) {
    const verde = Color(0xFF298133);
    const verdeOscuro = Color(0xFF285C32);
    const verdeClaro = Color(0xFFE8F5E9);
    const fondo = Color(0xFFFAFDF4);

    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: Column(
          children: [
            const NavBar(),

            Expanded(
              child: _cargando
                  ? const Center(child: CircularProgressIndicator(color: verde))
                  : Stack(
                      children: [
                        // Contenido desplazable.
                        Positioned.fill(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 24,
                            ),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 650,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // ENCABEZADO
                                    const Icon(
                                      Icons.groups_rounded,
                                      size: 44,
                                      color: verde,
                                    ),
                                    const SizedBox(height: 10),

                                    Text(
                                      '¡Preparados para jugar!',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                        fontSize: 29,
                                        fontWeight: FontWeight.w800,
                                        color: verdeOscuro,
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    Text(
                                      _esAnfitrion
                                          ? 'Tu sala está lista. Invita a tus amigos.'
                                          : 'Únete a tus compañeros y prepárate.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // TARJETA PRINCIPAL
                                    Container(
                                      padding: const EdgeInsets.all(22),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: const Color(0xFFDDEEDB),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: verde.withValues(
                                              alpha: 0.08,
                                            ),
                                            blurRadius: 24,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          // ESTADO DE LA SALA
                                          Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF4CAF50),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  _estado == 'esperando'
                                                      ? 'Sala esperando jugadores'
                                                      : _estado == 'jugando'
                                                      ? 'Partida en curso'
                                                      : 'Sala finalizada',
                                                  style: GoogleFonts.quicksand(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color: verdeOscuro,
                                                  ),
                                                ),
                                              ),
                                              if (_esAnfitrion)
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 6,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFFFFF3CD,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Icon(
                                                        Icons.workspace_premium,
                                                        size: 15,
                                                        color: Color(
                                                          0xFF9A7200,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        'Anfitrión',
                                                        style:
                                                            GoogleFonts.quicksand(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color:
                                                                  const Color(
                                                                    0xFF8A6700,
                                                                  ),
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),

                                          const SizedBox(height: 22),

                                          // CÓDIGO DE LA SALA
                                          Container(
                                            padding: const EdgeInsets.all(18),
                                            decoration: BoxDecoration(
                                              color: verdeClaro,
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              border: Border.all(
                                                color: const Color(0xFFC8E6C9),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.key_rounded,
                                                      color: verde,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 7),
                                                    Text(
                                                      'CÓDIGO DE LA SALA',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            letterSpacing: 1,
                                                            color: verdeOscuro,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                      child: SelectableText(
                                                        _codigo.isEmpty
                                                            ? '------'
                                                            : _codigo,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.quicksand(
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              letterSpacing: 4,
                                                              color: verde,
                                                            ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    IconButton(
                                                      tooltip: 'Copiar código',
                                                      onPressed: _codigo.isEmpty
                                                          ? null
                                                          : _copiarCodigo,
                                                      style:
                                                          IconButton.styleFrom(
                                                            backgroundColor:
                                                                Colors.white,
                                                            foregroundColor:
                                                                verde,
                                                          ),
                                                      icon: const Icon(
                                                        Icons.copy_rounded,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Comparte este código con tus compañeros.',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.quicksand(
                                                    fontSize: 12,
                                                    color: const Color(
                                                      0xFF527357,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          const SizedBox(height: 24),
                                          const Divider(
                                            color: Color(0xFFE8F0E6),
                                          ),
                                          const SizedBox(height: 18),

                                          // LISTA DE JUGADORES
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: verdeClaro,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Icon(
                                                  Icons.people_alt_rounded,
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
                                                      'Jugadores',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color: verdeOscuro,
                                                          ),
                                                    ),
                                                    Text(
                                                      'Personas en la sala',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: verdeClaro,
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: Text(
                                                  '${_miembros.length}/$_maxJugadores',
                                                  style: GoogleFonts.quicksand(
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.w800,
                                                    color: verde,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 14),

                                          if (_miembros.isEmpty)
                                            Container(
                                              padding: const EdgeInsets.all(22),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF8FBF6),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFE5EEE2,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .person_add_alt_1_rounded,
                                                    size: 34,
                                                    color: Color(0xFF81A985),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    'Todavía no hay jugadores',
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        GoogleFonts.quicksand(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: verdeOscuro,
                                                        ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Comparte el código para que se unan.',
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        GoogleFonts.quicksand(
                                                          fontSize: 12,
                                                          color: Colors.black54,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          else
                                            ..._miembros.map((miembro) {
                                              final esAnfitrion =
                                                  miembro['es_anfitrion'] ==
                                                  true;
                                              final nombre =
                                                  miembro['nombre']
                                                      ?.toString() ??
                                                  'Jugador';

                                              return Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 10,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 12,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFF8FBF6,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: esAnfitrion
                                                        ? const Color(
                                                            0xFFC8E6C9,
                                                          )
                                                        : const Color(
                                                            0xFFEDF2EA,
                                                          ),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 22,
                                                      backgroundColor:
                                                          esAnfitrion
                                                          ? const Color(
                                                              0xFFFFF0C2,
                                                            )
                                                          : const Color(
                                                              0xFFD8EDD5,
                                                            ),
                                                      child: Icon(
                                                        esAnfitrion
                                                            ? Icons
                                                                  .workspace_premium_rounded
                                                            : Icons
                                                                  .person_rounded,
                                                        color: esAnfitrion
                                                            ? const Color(
                                                                0xFF9A7200,
                                                              )
                                                            : verde,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Text(
                                                        nombre,
                                                        style:
                                                            GoogleFonts.quicksand(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  verdeOscuro,
                                                            ),
                                                      ),
                                                    ),
                                                    if (esAnfitrion)
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 9,
                                                              vertical: 5,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: verdeClaro,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                20,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          'Anfitrión',
                                                          style:
                                                              GoogleFonts.quicksand(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: verde,
                                                              ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              );
                                            }),

                                          // ESPERA DEL PARTICIPANTE
                                          if (_estado == 'esperando' &&
                                              !_esAnfitrion) ...[
                                            const SizedBox(height: 12),
                                            Container(
                                              padding: const EdgeInsets.all(14),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF1F8E9),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: verde,
                                                        ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      'Esperando al anfitrión para comenzar…',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: verdeOscuro,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],

                                          // ERRORES
                                          if (_error != null) ...[
                                            const SizedBox(height: 14),
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFFEBEE),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    Icons.error_outline_rounded,
                                                    color: Colors.redAccent,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      _error!,
                                                      style:
                                                          GoogleFonts.quicksand(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .redAccent,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],

                                          // INICIAR PARTIDA
                                          if (_esAnfitrion &&
                                              _estado == 'esperando') ...[
                                            const SizedBox(height: 22),
                                            SizedBox(
                                              width: double.infinity,
                                              height: 52,
                                              child: ElevatedButton(
                                                onPressed: _iniciando
                                                    ? null
                                                    : _iniciarPartida,
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: verde,
                                                  disabledBackgroundColor:
                                                      Colors.grey.shade400,
                                                  foregroundColor: Colors.white,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                  ),
                                                ),
                                                child: _iniciando
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child:
                                                                CircularProgressIndicator(
                                                                  color: Colors
                                                                      .white,
                                                                  strokeWidth:
                                                                      2,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            'Iniciando partida…',
                                                            style:
                                                                GoogleFonts.quicksand(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                ),
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .play_arrow_rounded,
                                                            size: 24,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Text(
                                                            'Iniciar partida',
                                                            style:
                                                                GoogleFonts.quicksand(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 16),
                                    Text(
                                      'La lista de jugadores se actualiza automáticamente.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                        fontSize: 11,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Scrollbar pegado al borde derecho.
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 0,
                          child: Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            interactive: true,
                            thickness: 6,
                            radius: const Radius.circular(10),
                            child: const SizedBox(width: 1, height: 1),
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
