import 'package:flutter_application_1/screens/game/service/Nivel.dart';

class PrimerNivel implements Nivel {

  @override
  int sumarPuntosRespuestaCorrecta(){

    return 30;

  }

  @override
  int restarPuntosRespuestaIncorrecta(){

    return 10;

  }

}