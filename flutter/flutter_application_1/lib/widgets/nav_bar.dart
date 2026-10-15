
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  static const Color themeGreen = Color(0xFF298133);
  static const Color background = Color(0xFFD8EDD5);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color borderGreen = Color(0xFFC6E3C2);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 28),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LOGO ECOKIDS A LA IZQUIERDA
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: lightGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.eco_rounded,
                  color: themeGreen,
                  size: 25,
                ),
              ),
              const SizedBox(width: 8),
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

          // NAVEGACIÓN A LA DERECHA
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NavButton(
                icon: Icons.sports_esports_rounded,
                text: 'Juegos',
                onPressed: () => context.go('/listgame'),
              ),
              const SizedBox(width: 10),
              _NavButton(
                icon: Icons.people_alt_rounded,
                text: 'Amigos',
                onPressed: () => context.go('/listAmigos'),
              ),
               const SizedBox(width: 10),
               _NavButton(
                icon: Icons.meeting_room_rounded,
                text: 'Salas',
                onPressed: () => context.go('/crearSala'),
              ),
              const SizedBox(width: 10),
              _NavButton(
                icon: Icons.person_rounded,
                text: 'Perfil',
                onPressed: () => context.go('/profile'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// BOTONES DE NAVEGACIÓN
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
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: NavBar.lightGreen,
        foregroundColor: NavBar.themeGreen,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 21),
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
