import 'package:flutter/material.dart';
import 'package:app_itk4/main.dart';

class RespuestaBusquedaSimple{
  String folioEmplacado = "";
  int idSucursal = 0;
  String idPedido = "";
  String idEstado = "";
  String nombre= "";
  String dpi = "";
  String nit = "";

  RespuestaBusquedaSimple(
      this.folioEmplacado, this.idSucursal, this.idPedido, this.idEstado, this.nombre, this.dpi, this.nit
      );

  RespuestaBusquedaSimple.fromJson(Map<String , dynamic> json){
    folioEmplacado = json['folioEmplacado'];
    idSucursal = int.parse(json['idSucursal']);
    idPedido = json['idPedido'];
    idEstado = json['idEstado'];
    nombre = json['nombre'];
    dpi = json['dpi'];
    nit = json['nit'];
  }
}