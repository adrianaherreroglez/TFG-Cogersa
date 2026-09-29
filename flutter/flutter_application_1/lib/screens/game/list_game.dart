import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/nav_bar.dart';

class ListGame extends StatefulWidget {
  const ListGame({super.key});

  @override
  State<ListGame> createState() => _ListGameState();
}

class _ListGameState extends State<ListGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFDF4),
      body: Column(
        children: [
          const NavBar(),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 45,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¿A qué contenedor lo tirarías?',
                      style: GoogleFonts.quicksand(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF298133),
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '¡Elige un juego y demuestra cuánto sabes reciclar!',
                      style: GoogleFonts.quicksand(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF5D7A61),
                      ),
                    ),

                    const SizedBox(height: 35),

                    Wrap(
                      spacing: 30,
                      runSpacing: 30,
                      children: [
                        GameCard(
                          image: 'assets/icons/app/reciclaje.png',
                          title: 'RECICLAJE',
                          gameType: 'Drag & Drop',
                          onTap: () {
                            context.go('/first');
                          },
                        ),

                        GameCard(
                          image: 'assets/icons/app/reciclaje.png',
                          title: 'RECICLAJE',
                          gameType: 'Fill in the Gaps',
                          onTap: () {
                            context.go('/fillGaps/first');
                          },
                        ),

                        GameCard(
                          image: 'assets/icons/app/punto-limpio.png',
                          title: 'PUNTO LIMPIO',
                          gameType: 'Drag & Drop',
                          onTap: () {
                            context.go('/puntolimpio/firstlevel');
                          },
                        ),

                        GameCard(
                          image: 'assets/icons/app/punto-limpio.png',
                          title: 'PUNTO LIMPIO',
                          gameType: 'Fill in the Gaps',
                          onTap: () {
                            context.go('/puntolimpio/firstlevel');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GameCard extends StatefulWidget {
  final String image;
  final String title;
  final String gameType;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.image,
    required this.title,
    required this.gameType,
    required this.onTap,
  });

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 230,
          height: 260,
          transform: Matrix4.translationValues(
            0,
            isHovered ? -6 : 0,
            0,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFD8EDD5),
              width: 1.5,
            ),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.14),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 18,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  widget.image,
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 15),

                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF298133),
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8EDD5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.gameType,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF298133),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}