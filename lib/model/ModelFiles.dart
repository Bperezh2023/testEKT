import 'package:flutter/material.dart';
import 'package:app_itk4/main.dart';

class RespuestaFiles {
  int id = 0;
  String nombre = "";
  String codigoArchivo = "";

  RespuestaFiles(this.id, this.nombre, this.codigoArchivo);

  RespuestaFiles.fromJson(Map<String, dynamic> json){
    id = int.parse(json['id']);
    nombre = json['nombre'];
    codigoArchivo = json['codigoArchivo'];
  }
}