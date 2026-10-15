import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/services/salas_service.dart';
import 'package:flutter_application_1/widgets/nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';



class ListPlayersGame extends StatefulWidget {
  final int salaId;

  const ListPlayersGame({
    super.key,
    required this.salaId,
  });

  @override
  State<ListPlayersGame> createState() => _ListPlayersGameState();
}

class _ListPlayersGameState extends State<ListPlayersGame> {
  final SalasService _salasService = SalasService();

  Timer? _timer;

  Map<String, dynamic>? _datos;
  bool _cargando = true;
  bool _iniciando = false;
  bool _navegandoAlJuego = false;

  String? _error;

  @override
  void initState() {
    super.initState();

    _cargarSala();

    // Todos consultan el estado para saber cuándo comienza la partida.
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _cargarSala(),
    );
  }

  Future<void> _cargarSala() async {
    if (!mounted || _navegandoAlJuego) return;

    try {
      final datos = await _salasService.obtenerSala(widget.salaId);

      if (!mounted) return;

      setState(() {
        _datos = datos;
        _error = null;
        _cargando = false;
      });

      final sala = datos['sala'] is Map
          ? Map<String, dynamic>.from(datos['sala'])
          : datos;

      if (sala['estado']?.toString() == 'jugando') {
        _abrirPrimerNivel(sala);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _cargando = false;
      });
    }
  }

  void _abrirPrimerNivel(Map<String, dynamic> sala) {
    if (!mounted || _navegandoAlJuego) return;

    _navegandoAlJuego = true;
    _timer?.cancel();

    final juegoId = int.tryParse(sala['juego_id'].toString());

    String? ruta;

    // Comprueba que estos ID coincidan con los de tu base de datos.
    switch (juegoId) {
      case 1:
        ruta = '/first';
        break;
      case 2:
        ruta = '/fillGaps/first';
        break;
      case 3:
        ruta = '/puntolimpio/firstlevel';
        break;
      case 4:
        ruta = '/puntolimpio/fillGaps/firstlevel';
        break;
      default:
        _navegandoAlJuego = false;
        _error = 'No se reconoce el juego seleccionado.';
        return;
    }

    context.go(ruta);
  }

  Future<void> _iniciarSala() async {
    if (_iniciando) return;

    setState(() {
      _iniciando = true;
      _error = null;
    });

    try {
      await _salasService.iniciarSala(widget.salaId);

      // La consulta periódica detectará el estado "jugando".
      await _cargarSala();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _iniciando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const verde = Color(0xFF2E7D32);
    const verdeOscuro = Color(0xFF23442A);
    const fondo = Color(0xFFF5F8F2);

    final datos = _datos;

    final sala = datos?['sala'] is Map
        ? Map<String, dynamic>.from(datos!['sala'])
        : datos;

    final miembrosRaw = datos?['miembros'];

    final miembros = miembrosRaw is List
        ? miembrosRaw
            .whereType<Map>()
            .map((m) => Map<String, dynamic>.from(m))
            .toList()
        : <Map<String, dynamic>>[];

    final esAnfitrion = datos?['es_anfitrion'] == true;

    final codigo = sala?['codigo']?.toString() ?? '--------';

    final maxJugadores =
        int.tryParse(sala?['num_jugadores']?.toString() ?? '') ?? 0;

    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: Column(
          children: [
            const NavBar(),
            Expanded(
              child: _cargando
                  ? const Center(
                      child: CircularProgressIndicator(color: verde),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 12),
                              Text(
                                'Sala de juego',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                  color: verdeOscuro,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Comparte el código con tus compañeros',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Tarjeta con el código de la sala.
                              Container(
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withValues(
                                        alpha: 0.08,
                                      ),
                                      blurRadius: 16,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'CÓDIGO DE LA SALA',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.5,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: SelectableText(
                                            codigo,
                                            style: GoogleFonts.poppins(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 4,
                                              color: verde,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: 'Copiar código',
                                          onPressed: () {
                                            Clipboard.setData(
                                              ClipboardData(text: codigo),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Código copiado',
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.copy_rounded,
                                            color: verde,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Lista de jugadores conectados.
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.groups_rounded,
                                          color: verde,
                                          size: 28,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'Jugadores',
                                            style: GoogleFonts.poppins(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                              color: verdeOscuro,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          maxJugadores > 0
                                              ? '${miembros.length}/$maxJugadores'
                                              : '${miembros.length}',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: verde,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),

                                    if (miembros.isEmpty)
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Text(
                                          'Todavía no hay jugadores en la sala.',
                                        ),
                                      )
                                    else
                                      ...miembros.map((miembro) {
                                        final nombre =
                                            miembro['nombre']?.toString() ??
                                            miembro['username']?.toString() ??
                                            'Jugador';

                                        final esHostMiembro =
                                            miembro['es_anfitrion'] == true;

                                        return Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: fondo,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: Row(
                                            children: [
                                              const CircleAvatar(
                                                backgroundColor:
                                                    Color(0xFFD9EEDB),
                                                child: Icon(
                                                  Icons.person,
                                                  color: verde,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  nombre,
                                                  style: GoogleFonts.poppins(
                                                    fontWeight:
                                                        FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              if (esHostMiembro)
                                                Container(
                                                  padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 10,
                                                    vertical: 5,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFFD9EEDB,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Anfitrión',
                                                    style:
                                                        GoogleFonts.poppins(
                                                      fontSize: 11,
                                                      color: verde,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      }),
                                  ],
                                ),
                              ),

                              if (_error != null) ...[
                                const SizedBox(height: 16),
                                Text(
                                  _error!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                ),
                                TextButton(
                                  onPressed: _cargarSala,
                                  child: const Text('Reintentar'),
                                ),
                              ],

                              const SizedBox(height: 24),

                              // El anfitrión puede iniciar; los demás esperan.
                              if (esAnfitrion)
                                SizedBox(
                                  height: 54,
                                  child: ElevatedButton.icon(
                                    onPressed: _iniciando
                                        ? null
                                        : _iniciarSala,
                                    icon: _iniciando
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.play_arrow_rounded,
                                          ),
                                    label: Text(
                                      _iniciando
                                          ? 'Iniciando partida...'
                                          : 'Iniciar partida',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: verde,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F5E9),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      const CircularProgressIndicator(
                                        color: verde,
                                      ),
                                      const SizedBox(height: 14),
                                      Text(
                                        'Esperando al anfitrión...',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: verdeOscuro,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'La partida comenzará cuando el anfitrión pulse Iniciar partida.',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              const SizedBox(height: 20),
                            ],
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