import 'package:flutter/material.dart';

class RespuestaLogin{
  String token = "";
  int sucursal = 0;
  int noEmpleado = 0;
  String nombreCompleto = "";
  int totalEmplacado = 0;

  RespuestaLogin(
      this.sucursal, this.noEmpleado, this.nombreCompleto, this.totalEmplacado, this.token);

  RespuestaLogin.fromJson(Map<String , dynamic> json){
    token = json['token'];
    sucursal = json['sucursal'];
    noEmpleado = json['noEmpleado'];
    nombreCompleto = json['nombreCompleto'];
    totalEmplacado = json['totalEmplacado'];
  }
}