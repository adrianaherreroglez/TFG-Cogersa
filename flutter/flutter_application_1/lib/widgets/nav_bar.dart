import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  static const Color themeGreen = Color(0xFF298133);
  static const Color background = Color(0xFFD8EDD5);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color borderGreen = Color(0xFFC6E3C2);

  static const double mobileBreakpoint = 700;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < mobileBreakpoint;

        return Container(
          width: double.infinity,
          height: 70,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 28),
          decoration: BoxDecoration(
            color: background,
            border: const Border(
              bottom: BorderSide(color: borderGreen, width: 1.5),
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
            children: [
              // LOGO
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

                  // El texto desaparece si no hay espacio suficiente
                  if (constraints.maxWidth >= 300)
                    Text(
                      'EcoKids',
                      style: GoogleFonts.quicksand(
                        fontSize: isMobile ? 23 : 28,
                        fontWeight: FontWeight.w800,
                        color: themeGreen,
                      ),
                    ),
                ],
              ),
              const Spacer(),

              // MÓVIL: MENÚ HAMBURGUESA
              if (isMobile)
                PopupMenuButton<String>(
                  tooltip: 'Abrir menú',
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: themeGreen,
                    size: 32,
                  ),
                  color: lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onSelected: (route) {
                    context.go(route);
                  },
                  itemBuilder: (context) => [
                    _menuItem(
                      Icons.sports_esports_rounded,
                      'Juegos',
                      '/listgame',
                    ),
                    _menuItem(
                      Icons.people_alt_rounded,
                      'Amigos',
                      '/listAmigos',
                    ),
                    _menuItem(
                      Icons.meeting_room_rounded,
                      'Salas',
                      '/crearSala',
                    ),
                    _menuItem(Icons.person_rounded, 'Perfil', '/profile'),
                  ],
                )
              // TABLET Y ORDENADOR: BOTONES VISIBLES
              else
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
      },
    );
  }

  static PopupMenuItem<String> _menuItem(
    IconData icon,
    String text,
    String route,
  ) {
    return PopupMenuItem<String>(
      value: route,
      child: Row(
        children: [
          Icon(icon, color: themeGreen, size: 22),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.quicksand(
              color: themeGreen,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// BOTONES DE NAVEGACIÓN PARA PANTALLAS GRANDES
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
