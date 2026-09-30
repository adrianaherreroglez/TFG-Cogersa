import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final themeGreen = const Color(0xFF298133);
    final lightGreen = const Color(0xFFE8F5E9);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFDF4),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                // ICONO
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: lightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.eco_rounded, size: 60, color: themeGreen),
                ),

                const SizedBox(height: 20),

                // TÍTULO
                Text(
                  'EcoKids',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: themeGreen,
                  ),
                ),

                const SizedBox(height: 8),

                // SUBTÍTULO
                Text(
                  'Registrarse',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: themeGreen,
                  ),
                ),

                const SizedBox(height: 30),

                // USUARIO
                Center(
                  child: SizedBox(
                    width: 320,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Usuario',
                        hintText: 'Introduce tu usuario',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // CORREO
                Center(
                  child: SizedBox(
                    width: 320,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Correo',
                        hintText: 'Introduce tu correo',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // CONTRASEÑA
                Center(
                  child: SizedBox(
                    width: 320,
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        hintText: 'Introduce tu contraseña',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // CONTRASEÑA
                Center(
                  child: SizedBox(
                    width: 320,
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirmar contraseña',
                        hintText: 'Confirmar contraseña',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // BOTÓN REGISTRARSE
                SizedBox(
                  width: 180,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/listgame');
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_forward_rounded, size: 21),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Ya tengo cuenta
                TextButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  child: Text(
                    'Ya tengo cuenta',
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      color: themeGreen,
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
