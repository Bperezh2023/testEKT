import 'package:flutter/material.dart';
import 'modelApi.dart';

class RespuestaBusqueda {
  String folioEmplacado = "";
  String horaFechaModificacion = "";
  String idUsuarioModifico = "";
  String horaFechaCreado = "";
  String idUsuarioCreo = "";
  int idPedido = 0;
  int idTipoVenta = 0;
  String numeroSerie = "";
  String idEstado = "";
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
  String correo = "";
  bool dpi2 = false;
  String? motivoDpi = null;
  bool factura = false;
  String? motivoFactura = null;
  bool rtu = false;
  String? motivoRtu = null;
  bool acta = false;
  String? motivoActa = null;
  bool responsabilidad = false;
  String? motivoResponsabilidad = null;
  bool docempresa = false;
  String? motivoDocEmpresa = null;

  RespuestaBusqueda( this.folioEmplacado, this.horaFechaModificacion,this.idUsuarioModifico, this.horaFechaCreado,
      this.idUsuarioCreo, this.idPedido, this.idTipoVenta, this.numeroSerie, this.idEstado, this.idSucursal, this.idDepartamento,
      this.idMunicipio, this.idTipo, this.nombre, this.dpi, this.nit, this.idGenero , this.direccion, this.telefono, this.correo,
      this.dpi2, this.motivoDpi, this.factura, this.motivoFactura, this.rtu, this.motivoRtu, this.acta,
      this.motivoActa, this.responsabilidad, this.motivoResponsabilidad, this.docempresa, this.motivoDocEmpresa
      );

  RespuestaBusqueda.fromJson(Map<String , dynamic> json){
    folioEmplacado = json['folioEmplacado'];
    horaFechaModificacion = json['horaFechaModificacion'];
    idUsuarioModifico = json['idUsuarioModifico'];
    horaFechaCreado = json['horaFechaCreado'];
    idUsuarioCreo = json['idUsuarioCreo'];
    idPedido = json['idPedido'];
    idTipoVenta = json['idTipoVenta'];
    numeroSerie = json['numeroSerie'];
    idEstado = json['idEstado'];
    idSucursal = json['idSucursal'];
    idDepartamento = json['idDepartamento'];
    idMunicipio = json['idMunicipio'];
    idTipo = json['idTipo'];
    nombre = json['nombre'];
    dpi = json['dpi'];
    nit = json['nit'];
    idGenero = json['idGenero'];
    direccion = json['direccion'];
    telefono = json['telefono'];
    correo = json['correo'];
    dpi2 = json['dpi2'];
    motivoDpi = json['motivoDpi'];
    factura = json['factura'];
    motivoFactura = json['motivoFactura'];
    rtu = json['rtu'];
    motivoRtu = json['motivoRtu'];
    acta = json['acta'];
    motivoActa = json['motivoActa'];
    responsabilidad = json['responsabilidad'];
    motivoResponsabilidad = json['motivoResponsabilidad'];
    docempresa = json['docempresa'];
    motivoDocEmpresa = json['motivoDocEmpresa'];
  }
}