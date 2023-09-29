import 'dart:convert';
import 'package:http/http.dart' as http;

class RespuestaPlaca {
  String folioEmplacado = "";
  String placa= "";
  String marca = "";
  int idSucursal = 0;
  String nombreCliente = "";
  int idEstado = 0;

  RespuestaPlaca( this.folioEmplacado, this.placa, this.marca, this.idSucursal, this.nombreCliente, this.idEstado);

  RespuestaPlaca.fromJson(Map<String , dynamic> json){
    folioEmplacado = json['folioEmplacado'];
    placa = json['placa'];
    marca = json['marca'];
    idSucursal = json['idSucursal'];
    nombreCliente = json['nombreCliente'];
    idEstado = json['idEstado'];
  }
}


