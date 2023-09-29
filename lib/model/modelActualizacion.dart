import 'package:flutter/material.dart';
import 'package:app_itk4/main.dart';

class RespuestaActualizacion{

  int idUsuarioCreo = 0;
  int idPedido = 0;
  int idTipoVenta = 0;
  String numeroSerie = "";
  int idSucursal = 0;
  int idTipo = 0;
  int idDepartamento = 0;
  int idMunicipio = 0;
  String nombre = "";
  String dpi = "";
  String nit = "";
  int idGenero = 0;
  String direccion = "";
  int telefono = 0;
  String correo= "";

  RespuestaActualizacion(
      this.idUsuarioCreo, this.idPedido, this.idTipoVenta, this.numeroSerie, this.idSucursal,
      this.idTipo, this.idDepartamento, this.idMunicipio, this.nombre, this.dpi, this.nit,
      this.idGenero, this.direccion, this.telefono, this.correo
      );

  RespuestaActualizacion.fromJson(Map<String , dynamic> json){
    idUsuarioCreo = json['idUsuarioCreo'];
    idPedido = json['idPedido'];
    idTipoVenta = json['idTipoVenta'];
    numeroSerie = json['numeroSerie'];
    idSucursal = json['idSucursal'];
    idTipo = json['idTipo'];
    idDepartamento = json['idDepartamento'];
    idMunicipio = json['idMunicipio'];
    nombre = json['nombre'];
    dpi = json['dpi'];
    nit = json['nit'];
    idGenero = json['idGenero'];
    direccion = json['direccion'];
    telefono = json['telefono'];
    correo = json['correo'];
  }
}