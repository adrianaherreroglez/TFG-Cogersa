import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/game/service/datos_partida.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/nav_bar.dart';

class MyGame extends StatefulWidget {
  const MyGame({super.key, required this.datosPartida});

  final DatosPartida datosPartida;

  @override
  State<MyGame> createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> {
  static const Color _verde = Color(0xFF298133);
  static const Color _marron = Color(0xFF644633);
  static const Color _fondo = Color(0xFFFAFDF4);
  static const Color _verdeClaro = Color(0xFFF3FAEF);
  static const Color _borde = Color(0xFFD8EDD5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondo,
      body: Column(
        children: [
          const NavBar(),

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 760,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Mi espacio de juego',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              fontSize:
                                  constraints.maxWidth < 600 ? 30 : 36,
                              fontWeight: FontWeight.w800,
                              color: _verde,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            'Consulta tus puntos y tu posición en EcoKids',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: _marron,
                            ),
                          ),

                          const SizedBox(height: 24),

                          _buildMyGameCard(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // TARJETA PRINCIPAL
  Widget _buildMyGameCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 650),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _borde,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ICONO
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: _borde,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.sports_esports_rounded,
              size: 32,
              color: _verde,
            ),
          ),

          const SizedBox(height: 12),

          // TÍTULO
          Text(
            'Mi partida',
            style: GoogleFonts.quicksand(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: _verde,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Tu progreso en EcoKids',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _marron,
            ),
          ),

          const SizedBox(height: 20),

          // ESTADÍSTICAS
          LayoutBuilder(
            builder: (context, constraints) {
              final bool horizontal = constraints.maxWidth >= 480;

              final puntos = _buildStatCard(
                titulo: 'PUNTOS',
                valor: '${widget.datosPartida.puntos}',
                descripcion: 'puntos conseguidos',
                icono: Icons.stars_rounded,
              );

              final tiempo = _buildStatCard(
                titulo: 'TIEMPO',
                valor:
                    '${widget.datosPartida.cronometro.elapsed.inSeconds}',
                descripcion: 'segundos',
                icono: Icons.timer_rounded,
              );

              final intentos = _buildStatCard(
                titulo: 'INTENTOS',
                valor: '${widget.datosPartida.intentos}',
                descripcion: 'intentos',
                icono: Icons.replay_rounded,
              );

              if (horizontal) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: puntos),
                    const SizedBox(width: 12),
                    Expanded(child: tiempo),
                    const SizedBox(width: 12),
                    Expanded(child: intentos),
                  ],
                );
              }

              return Column(
                children: [
                  puntos,
                  const SizedBox(height: 12),
                  tiempo,
                  const SizedBox(height: 12),
                  intentos,
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          // VOLVER A JUEGOS
          Center(
            child: TextButton.icon(
              onPressed: () {
                context.go('/listgame');
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: _verde,
                size: 20,
              ),
              label: Text(
                'Volver a Juegos',
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _verde,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                foregroundColor: _verde,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TARJETAS DE ESTADÍSTICAS
  Widget _buildStatCard({
    required String titulo,
    required String valor,
    required String descripcion,
    required IconData icono,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: _verdeClaro,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _borde,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icono,
            size: 22,
            color: _verde,
          ),

          const SizedBox(height: 6),

          Text(
            titulo,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: _marron,
            ),
          ),

          const SizedBox(height: 4),

          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              valor,
              style: GoogleFonts.quicksand(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: _verde,
              ),
            ),
          ),

          const SizedBox(height: 2),

          Text(
            descripcion,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _marron,
            ),
          ),
        ],
      ),
    );
  }
}
