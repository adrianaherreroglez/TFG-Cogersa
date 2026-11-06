import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool isLoading = false;

  // true = la contraseña se ve como puntos; false = se ve el texto
  bool _ocultarPassword = true;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showMessage('Rellena todos los campos');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _authService.login(username: username, password: password);

      if (!mounted) return;

      context.go('/listgame');
    } catch (e) {
      if (!mounted) return;

      _showMessage(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    const themeGreen = Color(0xFF298133);
    const lightGreen = Color(0xFFE8F5E9);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFDF4),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: lightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/icons/app/icon.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

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

                Text(
                  'Iniciar Sesión',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: themeGreen,
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: usernameController,
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

                const SizedBox(height: 16),

                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: passwordController,
                    obscureText: _ocultarPassword,
                    onSubmitted: (_) {
                      if (!isLoading) _login();
                    },
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
                      // OJO para mostrar u ocultar la contraseña
                      suffixIcon: IconButton(
                        tooltip: _ocultarPassword
                            ? 'Mostrar contraseña'
                            : 'Ocultar contraseña',
                        icon: Icon(
                          _ocultarPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: themeGreen,
                        ),
                        onPressed: () {
                          setState(() {
                            _ocultarPassword = !_ocultarPassword;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: 180,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.arrow_forward_rounded, size: 21),
                  ),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    context.go('/register');
                  },
                  child: Text(
                    'No tengo cuenta',
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
