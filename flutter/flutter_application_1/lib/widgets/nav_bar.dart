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
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool esMovil = constraints.maxWidth < 650;

        return Container(
          width: double.infinity,
          height: 70,
          padding: EdgeInsets.symmetric(
            horizontal: esMovil ? 12 : 28,
          ),
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
            children: [
              // LOGO ECOKIDS
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: esMovil ? 36 : 42,
                      height: esMovil ? 36 : 42,
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
                    Flexible(
                      child: Text(
                        'EcoKids',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          fontSize: esMovil ? 21 : 28,
                          fontWeight: FontWeight.w800,
                          color: themeGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // NAVEGACIÓN PARA PANTALLAS GRANDES
              if (!esMovil) ...[
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
                  icon: Icons.person_rounded,
                  text: 'Perfil',
                  onPressed: () => context.go('/profile'),
                ),
              ] else ...[
                // MENÚ DESPLEGABLE PARA MÓVILES
                PopupMenuButton<String>(
                  tooltip: 'Abrir menú',
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: themeGreen,
                    size: 30,
                  ),
                  color: lightGreen,
                  elevation: 8,
                  surfaceTintColor: Colors.transparent,
                  shadowColor: themeGreen.withValues(alpha: 0.20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(
                      color: borderGreen,
                      width: 1.5,
                    ),
                  ),
                  offset: const Offset(0, 12),
                  onSelected: (ruta) => context.go(ruta),
                  itemBuilder: (context) => [
                    _crearOpcionMenu(
                      icon: Icons.sports_esports_rounded,
                      texto: 'Juegos',
                      ruta: '/listgame',
                    ),
                    _crearOpcionMenu(
                      icon: Icons.people_alt_rounded,
                      texto: 'Amigos',
                      ruta: '/listAmigos',
                    ),
                    _crearOpcionMenu(
                      icon: Icons.person_rounded,
                      texto: 'Perfil',
                      ruta: '/profile',
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // OPCIONES PERSONALIZADAS DEL MENÚ MÓVIL
  static PopupMenuItem<String> _crearOpcionMenu({
    required IconData icon,
    required String texto,
    required String ruta,
  }) {
    return PopupMenuItem<String>(
      value: ruta,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: themeGreen,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            texto,
            style: GoogleFonts.quicksand(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: themeGreen,
            ),
          ),
        ],
      ),
    );
  }
}

// BOTONES DE NAVEGACIÓN PARA ORDENADOR
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
