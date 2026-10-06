import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/nav_bar.dart';

class ListaAmigos extends StatefulWidget {
  const ListaAmigos({super.key});

  @override
  State<ListaAmigos> createState() => _ListaAmigosState();
}

class _ListaAmigosState extends State<ListaAmigos>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _buscadorAmigosController =
      TextEditingController();

  final TextEditingController _buscadorUsuariosController =
      TextEditingController();

  String buscadorAmigos = '';
  String buscadorUsuarios = '';

 
  // DATOS DE EJEMPLO
  final List<String> amigos = [
    'Carlos',
    'Lucía',
    'Mario',
    'Ana',
    'Sergio',
  ];

  final List<String> solicitudesRecibidas = [
    'Pedro',
    'Laura',
  ];

  final List<String> solicitudesEnviadas = [
    'Elena',
  ];

  final List<String> usuariosRegistrados = [
    'Elena',
    'David',
    'Marta',
    'Pablo',
    'Sofía',
    'Daniel',
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    _buscadorAmigosController.addListener(() {
      setState(() {
        buscadorAmigos =
            _buscadorAmigosController.text.toLowerCase();
      });
    });

    _buscadorUsuariosController.addListener(() {
      setState(() {
        buscadorUsuarios =
            _buscadorUsuariosController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _buscadorAmigosController.dispose();
    _buscadorUsuariosController.dispose();
    super.dispose();
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
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 35,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amigos',
                        style: GoogleFonts.quicksand(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF298133),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Gestiona tus amigos y solicitudes',
                        style: GoogleFonts.quicksand(
                          fontSize: 17,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: const Color(0xFFD8EDD5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildTabs(),

                            const Divider(
                              height: 1,
                              color: Color(0xFFE5EDE2),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(25),
                              child: SizedBox(
                                height: 600,
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    _buildAmigos(),
                                    _buildSolicitudes(),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
    );
  }


  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      labelColor: const Color(0xFF298133),
      unselectedLabelColor: Colors.black45,
      indicatorColor: const Color(0xFF298133),
      indicatorWeight: 3,
      labelStyle: GoogleFonts.quicksand(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
      tabs: const [
        Tab(
          icon: Icon(Icons.people_rounded),
          text: 'Amigos',
        ),
        Tab(
          icon: Icon(Icons.person_add_alt_1_rounded),
          text: 'Solicitudes',
        ),
      ],
    );
  }

  Widget _buildAmigos() {
    final amigosFiltrados = amigos.where((amigo) {
      return amigo.toLowerCase().contains(buscadorAmigos);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mis amigos',
          style: GoogleFonts.quicksand(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF298133),
          ),
        ),

        const SizedBox(height: 15),

        _buildSearchField(
          controller: _buscadorAmigosController,
          hintText: 'Buscar entre mis amigos...',
        ),

        const SizedBox(height: 20),

        Expanded(
          child: amigosFiltrados.isEmpty
              ? _buildEmptyState(
                  icon: Icons.people_outline_rounded,
                  text: 'No se encontraron amigos',
                )
              : ListView.separated(
                  itemCount: amigosFiltrados.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return _buildAmigoCard(
                      amigosFiltrados[index],
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAmigoCard(String username) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          // Lleva al chat con este usuario.
          context.go(
            '/chat',
            extra: username,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FCF6),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFD8EDD5),
            ),
          ),
          child: Row(
            children: [
              _buildAvatar(username),

              const SizedBox(width: 15),

              Expanded(
                child: Text(
                  username,
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF298133),
                  ),
                ),
              ),

              const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Color(0xFF298133),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SOLICITUDES
  Widget _buildSolicitudes() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------------------------
          // RECIBIDAS
          // -------------------------

          Row(
            children: [
              const Icon(
                Icons.call_received_rounded,
                color: Color(0xFF298133),
              ),

              const SizedBox(width: 10),

              Text(
                'Solicitudes recibidas',
                style: GoogleFonts.quicksand(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF298133),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          _buildSolicitudesRecibidas(),

          const SizedBox(height: 30),

          const Divider(
            color: Color(0xFFE5EDE2),
          ),

          const SizedBox(height: 25),

          // ENVIADAS
          Row(
            children: [
              const Icon(
                Icons.call_made_rounded,
                color: Color(0xFF298133),
              ),

              const SizedBox(width: 10),

              Text(
                'Solicitudes enviadas',
                style: GoogleFonts.quicksand(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF298133),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          _buildSolicitudesEnviadas(),
        ],
      ),
    );
  }

  // RECIBIDAS
  Widget _buildSolicitudesRecibidas() {
    if (solicitudesRecibidas.isEmpty) {
      return _buildEmptyState(
        icon: Icons.mail_outline_rounded,
        text: 'No tienes solicitudes recibidas',
      );
    }

    return Column(
      children: solicitudesRecibidas.map((username) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FCF6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFD8EDD5),
            ),
          ),
          child: Row(
            children: [
              _buildAvatar(username),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  username,
                  style: GoogleFonts.quicksand(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              IconButton(
                tooltip: 'Aceptar',
                onPressed: () {
                  // 
                },
                icon: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF298133),
                ),
              ),

              IconButton(
                tooltip: 'Rechazar',
                onPressed: () {
                  // Acción pendiente de conectar.
                },
                icon: const Icon(
                  Icons.cancel_rounded,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }


  // ENVIADAS
  Widget _buildSolicitudesEnviadas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchField(
          controller: _buscadorUsuariosController,
          hintText: 'Buscar usuarios registrados...',
        ),

        const SizedBox(height: 15),

        if (buscadorUsuarios.isNotEmpty)
          _buildUsuariosRegistrados(),

        if (buscadorUsuarios.isEmpty)
          _buildListaSolicitudesEnviadas(),
      ],
    );
  }


  // USUARIOS REGISTRADOS

  Widget _buildUsuariosRegistrados() {
    final usuarios = usuariosRegistrados.where((usuario) {
      return usuario.toLowerCase().contains(
            buscadorUsuarios,
          );
    }).toList();

    if (usuarios.isEmpty) {
      return _buildEmptyState(
        icon: Icons.person_search_rounded,
        text: 'No se encontraron usuarios',
      );
    }

    return Column(
      children: usuarios.map((username) {
        final yaEnviada =
            solicitudesEnviadas.contains(username);

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FCF6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFD8EDD5),
            ),
          ),
          child: Row(
            children: [
              _buildAvatar(username),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  username,
                  style: GoogleFonts.quicksand(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              IconButton(
                tooltip: yaEnviada
                    ? 'Solicitud enviada'
                    : 'Enviar solicitud',
                onPressed: yaEnviada
                    ? null
                    : () {
                        // Acción pendiente de conectar.
                      },
                icon: Icon(
                  yaEnviada
                      ? Icons.check_rounded
                      : Icons.add_rounded,
                  color: yaEnviada
                      ? Colors.grey
                      : const Color(0xFF298133),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // LISTA DE SOLICITUDES ENVIADAS
  Widget _buildListaSolicitudesEnviadas() {
    if (solicitudesEnviadas.isEmpty) {
      return _buildEmptyState(
        icon: Icons.person_add_outlined,
        text: 'No has enviado ninguna solicitud',
      );
    }

    return Column(
      children: solicitudesEnviadas.map((username) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FCF6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFD8EDD5),
            ),
          ),
          child: Row(
            children: [
              _buildAvatar(username),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  username,
                  style: GoogleFonts.quicksand(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Pendiente',
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF298133),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }


  // BUSCADOR
  Widget _buildSearchField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      style: GoogleFonts.quicksand(
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.quicksand(
          color: Colors.black38,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Color(0xFF298133),
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  controller.clear();
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.black38,
                ),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF8FCF6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFD8EDD5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFD8EDD5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF298133),
            width: 2,
          ),
        ),
      ),
    );
  }

  // AVATAR
  Widget _buildAvatar(String username) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFD8EDD5),
        ),
      ),
      child: Center(
        child: Text(
          username.isNotEmpty
              ? username[0].toUpperCase()
              : '?',
          style: GoogleFonts.quicksand(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF298133),
          ),
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
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCF6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFD8EDD5),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 45,
            color: const Color(0xFF9BB89A),
          ),

          const SizedBox(height: 10),

          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
