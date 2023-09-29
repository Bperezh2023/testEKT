import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class RespuestaComentario{
  int id = 0;
  String descripcion = "";
  String usuarioCreo = "";
  String fechaHoraCreado = "";

  RespuestaComentario(
      this.id, this.descripcion,  this.usuarioCreo ,this.fechaHoraCreado
      );

  RespuestaComentario.fromJson(Map<String , dynamic> json){
    id = json['id'];
    descripcion = json['descripcion'];
    usuarioCreo = json['usuarioCreo'];
    fechaHoraCreado = json['fechaHoraCreado'];
  }
}