import 'package:flutter_application_1/screens/game/service/Nivel.dart';

class SegundoNivel implements Nivel {

  @override
  int sumarPuntosRespuestaCorrecta(){

    return 40;

  }

  @override
  int restarPuntosRespuestaIncorrecta(){

    return 15;

  }

}