// Clase que contiene todas las redirecciones de la aplicación

import 'package:flutter_application_1/screens/game/punto_limpio_game/dragDrop/punto_limpio_first_level.dart';
import 'package:flutter_application_1/screens/game/punto_limpio_game/dragDrop/punto_limpio_second_level.dart';
import 'package:flutter_application_1/screens/game/punto_limpio_game/fillGaps/punto_limpio_fill_first_level.dart';
import 'package:flutter_application_1/screens/game/punto_limpio_game/fillGaps/punto_limpio_fill_second_level.dart';
import 'package:flutter_application_1/screens/game/reciclaje_game/code_page.dart';
import 'package:flutter_application_1/screens/game/reciclaje_game/dragDrop/first_level_drag_screen.dart';
import 'package:flutter_application_1/screens/game/reciclaje_game/dragDrop/second_level_drag_screen.dart';
import 'package:flutter_application_1/screens/game/reciclaje_game/dragDrop/third_level_drag_screen.dart';
import 'package:flutter_application_1/screens/game/reciclaje_game/fillGaps/first_level_fill_gaps_screen.dart';
import 'package:flutter_application_1/screens/game/reciclaje_game/fillGaps/second_level_fill_gaps_screen.dart';
import 'package:flutter_application_1/screens/game/reciclaje_game/fillGaps/third_level_fill_gaps_screen.dart';
import 'package:flutter_application_1/screens/list_game.dart';
import 'package:go_router/go_router.dart';

import 'screens/home_page_screen.dart';
import 'screens/results/mygame_screen.dart';

import 'screens/users/log_in_screen.dart';
import 'screens/users/register_screen.dart';


final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(title: 'EcoKids'),
    ),

    GoRoute(path: '/login', builder: (context, state) => const LogInPage()),

    GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),

    GoRoute(path: '/listgame', builder: (context, state) => const ListGame()),

    GoRoute(path: '/code', builder: (context, state) => const CodePage()),

    GoRoute(path: '/first', builder: (context, state) => const FirstPage()),

    GoRoute(
      path: '/second',
      builder: (context, state) {
        final puntos = state.extra as int? ?? 0;

        return SecondPage(puntosPrevios: puntos);
      },
    ),

    GoRoute(
      path: '/third',
      builder: (context, state) {
        final puntos = state.extra as int? ?? 0;

        return ThirdPage(puntosPrevios: puntos);
      },
    ),

    GoRoute(
      path: '/mygame',
      builder: (context, state) {
        final puntos = state.extra as int? ?? 0;

        return MyGame(puntosPrevios: puntos);
      },
    ),

    GoRoute(path: '/puntolimpio/firstlevel', builder: (context, state) => const PuntoLimpioFirstPage()),

   
    GoRoute(
      path: '/puntolimpio/secondlevel',
      builder: (context, state) {
        final puntos = state.extra as int? ?? 0;

        return PuntoLimpioSecondPage(puntosPrevios: puntos);
      },
    ),

    GoRoute(path: '/puntolimpio/fillGaps/firstlevel', builder: (context, state) => const PuntoLimpioFirstFillPage()),


  GoRoute(
      path: '/puntolimpio/fillGaps/secondLevel',
      builder: (context, state) {
        final puntos = state.extra as int? ?? 0;

        return PuntoLimpioSecondFillPage(puntosPrevios: puntos);
      },
    ),

    GoRoute(path: '/fillGaps/first', builder: (context, state) => const FirstFillPage()),

    GoRoute(
      path: '/fillGaps/second',
      builder: (context, state) {
        final puntos = state.extra as int? ?? 0;

        return SecondFillPage(puntosPrevios: puntos);
      },
    ),

    GoRoute(
      path: '/fillGaps/third',
      builder: (context, state) {
        final puntos = state.extra as int? ?? 0;

        return ThirdFillPage(puntosPrevios: puntos);
      },
    ),



  ],
);
