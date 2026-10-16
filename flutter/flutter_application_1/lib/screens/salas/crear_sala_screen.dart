
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/nav_bar.dart';
import '../../services/salas_service.dart';

class CrearSalaPage extends StatefulWidget {
  const CrearSalaPage({super.key});

  @override
  State<CrearSalaPage> createState() => _CrearSalaPageState();
}

class _CrearSalaPageState extends State<CrearSalaPage> {
  final SalasService _salasService = SalasService();

  final TextEditingController _codigoController =
      TextEditingController();

  final ScrollController _scrollController = ScrollController();

  // Juego seleccionado. Coincide con un ID real de la tabla juegos.
  int juegoSeleccionado = 1;

  // Número máximo de jugadores.
  int numJugadores = 10;

  bool creandoSala = false;
  String? mensajeResultado;
  bool salaCreadaCorrectamente = false;

  final Color verdePrincipal = const Color(0xFF4CAF50);
  final Color verdeClaro = const Color(0xFFE8F5E9);
  final Color fondo = const Color(0xFFF7FAF3);

  @override
  void initState() {
    super.initState();

    // Generamos el código al entrar en la página.
    _codigoController.text = _salasService.generarCodigo();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  Future<void> _crearSala() async {
    if (creandoSala) return;

    setState(() {
      creandoSala = true;
      mensajeResultado = null;
    });

    try {
      final sala = await _salasService.crearSala(
        codigo: _codigoController.text,
        juegoId: juegoSeleccionado,
        numJugadores: numJugadores,
      );

      if (!mounted) return;

      setState(() {
        salaCreadaCorrectamente = true;
        mensajeResultado =
            '¡Sala creada! Código: '
            '${sala['codigo'] ?? _codigoController.text}';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        salaCreadaCorrectamente = false;
        mensajeResultado =
            e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          creandoSala = false;
        });
      }
    }
  }

  Widget _construirEtiqueta(String texto, IconData icono) {
    return Row(
      children: [
        Icon(
          icono,
          color: verdePrincipal,
          size: 23,
        ),
        const SizedBox(width: 8),
        Text(
          texto,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF31543A),
          ),
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: Column(
          children: [
            const NavBar(),

            Expanded(
              child: Stack(
                children: [
                  // Contenido desplazable.
                  // El formulario permanece centrado.
                  Positioned.fill(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 620,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                            children: [
                              // Encabezado.
                              Icon(
                                Icons.meeting_room_rounded,
                                color: verdePrincipal,
                                size: 42,
                              ),
                              const SizedBox(height: 8),

                              Text(
                                '¡Crea tu sala!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF285C32),
                                ),
                              ),
                              const SizedBox(height: 6),

                              Text(
                                'Configura tu partida e invita '
                                'a tus amigos.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Tarjeta principal.
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(24),
                                  border: Border.all(
                                    color: const Color(0xFFDDEEDB),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withValues(
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
                                    // Código de la sala.
                                    _construirEtiqueta(
                                      'Código de la sala',
                                      Icons.vpn_key_rounded,
                                    ),
                                    const SizedBox(height: 12),

                                    TextField(
                                      controller: _codigoController,
                                      readOnly: true,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 4,
                                        color: const Color(0xFF2E7D32),
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: verdeClaro,
                                        suffixIcon: const Icon(
                                          Icons.lock_outline_rounded,
                                          color: Color(0xFF4CAF50),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    Text(
                                      'Se genera automáticamente y se '
                                      'guardará al crear la sala.',
                                      style: GoogleFonts.quicksand(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),

                                    const SizedBox(height: 24),
                                    const Divider(
                                      color: Color(0xFFE8F0E6),
                                    ),
                                    const SizedBox(height: 20),

                                    // Selección del juego.
                                    _construirEtiqueta(
                                      'Selecciona un juego',
                                      Icons.sports_esports_rounded,
                                    ),
                                    const SizedBox(height: 12),

                                    DropdownButtonFormField<int>(
                                      initialValue: juegoSeleccionado,
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor:
                                            const Color(0xFFF8FBF6),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 14,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFDDEEDB),
                                          ),
                                        ),
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                          value: 1,
                                          child: Text(
                                            'Reciclaje - Drag & Drop',
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: 2,
                                          child: Text(
                                            'Reciclaje - Fill in the Gaps',
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: 3,
                                          child: Text(
                                            'Punto Limpio - Drag & Drop',
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: 4,
                                          child: Text(
                                            'Punto Limpio - Fill in the Gaps',
                                          ),
                                        ),
                                      ],
                                      onChanged: creandoSala
                                          ? null
                                          : (valor) {
                                              if (valor == null) return;

                                              setState(() {
                                                juegoSeleccionado = valor;
                                              });
                                            },
                                    ),

                                    const SizedBox(height: 24),
                                    const Divider(
                                      color: Color(0xFFE8F0E6),
                                    ),
                                    const SizedBox(height: 20),

                                    // Número de jugadores.
                                    _construirEtiqueta(
                                      'Número máximo de jugadores',
                                      Icons.people_alt_rounded,
                                    ),
                                    const SizedBox(height: 16),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Jugadores',
                                          style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: verdeClaro,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '$numJugadores',
                                            style: GoogleFonts.quicksand(
                                              fontSize: 21,
                                              fontWeight: FontWeight.w800,
                                              color: const Color(
                                                0xFF2E7D32,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Slider(
                                      value: numJugadores.toDouble(),
                                      min: 2,
                                      max: 100,
                                      divisions: 98,
                                      activeColor: verdePrincipal,
                                      inactiveColor:
                                          const Color(0xFFDDEEDB),
                                      label: '$numJugadores',
                                      onChanged: creandoSala
                                          ? null
                                          : (valor) {
                                              setState(() {
                                                numJugadores =
                                                    valor.round();
                                              });
                                            },
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '2 jugadores',
                                          style: GoogleFonts.quicksand(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          '100 jugadores',
                                          style: GoogleFonts.quicksand(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 24),

                                    // Botón para crear la sala.
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: creandoSala
                                            ? null
                                            : _crearSala,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: verdePrincipal,
                                          foregroundColor: Colors.white,
                                          disabledBackgroundColor:
                                              Colors.grey.shade400,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                        ),
                                        child: creandoSala
                                            ? const SizedBox(
                                                width: 22,
                                                height: 22,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : Text(
                                                'Crear sala',
                                                style:
                                                    GoogleFonts.quicksand(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.w800,
                                                ),
                                              ),
                                      ),
                                    ),

                                    // Mensaje de resultado.
                                    if (mensajeResultado != null) ...[
                                      const SizedBox(height: 14),
                                      Container(
                                        padding:
                                            const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color:
                                              salaCreadaCorrectamente
                                                  ? const Color(0xFFE8F5E9)
                                                  : const Color(0xFFFFEBEE),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              salaCreadaCorrectamente
                                                  ? Icons
                                                      .check_circle_rounded
                                                  : Icons
                                                      .error_outline_rounded,
                                              color:
                                                  salaCreadaCorrectamente
                                                      ? const Color(
                                                          0xFF2E7D32,
                                                        )
                                                      : Colors.redAccent,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                mensajeResultado!,
                                                style:
                                                    GoogleFonts.quicksand(
                                                  fontSize: 13,
                                                  fontWeight:
                                                      FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Barra de desplazamiento en el borde derecho.
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    child: IgnorePointer(
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        thickness: 6,
                        radius: const Radius.circular(10),
                        child: const SizedBox(
                          width: 1,
                          height: 1,
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
