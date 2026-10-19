// Clase que contiene todas las redirecciones de la aplicación

import 'package:flutter_application_1/screens/game/codeGame/code_page.dart';
import 'package:flutter_application_1/screens/game/codeGame/list_players_game.dart';
import 'package:flutter_application_1/screens/results/clasificacion_page.dart';

import 'screens/amigos/chat_screen.dart';
import 'screens/amigos/lista_amigos_screen.dart';
import 'screens/game/punto_limpio_game/dragDrop/punto_limpio_first_level.dart';
import 'screens/game/punto_limpio_game/dragDrop/punto_limpio_second_level.dart';
import 'screens/game/punto_limpio_game/fillGaps/punto_limpio_fill_first_level.dart';
import 'screens/game/punto_limpio_game/fillGaps/punto_limpio_fill_second_level.dart';
import 'screens/game/reciclaje_game/dragDrop/first_level_drag_screen.dart';
import 'screens/game/reciclaje_game/dragDrop/second_level_drag_screen.dart';
import 'screens/game/reciclaje_game/dragDrop/third_level_drag_screen.dart';
import 'screens/game/reciclaje_game/fillGaps/first_level_fill_gaps_screen.dart';
import 'screens/game/reciclaje_game/fillGaps/second_level_fill_gaps_screen.dart';
import 'screens/game/reciclaje_game/fillGaps/third_level_fill_gaps_screen.dart';
import 'screens/game/service/datos_partida.dart';
import 'screens/home_page_screen.dart';
import 'screens/list_game.dart';
import 'screens/profile/my_profile.dart';
import 'screens/results/mygame_screen.dart';

import 'package:go_router/go_router.dart';

import 'screens/salas/crear_sala_screen.dart';

import 'screens/users/log_in_screen.dart';
import 'screens/users/register_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(title: 'EcoKids'),
    ),

    // ----------------------------
    // REGISTRO Y LOGIN DE USUARIOS
    // ----------------------------
    GoRoute(path: '/login', builder: (context, state) => const LogInPage()),

    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),

    // ----------------------------
    // LISTA DE JUEGOS
    // ----------------------------
    GoRoute(path: '/listgame', builder: (context, state) => const ListGame()),

    // -------------------
    //  MI PERFIL
    // -------------------
    GoRoute(path: '/profile', builder: (context, state) => const MyProfile()),

    // -----------------------------
    // ACCEDER CON CÓDIGO DE PARTIDA
    // -----------------------------
    GoRoute(
      path: '/code',
      builder: (context, state) {
        final rutaJuego = state.extra as String? ?? '/fillGaps/first';

        return CodePage(rutaJuego: rutaJuego);
      },
    ),

    GoRoute(
      path: '/listPlayersGame',
      builder: (context, state) {
        final datos = state.extra as Map<String, dynamic>;

        return ListPlayersGame(
          salaId: datos['salaId'] as int,
          rutaJuego: datos['rutaJuego'] as String,
        );
      },
    ),

    // ------------------------------
    // RECICLAJE - DRAG & DROP
    // ------------------------------
    GoRoute(
      path: '/first',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return FirstPage(
          salaId: extra['salaId'] as int,
          datosPartida: extra['datosPartida'] as DatosPartida,
        );
      },
    ),

    GoRoute(
      path: '/second',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return SecondPage(
          salaId: extra['salaId'] as int,
          datosPartida: extra['datosPartida'] as DatosPartida,
        );
      },
    ),

    GoRoute(
      path: '/third',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return ThirdPage(
          salaId: extra['salaId'] as int,
          datosPartida: extra['datosPartida'] as DatosPartida,
        );
      },
    ),

    // ----------------------------
    // RECICLAJE - FILL IN THE GAPS
    // ----------------------------

    GoRoute(
      path: '/fillGaps/first',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return FirstFillPage(
          salaId: extra['salaId'] as int,
          datosPartida: extra['datosPartida'] as DatosPartida,
        );
      },
    ),

    GoRoute(
      path: '/fillGaps/second',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return SecondFillPage(
          salaId: extra['salaId'] as int,
          datosPartida: extra['datosPartida'] as DatosPartida,
        );
      },
    ),

    GoRoute(
      path: '/fillGaps/third',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return ThirdFillPage(
          salaId: extra['salaId'] as int,
          datosPartida: extra['datosPartida'] as DatosPartida,
        );
      },
    ),

    // --------------------------
    // PUNTO LIMPIO - DRAG & DROP
    // --------------------------

    GoRoute(
      path: '/puntolimpio/firstlevel',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return PuntoLimpioFirstPage(
          salaId: extra['salaId'] as int,
          datosPartida: extra['datosPartida'] as DatosPartida,
        );
      },
    ),

    GoRoute(
      path: '/puntolimpio/secondlevel',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return PuntoLimpioSecondPage(
          salaId: extra['salaId'] as int,
          datosPartida: extra['datosPartida'] as DatosPartida,
        );
      },
    ),

    // -------------------------------
    // PUNTO LIMPIO - FILL IN THE GAPS
    // -------------------------------

    GoRoute(
      path: '/puntolimpio/fillGaps/firstlevel',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return PuntoLimpioFirstFillPage(
          salaId: extra['salaId'] as int,
          datosPartida: extra['datosPartida'] as DatosPartida,
        );
      },
    ),

    GoRoute(
      path: '/puntolimpio/fillGaps/secondlevel',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return PuntoLimpioSecondFillPage(
          salaId: extra['salaId'] as int,
          datosPartida: extra['datosPartida'] as DatosPartida,
        );
      },
    ),

    // --------------------
    // RESULTADOS DEL JUEGO
    // --------------------
    GoRoute(
      path: '/clasificacion',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return ClasificacionPage(
          salaId: extra['salaId'] as int,
          esAnfitrion: extra['esAnfitrion'] as bool,
          datosPartida: extra['datosPartida'] as DatosPartida?,
        );
      },
    ),

    GoRoute(
      path: '/mygame',
      builder: (context, state) {
        final datosPartida = state.extra as DatosPartida;

        return MyGame(datosPartida: datosPartida);
      },
    ),

    // -------------------------------------------
    // CREACIÓN DE PARTIDAS POR PARTE DEL PROFESOR
    // --------------------------------------------
    GoRoute(
      path: '/crearSala',
      builder: (context, state) => const CrearSalaPage(),
    ),

    // -------------------------------------
    // RED SOCIAL (AMIGOS, SOLICITUDES, CHAT)
    // --------------------------------------
    GoRoute(
      path: '/listAmigos',
      builder: (context, state) => const ListaAmigos(),
    ),

    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final username = state.extra as String;

        return ChatPage(username: username);
      },
    ),
  ],
);
