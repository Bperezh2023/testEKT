import 'package:flutter/material.dart';


class RespuestaRevision{
  String nombreDocumento = "";
  String estado = "";
  String motivoRechazo = "";
  bool change = false;

  RespuestaRevision(
        this.nombreDocumento, this.estado, this.motivoRechazo, this.change
      );
  RespuestaRevision.fromJson(Map<String , dynamic> json){
    nombreDocumento = json['nombreDocumento'];
    estado = json['estado'];
    motivoRechazo = json['motivoRechazo'];
    change = json['change'];
  }
}