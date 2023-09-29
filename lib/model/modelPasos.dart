import 'package:flutter/material.dart';

class RespuestaPasos{
  int idEstado = 0;
  int numero = 0;
  String nombre = "";
  String horaFecha = "";

  RespuestaPasos(
      this.idEstado, this.numero, this.horaFecha, this.nombre);

  RespuestaPasos.fromJson(Map<String , dynamic> json){
    idEstado = json['idEstado'];
    numero = json['numero'];
    nombre = json['nombre'];
    horaFecha = json['horaFecha'];
  }
}