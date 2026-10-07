import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeGreen = const Color(0xFF298133);
    final background = const Color(0xFFD8EDD5);
    final lightGreen = const Color(0xFFE8F5E9);

    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: background,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFD8EDD5),
            width: 1.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Row(
          children: [
            // LOGO
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: lightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.eco_rounded,
                    color: themeGreen,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 10),

                Text(
                  'EcoKids',
                  style: GoogleFonts.quicksand(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: themeGreen,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // INICIO
            _NavButton(
              icon: Icons.home_rounded,
              text: 'Inicio',
              onPressed: () {
                context.go('/');
              },
            ),

            const SizedBox(width: 10),

            // JUEGOS
            _NavButton(
              icon: Icons.sports_esports_rounded,
              text: 'Juegos',
              onPressed: () {
                context.go('/listgame');
              },
            ),

            const SizedBox(width: 10),

            // SALAS
            _NavButton(
              icon: Icons.meeting_room_rounded,
              text: 'Salas',
              onPressed: () {
                context.go('/salas');
              },
            ),

            const SizedBox(width: 10),

            // AMIGOS
            _NavButton(
              icon: Icons.people_alt_rounded,
              text: 'Amigos',
              onPressed: () {
                context.go('/listAmigos');
              },
            ),
          ],
        ),
      ),
    );
  }
}


class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final themeGreen = const Color(0xFF298133);
    final lightGreen = const Color(0xFFE8F5E9);

    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(lightGreen),
        foregroundColor: WidgetStateProperty.all(themeGreen),

        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),

        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 21,
          ),

          const SizedBox(width: 7),

          Text(
            text,
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

