import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/nav_bar.dart';

class CodePage extends StatefulWidget {
  const CodePage({super.key});

  @override
  State<CodePage> createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  final TextEditingController codigoController = TextEditingController();

  final Color themeGreen = const Color(0xFF298133);
  final Color lightGreen = const Color(0xFFE8F5E9);
  final Color softGreen = const Color(0xFFF1F8EE);
  final Color secondaryText = const Color(0xFF5D7A61);

  @override
  void dispose() {
    codigoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFDF4),
      body: SafeArea(
        child: Column(
          children: [
            const NavBar(),

            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ==========================================
                      // TÍTULO
                      // ==========================================
                      Text(
                        'RECICLAJE',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: themeGreen,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ==========================================
                      // TARJETA VERDE CLARO
                      // ==========================================
                      Container(
                        width: 520,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 25,
                        ),
                        decoration: BoxDecoration(
                          color: softGreen,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFFD8EDD5),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                color: lightGreen,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.eco_rounded,
                                size: 75,
                                color: themeGreen,
                              ),
                            ),

                            const SizedBox(height: 14),

                            Text(
                              '¿A qué contenedor lo tirarías?',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                                color: themeGreen,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Introduce el código del juego para comenzar',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: secondaryText,
                              ),
                            ),

                            const SizedBox(height: 22),

                            // ==================================
                            // CÓDIGO
                            // ==================================
                            SizedBox(
                              width: 320,
                              child: TextField(
                                controller: codigoController,
                                textAlign: TextAlign.center,
                                textCapitalization:
                                    TextCapitalization.characters,

                                style: GoogleFonts.quicksand(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  color: themeGreen,
                                  letterSpacing: 2,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Código del juego',
                                  hintStyle: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF9AA39A),
                                    letterSpacing: 0,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.key_rounded,
                                    color: themeGreen,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 15,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFD8EDD5),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFD8EDD5),
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: themeGreen,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ==================================
                            // BOTÓN
                            // ==================================
                            SizedBox(
                              width: 200,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Prueba
                                  context.go('/first');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeGreen,
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Jugar',
                                      style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
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
          ],
        ),
      ),
    );
  }
}
