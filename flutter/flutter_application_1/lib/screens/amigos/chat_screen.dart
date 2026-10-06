import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/nav_bar.dart';

class ChatPage extends StatefulWidget {
  final String username;

  const ChatPage({
    super.key,
    required this.username,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _mensajeController =
      TextEditingController();

  // Mensajes de ejemplo
  final List<Map<String, dynamic>> mensajes = [
    {
      'mensaje': '¡Hola!',
      'mio': false,
    },
    {
      'mensaje': '¡Hola! ¿Qué tal?',
      'mio': true,
    },
    {
      'mensaje': 'Muy bien ¿Jugamos una partida?',
      'mio': false,
    },
  ];

  @override
  void dispose() {
    _mensajeController.dispose();
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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 30,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1000,
                  ),
                  child: Container(
                    height: double.infinity,
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
                        _buildHeader(),

                        const Divider(
                          height: 1,
                          color: Color(0xFFE5EDE2),
                        ),

                        Expanded(
                          child: _buildMensajes(),
                        ),

                        _buildInput(),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 18,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              context.go('/listAmigos');
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF298133),
            ),
          ),

          const SizedBox(width: 5),

          _buildAvatar(widget.username),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.username,
                  style: GoogleFonts.quicksand(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF298133),
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  'Amigo',
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            tooltip: 'Más opciones',
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  // MENSAJES
  Widget _buildMensajes() {
    if (mensajes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 55,
              color: Color(0xFFB4CDB1),
            ),

            const SizedBox(height: 15),

            Text(
              'Todavía no hay mensajes',
              style: GoogleFonts.quicksand(
                fontSize: 17,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              '¡Empieza la conversación!',
              style: GoogleFonts.quicksand(
                fontSize: 14,
                color: Colors.black38,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(25),
      itemCount: mensajes.length,
      itemBuilder: (context, index) {
        final mensaje = mensajes[index];

        return _buildMensaje(
          texto: mensaje['mensaje'],
          mio: mensaje['mio'],
        );
      },
    );
  }

  Widget _buildMensaje({
    required String texto,
    required bool mio,
  }) {
    return Align(
      alignment:
          mio ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        margin: const EdgeInsets.only(
          bottom: 12,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: mio
              ? const Color(0xFF298133)
              : const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(
              mio ? 18 : 4,
            ),
            bottomRight: Radius.circular(
              mio ? 4 : 18,
            ),
          ),
        ),
        child: Text(
          texto,
          style: GoogleFonts.quicksand(
            fontSize: 15,
            color: mio ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }


  // CAMPO PARA ESCRIBIR
  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        15,
        20,
        20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Adjuntar',
            onPressed: () {},
            icon: const Icon(
              Icons.add_rounded,
              color: Color(0xFF298133),
            ),
          ),

          const SizedBox(width: 5),

          Expanded(
            child: TextField(
              controller: _mensajeController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) {
                _enviarMensaje();
              },
              decoration: InputDecoration(
                hintText: 'Escribe un mensaje...',
                hintStyle: GoogleFonts.quicksand(
                  color: Colors.black38,
                ),
                filled: true,
                fillColor: const Color(0xFFF8FCF6),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 13,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Color(0xFFD8EDD5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Color(0xFFD8EDD5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Color(0xFF298133),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF298133),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              tooltip: 'Enviar',
              onPressed: _enviarMensaje,
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }


  // ENVIAR MENSAJE
  void _enviarMensaje() {
    final texto = _mensajeController.text.trim();

    if (texto.isEmpty) return;

    setState(() {
      mensajes.add({
        'mensaje': texto,
        'mio': true,
      });
    });

    _mensajeController.clear();
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
}
