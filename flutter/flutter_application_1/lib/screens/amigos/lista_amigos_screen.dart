import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/friend.dart';
import 'package:flutter_application_1/services/friends_service.dart';
import 'package:flutter_application_1/widgets/nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

const Color themeGreen = Color(0xFF298133);
const Color backgroundGreen = Color(0xFFD8EDD5);
const Color lightGreen = Color(0xFFE8F5E9);
const Color pageBackground = Color(0xFFFAFDF4);

class ListaAmigos extends StatefulWidget {
  const ListaAmigos({super.key});

  @override
  State<ListaAmigos> createState() => _ListaAmigosState();
}

class _ListaAmigosState extends State<ListaAmigos>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final FriendsService _friendsService = FriendsService();

  final TextEditingController _buscadorAmigosController =
      TextEditingController();

  final TextEditingController _buscadorUsuariosController =
      TextEditingController();

  Timer? _debounce;

  String buscadorAmigos = '';
  String buscadorUsuarios = '';

  List<Friend> amigos = [];
  List<Friend> solicitudesRecibidas = [];
  List<Friend> solicitudesEnviadas = [];
  List<Friend> usuariosRegistrados = [];

  bool cargando = true;
  bool buscandoUsuarios = false;
  String? error;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    _tabController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _buscadorAmigosController.addListener(() {
      setState(() {
        buscadorAmigos =
            _buscadorAmigosController.text.toLowerCase();
      });
    });

    _buscadorUsuariosController.addListener(
      _onBuscarUsuarios,
    );

    _cargarDatos();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _tabController.dispose();
    _buscadorAmigosController.dispose();
    _buscadorUsuariosController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final resultados = await Future.wait([
        _friendsService.obtenerAmigos(),
        _friendsService.obtenerSolicitudesRecibidas(),
        _friendsService.obtenerSolicitudesEnviadas(),
      ]);

      if (!mounted) return;

      setState(() {
        amigos = resultados[0];
        solicitudesRecibidas =
            resultados[1];
        solicitudesEnviadas =
            resultados[2];

        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
        error = e.toString().replaceFirst(
              'Exception: ',
              '',
            );
      });
    }
  }

  void _onBuscarUsuarios() {
    final texto =
        _buscadorUsuariosController.text.trim();

    setState(() {
      buscadorUsuarios = texto;
    });

    _debounce?.cancel();

    if (texto.isEmpty) {
      setState(() {
        usuariosRegistrados = [];
        buscandoUsuarios = false;
      });
      return;
    }

    _debounce = Timer(
      const Duration(milliseconds: 400),
      () async {
        try {
          setState(() {
            buscandoUsuarios = true;
          });

          final usuarios =
              await _friendsService.buscarUsuarios(texto);

          if (!mounted) return;

          setState(() {
            usuariosRegistrados = usuarios;
            buscandoUsuarios = false;
          });
        } catch (e) {
          if (!mounted) return;

          setState(() {
            buscandoUsuarios = false;
          });

          _mostrarError(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          );
        }
      },
    );
  }

  Future<void> _enviarSolicitud(Friend usuario) async {
    try {
      await _friendsService.enviarSolicitud(
        usuario.id,
      );

      await _cargarDatos();

      if (!mounted) return;

      _mostrarMensaje(
        'Solicitud enviada a ${usuario.username}',
      );
    } catch (e) {
      _mostrarError(
        e.toString().replaceFirst(
          'Exception: ',
          '',
        ),
      );
    }
  }

  Future<void> _aceptarSolicitud(
    Friend solicitud,
  ) async {
    if (solicitud.requestId == null) {
      _mostrarError(
        'No se encontró la solicitud',
      );
      return;
    }

    try {
      await _friendsService.aceptarSolicitud(
        solicitud.requestId!,
      );

      await _cargarDatos();

      if (!mounted) return;

      _mostrarMensaje(
        '${solicitud.username} ahora es tu amigo',
      );
    } catch (e) {
      _mostrarError(
        e.toString().replaceFirst(
          'Exception: ',
          '',
        ),
      );
    }
  }

  Future<void> _rechazarSolicitud(
    Friend solicitud,
  ) async {
    if (solicitud.requestId == null) {
      _mostrarError(
        'No se encontró la solicitud',
      );
      return;
    }

    try {
      await _friendsService.rechazarSolicitud(
        solicitud.requestId!,
      );

      await _cargarDatos();

      if (!mounted) return;

      _mostrarMensaje(
        'Solicitud rechazada',
      );
    } catch (e) {
      _mostrarError(
        e.toString().replaceFirst(
          'Exception: ',
          '',
        ),
      );
    }
  }

  void _mostrarMensaje(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensaje,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _mostrarError(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red.shade700,
        content: Text(
          mensaje,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  List<Friend> get amigosFiltrados {
    if (buscadorAmigos.isEmpty) {
      return amigos;
    }

    return amigos.where((amigo) {
      return amigo.username
          .toLowerCase()
          .contains(buscadorAmigos);
    }).toList();
  }

  bool _esSolicitudEnviada(int userId) {
    return solicitudesEnviadas.any(
      (solicitud) => solicitud.id == userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      body: Column(
        children: [
          const NavBar(),

          const SizedBox(height: 18),

          // PESTAÑAS
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1000,
                ),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: backgroundGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTabButton(
                          index: 0,
                          icon: Icons.people_alt_rounded,
                          text: 'Amigos',
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: _buildTabButton(
                          index: 1,
                          icon: Icons.person_add_alt_1_rounded,
                          text: 'Solicitudes',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

 
          // TARJETA PRINCIPAL
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1000,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: backgroundGreen,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.06,
                          ),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: cargando
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: themeGreen,
                            ),
                          )
                        : error != null
                            ? _buildError()
                            : TabBarView(
                                controller: _tabController,
                                children: [
                                  _buildAmigos(),
                                  _buildSolicitudes(),
                                ],
                              ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

 
  // BOTÓN DE PESTAÑA
  Widget _buildTabButton({
    required int index,
    required IconData icon,
    required String text,
  }) {
    final bool seleccionada =
        _tabController.index == index;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        _tabController.animateTo(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: seleccionada
              ? themeGreen
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: seleccionada
              ? [
                  BoxShadow(
                    color: themeGreen.withValues(
                      alpha: 0.20,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: seleccionada
                  ? Colors.white
                  : themeGreen,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold,
                color: seleccionada
                    ? Colors.white
                    : themeGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }


  // ERROR
  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 60,
              color: Colors.red,
            ),
            const SizedBox(height: 15),
            Text(
              error!,
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _cargarDatos,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }


  // AMIGOS
  Widget _buildAmigos() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mis amigos',
            style: GoogleFonts.quicksand(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: themeGreen,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: _buscadorAmigosController,
            decoration: InputDecoration(
              hintText: 'Buscar entre mis amigos...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFF8FCF6),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: backgroundGreen,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: backgroundGreen,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: themeGreen,
                  width: 2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          if (amigosFiltrados.isEmpty)
            _buildEmptyState(
              icon: Icons.people_outline_rounded,
              text: buscadorAmigos.isNotEmpty
                  ? 'No se encontraron amigos'
                  : 'Todavía no tienes amigos',
            )
          else
            ...amigosFiltrados.map(
              _buildFriendCard,
            ),
        ],
      ),
    );
  }


  // TARJETA DE AMIGO
  Widget _buildFriendCard(Friend amigo) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCF6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: backgroundGreen,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 6,
        ),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: lightGreen,
          child: Text(
            amigo.username.isNotEmpty
                ? amigo.username[0].toUpperCase()
                : '?',
            style: GoogleFonts.quicksand(
              color: themeGreen,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        title: Text(
          amigo.username,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Chatear',
              icon: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: themeGreen,
              ),
              onPressed: () {
                context.go(
                  '/chat',
                  extra: amigo.username,
                );
              },
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

 
  // SOLICITUDES
  Widget _buildSolicitudes() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Solicitudes recibidas',
            style: GoogleFonts.quicksand(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: themeGreen,
            ),
          ),

          const SizedBox(height: 15),

          if (solicitudesRecibidas.isEmpty)
            _buildEmptyState(
              icon: Icons.mail_outline_rounded,
              text: 'No tienes solicitudes pendientes',
            )
          else
            ...solicitudesRecibidas.map(
              _buildReceivedRequest,
            ),

          const SizedBox(height: 40),

          Text(
            'Solicitudes enviadas',
            style: GoogleFonts.quicksand(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: themeGreen,
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: _buscadorUsuariosController,
            decoration: InputDecoration(
              hintText: 'Buscar usuarios registrados...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFF8FCF6),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: backgroundGreen,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: backgroundGreen,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: themeGreen,
                  width: 2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          if (buscandoUsuarios)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  color: themeGreen,
                ),
              ),
            )
          else if (buscadorUsuarios.isEmpty)
            _buildSentRequests()
          else if (usuariosRegistrados.isEmpty)
            _buildEmptyState(
              icon: Icons.search_off_rounded,
              text: 'No se encontraron usuarios',
            )
          else
            ...usuariosRegistrados.map(
              _buildUserSearchCard,
            ),
        ],
      ),
    );
  }


  // SOLICITUD RECIBIDA
  Widget _buildReceivedRequest(
    Friend solicitud,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCF6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: backgroundGreen,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 6,
        ),
        leading: CircleAvatar(
          backgroundColor: lightGreen,
          child: Text(
            solicitud.username[0].toUpperCase(),
            style: GoogleFonts.quicksand(
              color: themeGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          solicitud.username,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Quiere ser tu amigo',
          style: GoogleFonts.quicksand(),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Aceptar',
              icon: const Icon(
                Icons.check_circle_rounded,
                color: themeGreen,
              ),
              onPressed: () {
                _aceptarSolicitud(solicitud);
              },
            ),
            IconButton(
              tooltip: 'Rechazar',
              icon: const Icon(
                Icons.cancel_rounded,
                color: Colors.red,
              ),
              onPressed: () {
                _rechazarSolicitud(solicitud);
              },
            ),
          ],
        ),
      ),
    );
  }


  // SOLICITUDES ENVIADAS
  Widget _buildSentRequests() {
    if (solicitudesEnviadas.isEmpty) {
      return _buildEmptyState(
        icon: Icons.send_outlined,
        text: 'No tienes solicitudes enviadas',
      );
    }

    return Column(
      children: solicitudesEnviadas.map(
        (solicitud) {
          return Container(
            margin: const EdgeInsets.only(
              bottom: 12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FCF6),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: backgroundGreen,
              ),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 6,
              ),
              leading: CircleAvatar(
                backgroundColor: lightGreen,
                child: Text(
                  solicitud.username[0]
                      .toUpperCase(),
                  style: GoogleFonts.quicksand(
                    color: themeGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                solicitud.username,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius:
                      BorderRadius.circular(20),
                  border: Border.all(
                    color: backgroundGreen,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration:
                          const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'Pendiente',
                      style: GoogleFonts.quicksand(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }


  // BUSCAR USUARIOS
  Widget _buildUserSearchCard(
    Friend usuario,
  ) {
    final enviada =
        _esSolicitudEnviada(usuario.id);

    final esAmigo = amigos.any(
      (amigo) => amigo.id == usuario.id,
    );

    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCF6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: backgroundGreen,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: lightGreen,
          child: Text(
            usuario.username[0].toUpperCase(),
            style: GoogleFonts.quicksand(
              color: themeGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          usuario.username,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: esAmigo
            ? const Icon(
                Icons.people_alt_rounded,
                color: themeGreen,
              )
            : enviada
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: lightGreen,
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 9,
                          height: 9,
                          decoration:
                              const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          'Pendiente',
                          style:
                              GoogleFonts.quicksand(
                            color:
                                Colors.grey.shade700,
                            fontWeight:
                                FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                : IconButton(
                    tooltip: 'Enviar solicitud',
                    icon: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: themeGreen,
                    ),
                    onPressed: () {
                      _enviarSolicitud(usuario);
                    },
                  ),
      ),
    );
  }


  // ESTADO VACÍO
  Widget _buildEmptyState({
    required IconData icon,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCF6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: backgroundGreen,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 55,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
