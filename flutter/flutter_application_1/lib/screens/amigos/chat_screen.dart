import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/message.dart';
import 'package:flutter_application_1/services/messages_services.dart';
import 'package:flutter_application_1/widgets/nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';


const Color themeGreen = Color(0xFF298133);
const Color pageBackground = Color(0xFFFAFDF4);
const Color lightGreen = Color(0xFFE8F5E9);
const Color borderGreen = Color(0xFFD8EDD5);

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
  final MessagesService _messagesService =
      MessagesService();

  final TextEditingController _mensajeController =
      TextEditingController();

  final ScrollController _scrollController =
      ScrollController();

  List<Message> mensajes = [];

  int? _receiverId;

  bool _cargando = true;

  String? _error;

  @override
  void initState() {
    super.initState();

    _inicializarChat();
  }

  Future<void> _inicializarChat() async {
    try {
      // Obtener ID del usuario con el que estamos hablando.
      final receiverId =
          await _messagesService.obtenerIdUsuario(
        widget.username,
      );

      // Cargar mensajes anteriores.
      final mensajesCargados =
          await _messagesService.obtenerMensajes(
        receiverId,
      );

      if (!mounted) return;

      setState(() {
        _receiverId = receiverId;
        mensajes = mensajesCargados;
        _cargando = false;
      });

      _bajarAlFinal();

      // Conectar Socket.IO para recibir mensajes nuevos.
      await _messagesService.conectar(
        onNuevoMensaje: _recibirMensaje,
        onError: (mensaje) {
          if (!mounted) return;

          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(mensaje),
            ),
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cargando = false;
        _error = e
            .toString()
            .replaceFirst(
              'Exception: ',
              '',
            );
      });
    }
  }

  void _recibirMensaje(Message mensaje) {
    if (_receiverId == null) {
      return;
    }

    // Solo añadir mensajes de esta conversación.
    final perteneceAConversacion =
        (mensaje.senderId == _receiverId ||
                mensaje.receiverId == _receiverId);

    if (!perteneceAConversacion) {
      return;
    }

    if (!mounted) return;

    setState(() {
      // Evitamos duplicados.
      final yaExiste = mensajes.any(
        (m) => m.id == mensaje.id,
      );

      if (!yaExiste) {
        mensajes.add(mensaje);
      }
    });

    _bajarAlFinal();
  }

  void _enviarMensaje() {
    final texto =
        _mensajeController.text.trim();

    if (texto.isEmpty) {
      return;
    }

    if (_receiverId == null) {
      return;
    }

    try {
      _messagesService.enviarMensaje(
        receiverId: _receiverId!,
        message: texto,
      );

      _mensajeController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e
                .toString()
                .replaceFirst(
                  'Exception: ',
                  '',
                ),
          ),
        ),
      );
    }
  }

  void _bajarAlFinal() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration:
            const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _mensajeController.dispose();
    _scrollController.dispose();

    _messagesService.desconectar();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      body: Column(
        children: [
          // NavBar existente
          const NavBar(),

          Expanded(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 1000,
                  ),
                  child: _buildChat(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChat() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(28),
        border: Border.all(
          color: borderGreen,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.06,
            ),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildChatHeader(),

          Expanded(
            child: _buildContenido(),
          ),

          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildChatHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 18,
      ),
      decoration: const BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              context.go('/listAmigos');
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: themeGreen,
            ),
          ),

          const SizedBox(width: 8),

          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: borderGreen,
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: themeGreen,
              size: 25,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              widget.username,
              style: GoogleFonts.quicksand(
                fontSize: 20,
                fontWeight:
                    FontWeight.w700,
                color: themeGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContenido() {
    if (_cargando) {
      return const Center(
        child: CircularProgressIndicator(
          color: themeGreen,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding:
              const EdgeInsets.all(24),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
                size: 45,
              ),

              const SizedBox(height: 12),

              Text(
                _error!,
                textAlign:
                    TextAlign.center,
                style:
                    GoogleFonts.quicksand(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 18),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _cargando = true;
                    _error = null;
                  });

                  _inicializarChat();
                },
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      themeGreen,
                  foregroundColor:
                      Colors.white,
                ),
                child: Text(
                  'Reintentar',
                  style:
                      GoogleFonts.quicksand(
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (mensajes.isEmpty) {
      return Center(
        child: Text(
          'Todavía no hay mensajes.\n¡Saluda a ${widget.username}!',
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(
            fontSize: 17,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(24),
      itemCount: mensajes.length,
      itemBuilder: (
        context,
        index,
      ) {
        final mensaje =
            mensajes[index];

        final mio =
            mensaje.senderId !=
                _receiverId;

        return _buildMensaje(
          mensaje,
          mio,
        );
      },
    );
  }

  Widget _buildMensaje(
    Message mensaje,
    bool mio,
  ) {
    return Align(
      alignment: mio
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints:
            const BoxConstraints(
          maxWidth: 500,
        ),
        margin: const EdgeInsets.only(
          bottom: 12,
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: mio
              ? themeGreen
              : const Color(0xFFF8FCF6),
          borderRadius:
              BorderRadius.circular(18),
          border: mio
              ? null
              : Border.all(
                  color: borderGreen,
                ),
        ),
        child: Text(
          mensaje.message,
          style: GoogleFonts.quicksand(
            fontSize: 15,
            fontWeight:
                FontWeight.w600,
            color: mio
                ? Colors.white
                : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft:
              Radius.circular(28),
          bottomRight:
              Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller:
                  _mensajeController,
              onSubmitted: (_) {
                _enviarMensaje();
              },
              textInputAction:
                  TextInputAction.send,
              decoration:
                  InputDecoration(
                hintText:
                    'Escribe un mensaje...',
                hintStyle:
                    GoogleFonts.quicksand(
                  color:
                      Colors.grey.shade500,
                ),
                filled: true,
                fillColor:
                    const Color(
                  0xFFF8FCF6,
                ),
                contentPadding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                  borderSide:
                      const BorderSide(
                    color: borderGreen,
                  ),
                ),
                enabledBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                  borderSide:
                      const BorderSide(
                    color: borderGreen,
                  ),
                ),
                focusedBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                  borderSide:
                      const BorderSide(
                    color: themeGreen,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Container(
            decoration:
                const BoxDecoration(
              color: themeGreen,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed:
                  _enviarMensaje,
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
}

