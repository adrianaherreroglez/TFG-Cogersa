import 'package:flutter_application_1/screens/game/service/Nivel.dart';

class TercerNivel implements Nivel {

  @override
  int sumarPuntosRespuestaCorrecta(){

    return 50;

  }

  @override
  int restarPuntosRespuestaIncorrecta(){

    return 20;

  }

}