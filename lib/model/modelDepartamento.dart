import 'package:flutter/material.dart';

class RespuestaDepto {
  int id = 0;
  String departamento = "";

  RespuestaDepto(
      this.id, this.departamento
      );

  RespuestaDepto.fromJson(Map<String , dynamic> json){
    id = json['id'];
    departamento = json['departamento'];
  }
}