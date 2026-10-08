import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/nav_bar.dart';

class MyGame extends StatefulWidget {
  final int puntosPrevios;

  const MyGame({
    super.key,
    required this.puntosPrevios,
  });

  @override
  State<MyGame> createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFDF4),

      body: Column(
        children: [
          // BARRA DE NAVEGACIÓN
          const NavBar(),

          // CONTENIDO
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 35,
              ),
              child: Column(
                children: [

                  Text(
                    'Mi espacio de juego',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF298133),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Consulta tus puntos y tu posición en EcoKids',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF644633),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // TARJETAS
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final bool isSmallScreen =
                          constraints.maxWidth < 950;

                      if (isSmallScreen) {
                        return Column(
                          children: [
                            _buildRankingCard(),
                            const SizedBox(height: 30),
                            _buildMyGameCard(),
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildMyGameCard(),
                          ),

                          const SizedBox(width: 35),

                          Expanded(
                            child: _buildRankingCard(),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  // MI PARTIDA
  Widget _buildMyGameCard() {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 390,
      ),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFD8EDD5),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // ICONO
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: const Color(0xFFD8EDD5),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.sports_esports_rounded,
              size: 42,
              color: Color(0xFF298133),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Mi partida',
            style: GoogleFonts.quicksand(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF298133),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Tu progreso en EcoKids',
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF644633),
            ),
          ),

          const SizedBox(height: 30),

          // PUNTOS
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF3FAEF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  'PUNTOS',
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: const Color(0xFF644633),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '${widget.puntosPrevios}',
                  style: GoogleFonts.quicksand(
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF298133),
                  ),
                ),

                Text(
                  'puntos conseguidos',
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF644633),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // PEQUEÑA INFORMACIÓN
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.eco_rounded,
                color: Color(0xFF298133),
                size: 22,
              ),

              const SizedBox(width: 8),

              Text(
                '¡Sigue aprendiendo y cuidando el planeta!',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF644633),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  // CLASIFICACIÓN
  Widget _buildRankingCard() {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 390,
      ),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFD8EDD5),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // ICONO
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: const Color(0xFFD8EDD5),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              size: 42,
              color: Color(0xFF298133),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Clasificación',
            style: GoogleFonts.quicksand(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF298133),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Los mejores jugadores',
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF644633),
            ),
          ),

          const SizedBox(height: 25),

          // JUGADORES
          _rankingRow(
            position: '1',
            name: 'Jugador 1',
            points: 120,
            icon: Icons.emoji_events,
          ),

          const SizedBox(height: 10),

          _rankingRow(
            position: '2',
            name: 'Jugador 2',
            points: 100,
            icon: Icons.emoji_events,
          ),

          const SizedBox(height: 10),

          _rankingRow(
            position: '3',
            name: 'Jugador 3',
            points: 80,
            icon: Icons.emoji_events,
          ),
        ],
      ),
    );
  }


  // FILA DEL RANKING
  Widget _rankingRow({
    required String position,
    required String name,
    required int points,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF3FAEF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFD8EDD5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                position,
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF298133),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Icon(
            icon,
            size: 21,
            color: const Color(0xFF298133),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              name,
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF644633),
              ),
            ),
          ),

          Text(
            '$points pts',
            style: GoogleFonts.quicksand(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF298133),
            ),
          ),
        ],
      ),
    );
  }
}
