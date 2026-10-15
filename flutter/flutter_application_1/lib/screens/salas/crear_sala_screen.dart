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

  final TextEditingController _codigoController = TextEditingController();

  // Juego seleccionado. Debe coincidir con un ID real de la tabla juegos.
  int juegoSeleccionado = 1;

  // Número de jugadores de la sala.
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
            '¡Sala creada! Código: ${sala['codigo'] ?? _codigoController.text}';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        salaCreadaCorrectamente = false;
        mensajeResultado = e.toString().replaceFirst('Exception: ', '');
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
        Icon(icono, color: verdePrincipal, size: 23),
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

  Widget _construirTarjeta({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFDDEEDB), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NavBar(),
              const SizedBox(height: 14),
              // Encabezado
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDF3D8),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.meeting_room_rounded,
                        color: Color(0xFF388E3C),
                        size: 52,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '¡Crea tu sala!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF285C32),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'Elige un juego e invita a tus amigos a aprender jugando.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Código de la sala
              _construirTarjeta(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 5,
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
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xFFC8E6C9),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 17,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Este código se genera automáticamente al entrar. '
                      'Se guardará cuando crees la sala.',
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Selección del juego
              _construirTarjeta(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _construirEtiqueta(
                      'Selecciona un juego',
                      Icons.sports_esports_rounded,
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<int>(
                      value: juegoSeleccionado,
                      isExpanded: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF8FBF6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xFFDDEEDB),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xFFDDEEDB),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 1,
                          child: Text('Reciclaje - Drag & Drop'),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text('Reciclaje - Fill in the Gaps'),
                        ),
                        DropdownMenuItem(
                          value: 3,
                          child: Text('Punto Limpio - Drag & Drop'),
                        ),
                        DropdownMenuItem(
                          value: 4,
                          child: Text('Punto Limpio - Fill in the Gaps'),
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
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF31543A),
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Número de jugadores
              _construirTarjeta(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _construirEtiqueta(
                      'Número máximo de jugadores',
                      Icons.people_alt_rounded,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Jugadores',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: verdeClaro,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            '$numJugadores',
                            style: GoogleFonts.quicksand(
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF2E7D32),
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
                      inactiveColor: const Color(0xFFDDEEDB),
                      label: '$numJugadores',
                      onChanged: creandoSala
                          ? null
                          : (valor) {
                              setState(() {
                                numJugadores = valor.round();
                              });
                            },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Botón para crear la sala y mensaje
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: creandoSala ? null : _crearSala,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: verdePrincipal,
                      disabledBackgroundColor: Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: creandoSala
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.add_circle_outline_rounded,
                                size: 20,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                'Crear sala',
                                style: GoogleFonts.quicksand(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                  ),

                  const SizedBox(width: 12),

                  // Mensaje a la derecha del botón
                  if (mensajeResultado != null)
                    Flexible(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: salaCreadaCorrectamente
                                ? const Color(0xFFE8F5E9)
                                : const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                salaCreadaCorrectamente
                                    ? Icons.check_circle_rounded
                                    : Icons.error_outline_rounded,
                                size: 17,
                                color: salaCreadaCorrectamente
                                    ? Colors.green
                                    : Colors.redAccent,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  mensajeResultado!,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: salaCreadaCorrectamente
                                        ? const Color(0xFF2E7D32)
                                        : Colors.redAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
