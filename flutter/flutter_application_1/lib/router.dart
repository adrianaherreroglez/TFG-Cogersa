// Clase que contiene todas las redirecciones de la aplicación

import 'package:go_router/go_router.dart';

import 'screens/home_page.dart';
import 'screens/game/first_page.dart';
import 'screens/game/second_page.dart';
import 'screens/game/third_page.dart';
import 'screens/results/mygame.dart';
import 'screens/game/list_game.dart';
import 'screens/punto_limpio_game/punto_limpio_first_level.dart';
import 'screens/punto_limpio_game/punto_limpio_second_level.dart';
import 'screens/game/fillGaps/first_fill_gaps.dart';
import 'screens/game/fillGaps/second_fill_gaps.dart';
import 'screens/game/fillGaps/third_fill_gaps.dart';
import 'screens/game/code_page.dart';
import 'screens/users/log_in.dart';
import 'screens/users/register.dart';


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

    GoRoute(path: '/puntolimpio/secondlevel', builder: (context, state) => const PuntoLimpioSecondPage()),

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
