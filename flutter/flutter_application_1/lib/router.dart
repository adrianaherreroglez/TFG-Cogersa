// Clase que contiene todas las redirecciones de la aplicación

import 'package:go_router/go_router.dart';

import 'screens/home_page.dart';
import 'screens/game/first_page.dart';
import 'screens/game/second_page.dart';
import 'screens/game/third_page.dart';
import 'screens/results/mygame.dart';
import 'screens/game/list_game.dart';


final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(title: 'EcoKids'),
    ),

    GoRoute(path: '/listgame', builder: (context, state) => const ListGame()),

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

  ],
);
