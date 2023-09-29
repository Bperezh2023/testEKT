import 'package:flutter/material.dart';

class RespuestaMuni{
  int id = 0;
  String municipio = "";
  String codigo = "";
  int departamentoId = 0;


  RespuestaMuni(
      this.id, this.municipio, this.codigo, this.departamentoId
      );

  RespuestaMuni.fromJson(Map<String , dynamic> json){
    id = json['id'];
    municipio = json['municipio'];
    codigo = json['codigo'];
    departamentoId = json['departamentoId'];
  }
}