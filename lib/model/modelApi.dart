import 'package:flutter/material.dart';


class RespuestaApi{

  int id = 0;
  String creation = "";
  String modified = "";
  String modified_by = "";
  String owner = "";
  int docstatus = 0;
  int sucursal = 0;
  int pedido = 0;
  String chasis = "";
  String nombre_completo = "";
  int dpi = 0;
  String nit = "";
  String direccion = "";
  int telefono = 0;
  String fecha_nacimiento = "";
  String correo = "";
  String comments = "";
  int folio = 0;
  String uuid = "";

  RespuestaApi(this.id, this.creation, this.modified, this.modified_by, this.owner,
      this.docstatus, this.sucursal, this.pedido, this.chasis, this.nombre_completo,
      this.dpi, this.nit,this.direccion, this.telefono, this.fecha_nacimiento, this.correo, this.comments
      ,this.folio, this.uuid);

 RespuestaApi.fromJson(Map<String , dynamic> json){
    id = json['id'];
    creation = json['creation'];
    modified = json['modified'];
    modified_by = json['modified_by'];
    owner = json['owner'];
    docstatus = json['docstatus'];
    sucursal = json['sucursal'];
    pedido = json['pedido'];
    chasis = json['chasis'];
    nombre_completo = json['nombre_completo'];
    dpi = json['dpi'];
    nit = json['nit'];
    direccion = json['direccion'];
    telefono = json['telefono'];
    fecha_nacimiento = json['fecha_nacimiento'];
    correo = json['correo'];
    comments = json['comments'];
    folio = json['folio'];
    uuid = json['uuid'];
  }
}

