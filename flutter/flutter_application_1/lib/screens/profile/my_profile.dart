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
  bool cargandoPerfil = true;
  String? errorPerfil;

  static const verde = Color(0xFF298133);
  static const marron = Color(0xFF644633);
  static const fondo = Color(0xFFFAFDF4);
  static const grisDeshabilitado = Color(0xFFE5E5E5);

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    try {
      final nombre = await profileService.getNombreUsuario();

      if (!mounted) return;

      setState(() {
        nombreUsuario = nombre;
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

  Future<void> _editarPerfil() async {
    final resultado = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => EditProfileDialog(
        profileService: profileService,
        nombreUsuario: nombreUsuario,
      ),
    );

    if (!mounted || resultado == null) return;

    setState(() {
      nombreUsuario = resultado['username'].toString();
      errorPerfil = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perfil actualizado correctamente'),
        backgroundColor: Color(0xFF298133),
      ),
    );
  }


  InputDecoration _decoracionPerfil(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: grisDeshabilitado,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
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
                      color: verde,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Consulta tu perfil y tu historial en EcoKids',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: marron,
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (cargandoPerfil)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(color: verde),
                    ),
                  if (errorPerfil != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Text(
                            'No se pudo cargar el perfil: $errorPerfil',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
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
                      if (constraints.maxWidth < 950) {
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
            child: Icon(Icons.account_circle, size: 82, color: verde),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 320,
            child: TextField(
              readOnly: true,
              controller: TextEditingController(text: nombreUsuario),
              enableInteractiveSelection: false,
              decoration: _decoracionPerfil('Usuario'),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 320,
            child: TextField(
              readOnly: true,
              controller: TextEditingController(text: '********'),
              obscureText: false,
              enableInteractiveSelection: false,
              decoration: _decoracionPerfil('Contraseña'),
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
                  onPressed: cargandoPerfil ? null : _editarPerfil,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: verde,
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
                    backgroundColor: marron,
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
            child: Icon(Icons.history_rounded, size: 82, color: verde),
          ),
          const SizedBox(height: 20),
          Text(
            'Tu historial en EcoKids',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: marron,
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
              color: marron,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: GoogleFonts.quicksand(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: marron,
            ),
          ),
        ],
      ),
    );
  }
}


class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({
    super.key,
    required this.profileService,
    required this.nombreUsuario,
  });

  final ProfileService profileService;
  final String nombreUsuario;

  @override
  State<EditProfileDialog> createState() =>
      _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _usernameController;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _mostrarActual = false;
  bool _mostrarNueva = false;
  bool _mostrarConfirmacion = false;
  bool _guardando = false;
  String? _error;

  static const verde = Color(0xFF298133);
  static const marron = Color(0xFF644633);
  static const fondo = Color(0xFFFAFDF4);

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(
      text: widget.nombreUsuario,
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_guardando) return;

    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _guardando = true;
      _error = null;
    });

    try {
      final usuario = await widget.profileService.actualizarPerfil(
        username: _usernameController.text.trim(),
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      if (!mounted) return;

      Navigator.of(context).pop(usuario);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _guardando = false;
      });
    }
  }

  InputDecoration _decoracion(
    String label,
    IconData icono, {
    Widget? sufijo,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icono, color: verde),
      suffixIcon: sufijo,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFD8EDD5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: verde,
          width: 2,
        ),
      ),
    );
  }

  Widget _campoPassword({
    required String label,
    required TextEditingController controller,
    required bool visible,
    required VoidCallback alternarVisibilidad,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: !_guardando,
      obscureText: !visible,
      validator: validator,
      decoration: _decoracion(
        label,
        Icons.lock_outline,
        sufijo: IconButton(
          onPressed: () {
            setState(alternarVisibilidad);
          },
          icon: Icon(
            visible ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: fondo,
      surfaceTintColor: Colors.transparent,
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      title: Text(
        'Editar perfil',
        style: GoogleFonts.quicksand(
          color: verde,
          fontSize: 26,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Nombre de usuario',
                style: GoogleFonts.quicksand(
                  color: marron,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _usernameController,
                enabled: !_guardando,
                maxLength: 30,
                decoration: _decoracion(
                  'Nuevo nombre de usuario',
                  Icons.person_outline,
                ).copyWith(counterText: ''),
                validator: (value) {
                  final texto = value?.trim() ?? '';

                  if (texto.length < 3) {
                    return 'Usa al menos 3 caracteres';
                  }

                  if (texto.length > 30) {
                    return 'Máximo 30 caracteres';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              Text(
                'Cambiar contraseña (opcional)',
                style: GoogleFonts.quicksand(
                  color: marron,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Deja los tres campos de contraseña vacíos '
                'si solo cambias el usuario.',
                style: GoogleFonts.quicksand(
                  color: marron,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),

              _campoPassword(
                label: 'Contraseña actual',
                controller: _currentPasswordController,
                visible: _mostrarActual,
                alternarVisibilidad: () {
                  _mostrarActual = !_mostrarActual;
                },
                validator: (value) {
                  if (_newPasswordController.text.isNotEmpty &&
                      (value == null || value.isEmpty)) {
                    return 'Introduce la contraseña actual';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              _campoPassword(
                label: 'Nueva contraseña',
                controller: _newPasswordController,
                visible: _mostrarNueva,
                alternarVisibilidad: () {
                  _mostrarNueva = !_mostrarNueva;
                },
                validator: (value) {
                  final nueva = value ?? '';

                  if (nueva.isNotEmpty && nueva.length < 8) {
                    return 'Debe tener al menos 8 caracteres';
                  }

                  if (nueva != _confirmPasswordController.text) {
                    return 'Las contraseñas no coinciden';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 12),

              _campoPassword(
                label: 'Repetir nueva contraseña',
                controller: _confirmPasswordController,
                visible: _mostrarConfirmacion,
                alternarVisibilidad: () {
                  _mostrarConfirmacion = !_mostrarConfirmacion;
                },
                validator: (value) {
                  final nueva = _newPasswordController.text;
                  final repetida = value ?? '';

                  if (nueva.isNotEmpty && repetida.isEmpty) {
                    return 'Repite la nueva contraseña';
                  }

                  if (nueva != repetida) {
                    return 'Las contraseñas no coinciden';
                  }

                  return null;
                },
              ),

              if (_error != null) ...[
                const SizedBox(height: 14),
                Text(
                  _error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _guardando
              ? null
              : () => Navigator.of(context).pop(),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: marron),
          ),
        ),
        ElevatedButton(
          onPressed: _guardando ? null : _guardar,
          style: ElevatedButton.styleFrom(
            backgroundColor: verde,
            foregroundColor: Colors.white,
          ),
          child: _guardando
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Guardar cambios'),
        ),
      ],
    );
  }
}
