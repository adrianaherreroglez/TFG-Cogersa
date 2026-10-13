import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/my_profile_service.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/nav_bar.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final ProfileService profileService = ProfileService();

  String nombreUsuario = '';
  String passWordVisible = '••••••••';

  bool cargandoPerfil = true;
  String? errorPerfil;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    try {
      final resultados = await Future.wait<String>([
        profileService.getNombreUsuario(),
        profileService.getPassword(),
      ]);

      if (!mounted) return;

      setState(() {
        nombreUsuario = resultados[0];
        passWordVisible = resultados[1];
        cargandoPerfil = false;
        errorPerfil = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargandoPerfil = false;
        errorPerfil = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFDF4),
      body: Column(
        children: [
          const NavBar(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 35),
              child: Column(
                children: [
                  Text(
                    'Mi Perfil',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF298133),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Consulta tu perfil y tu historial en EcoKids',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF644633),
                    ),
                  ),

                  const SizedBox(height: 25),

                  if (cargandoPerfil)
                    const Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(
                        color: Color(0xFF298133),
                      ),
                    ),

                  if (errorPerfil != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEEEE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'No se pudo cargar el perfil.',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            errorPerfil!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                cargandoPerfil = true;
                                errorPerfil = null;
                              });
                              _cargarPerfil();
                            },
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    ),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final bool isSmallScreen = constraints.maxWidth < 950;

                      if (isSmallScreen) {
                        return Column(
                          children: [
                            _buildMyInfoCard(),
                            const SizedBox(height: 30),
                            _buildMyHistoryCard(),
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildMyInfoCard()),
                          const SizedBox(width: 35),
                          Expanded(child: _buildMyHistoryCard()),
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

  // INFORMACIÓN DEL USUARIO
  Widget _buildMyInfoCard() {
    return Container(
      constraints: const BoxConstraints(minHeight: 390),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFD8EDD5), width: 2),
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
          const SizedBox(
            width: 75,
            height: 75,
            child: Icon(
              Icons.account_circle,
              size: 82,
              color: Color(0xFF298133),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: 320,
            child: TextField(
              readOnly: true,
              controller: TextEditingController(text: nombreUsuario),
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                labelText: 'Usuario',
                filled: true,
                fillColor: const Color(0xFFE5E5E5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: 320,
            child: TextField(
              readOnly: true,
              controller: TextEditingController(text: passWordVisible),
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                filled: true,
                fillColor: const Color(0xFFE5E5E5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 140,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // Aquí puedes implementar el cambio de datos
                    // y el cambio de contraseña.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF298133),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Editar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(
                width: 160,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF644633),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Cerrar sesión',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // HISTORIAL DEL USUARIO
  Widget _buildMyHistoryCard() {
    return Container(
      constraints: const BoxConstraints(minHeight: 390),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFD8EDD5), width: 2),
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
          const SizedBox(
            width: 75,
            height: 75,
            child: Icon(
              Icons.history_rounded,
              size: 82,
              color: Color(0xFF298133),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Tu historial en EcoKids',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF644633),
            ),
          ),

          const SizedBox(height: 30),

          _buildHistoryItem('Experiencia', '0'),
          const SizedBox(height: 25),

          _buildHistoryItem('Puntos', '0'),
          const SizedBox(height: 25),

          _buildHistoryItem('Racha', '0'),
        ],
      ),
    );
  }

  // ELEMENTO REUTILIZABLE DEL HISTORIAL
  Widget _buildHistoryItem(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3FAEF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.quicksand(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: const Color(0xFF644633),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            value,
            style: GoogleFonts.quicksand(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF644633),
            ),
          ),
        ],
      ),
    );
  }
}
