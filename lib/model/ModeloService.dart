import 'package:flutter/material.dart';

class Respuesta{

  String pedido  = "";
  String nit = "";
  String estado = "";
  String  nombrecompleto = "";
  String dpi = "";
  String tipocliente = "" ;
  String departamento = "";
  String municipio = "";
  String direccion  = "";
  String telefono = "";
  String correo = "";
  String fecha1 = "";
  String fecha2 = "";
  String NameDoc = "";
  String NameDoc2 = "";
  String NumeroPe = "";
  String NameDoc3 = "";
  String NameDoc4 = "";



  Respuesta(this.pedido ,  this.estado , this.nit, this.nombrecompleto, this.dpi, this.tipocliente,
      this.departamento, this.municipio, this.direccion, this.telefono, this.correo, this.fecha1 , this.fecha2, this.NameDoc,
      this.NameDoc2, this.NameDoc3, this.NameDoc4, this.NumeroPe);

  Respuesta.fromJson(Map<String , dynamic> json){
    pedido = json['pedido'];
    estado = json['estado'];
    nit  = json['nit'];
    nombrecompleto  = json['nombrecompleto'];
    dpi  = json['dpi'];
    tipocliente  = json['tipocliente'];
    departamento = json['departamento'];
    municipio  = json['municipio'];
    direccion  = json['direccion'];
    telefono  = json['telefono'];
    correo  = json['correo'];
    fecha1  = json['fecha1'];
    fecha2  = json['fecha2'];
    NameDoc = json['NameDoc'];
    NameDoc2 = json['NameDoc2'];
    NumeroPe = json['numerope'];
    NameDoc3 = json['NameDoc3'];
    NameDoc4 = json['NameDoc4'];

  }
}
class ResumeModel {
  final String name;
  final String pathOrUrl;

  ResumeModel(this.name, this.pathOrUrl);
}