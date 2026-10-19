import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/salas_service.dart';
import 'package:flutter_application_1/widgets/nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class CodePage extends StatefulWidget {
  final String rutaJuego;

  const CodePage({super.key, required this.rutaJuego});

  @override
  State<CodePage> createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  final TextEditingController _codigoController = TextEditingController();
  final SalasService _salasService = SalasService();

  bool _cargando = false;
  String? _error;

  Future<void> _entrarSala() async {
    final codigo = _codigoController.text.trim().toUpperCase();

    if (codigo.isEmpty) {
      setState(() {
        _error = 'Introduce el código de la sala.';
      });
      return;
    }

    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      // El anfitrión y los jugadores utilizan el mismo método.
      final sala = await _salasService.unirseSala(codigo: codigo);

      if (!mounted) return;

      final salaId = int.parse(sala['id'].toString());

      // Todos acceden a la misma pantalla de espera.
      context.go(
        '/listPlayersGame',
        extra: {'salaId': salaId, 'rutaJuego': widget.rutaJuego},
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const verde = Color(0xFF2E7D32);
    const verdeClaro = Color(0xFFE8F5E9);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F2),
      body: SafeArea(
        child: Column(
          children: [
            const NavBar(),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 420),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.10),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 82,
                          height: 82,
                          decoration: const BoxDecoration(
                            color: verdeClaro,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.groups_rounded,
                            color: verde,
                            size: 44,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Acceder a una sala',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF23442A),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Introduce el código de la sala',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 28),
                        TextField(
                          controller: _codigoController,
                          enabled: !_cargando,
                          textCapitalization: TextCapitalization.characters,
                          textAlign: TextAlign.center,
                          maxLength: 8,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 5,
                            color: verde,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: 'CÓDIGO',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 18,
                              letterSpacing: 3,
                              color: Colors.grey.shade400,
                            ),
                            filled: true,
                            fillColor: verdeClaro.withValues(alpha: 0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.green.shade100,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: verde,
                                width: 2,
                              ),
                            ),
                          ),
                          onSubmitted: (_) {
                            if (!_cargando) _entrarSala();
                          },
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: _cargando ? null : _entrarSala,
                            icon: _cargando
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.login_rounded),
                            label: Text(
                              _cargando ? 'Entrando...' : 'Entrar en la sala',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: verde,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.green.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
