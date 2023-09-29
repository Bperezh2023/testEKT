import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app_itk4/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/userService.dart';
import '../model/ModelBusqueda.dart';
import '../model/modelPasos.dart';
import '../model/modelRevision.dart';

class PasosRevision extends StatefulWidget {
  final String folioEmplacado;
  const PasosRevision(this.folioEmplacado, {Key? key}) : super(key: key);

  @override
  State<PasosRevision> createState() => _PasosRevisionState();
}

class _PasosRevisionState extends State<PasosRevision> {
  final _service = UserService();
  bool control = false;
  bool EmplacadoNuevo = true;
  List<RespuestaBusqueda> Lista3 = <RespuestaBusqueda>[];
  List<RespuestaPasos> Lista4 = <RespuestaPasos>[];

  vistaPasos() async {
    final prefs = await SharedPreferences.getInstance();
    var Sucursal2 = prefs.getInt('Sucursal');
    var Empleado2 = prefs.getInt('Empleado');
    print("Sucursal");
    print(Sucursal2);
    print("Empleado");
    print(Empleado2);
    var registros = <RespuestaPasos>[];
    try {
      Map mentalmap = {
        "folioEmplacado": widget.folioEmplacado,
        "numeroSerie": "",
        "idPedido": "",
        "marca": "ITALIKA",
        "idSucursal": Sucursal2,
        "cliente": {
          "nombre": "",
          "dpi": "",
          "nit": ""
        }
      };
      final UrlBusqueda = 'https://apis.italikaguatemala-dev.com/motocicletas/emplacados/estados/busquedas';
      final response = await http
          .post(Uri.parse(UrlBusqueda), body: jsonEncode(mentalmap), headers: {
        "Content-Type": "application/json",
        "Accept": "/",
        "Authorization": "Bearer " + await prefs.getString('token')!
      });
      print(2);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        var registros = <RespuestaPasos>[];
        var datos = json.decode(response.body);
        var datos2 = datos['resultado'];
        print("aqui ya paso otra vez");
        print(datos2);
        for (datos in datos2) {
          var idEstado = datos["idEstado"];
          var datos3 = datos["pasos"];
          print("datos3");
          print(datos3);
          for (var pruebadatos in datos3) {

            var nombre = "";
            var idPaso = pruebadatos["numero"];

            if(idPaso == 1){
              if(idEstado == 8){
                nombre = "Pendiente de Digitalizar";
              }
              else{
                nombre = "Documentos Digitalizados";
              }

            }
            if (idPaso == 2)
            {
              if(idEstado == 0){
                nombre = "ND";
              }
              else if(idEstado == 1){
                nombre = "Documentos Aceptados";
              }
              else if(idEstado == 2){
                nombre = "Documentos Rechazados";
              }
              else if(idEstado == 8){
                nombre = "ND";
              }else{
                nombre = "Documentos Aceptados";
              }
            }
            if (idPaso == 3)
            {
              if(idEstado == 3){
                nombre = "En Pago";
              }
              else if(idEstado == 2){
                nombre = "Pago Rechazado";
              }else{
                nombre = "Pago Aceptado";
              }
            }
            if (idPaso == 4)
            {
              if(idEstado == 4){
                nombre = "Aceptado por SAT";
              }
              else if(idEstado == 2){
                nombre = "Rechazado por SAT";
              }else{
                nombre = "Aceptado por SAT";
              }
            }
            if (idPaso == 5) {
                nombre = "Placas Asignadas";
            }
            if (idPaso == 6) {
              nombre = "Enviado a Sucursal";
            }
            if (idPaso == 7) {
              nombre = "Entregado al Cliente";
            }
            if (idPaso == 8) {
              nombre = "Pendiente de Digitalizar";
            }


            Map<String, dynamic> respuesta ={
              "idEstado": idEstado,
              "numero": pruebadatos["numero"],
              "nombre": nombre,
              "horaFecha": pruebadatos["horaFecha"],
            };
          print(1111);
          print(respuesta);
          registros.add(RespuestaPasos.fromJson(respuesta));
            }
          }
        print("otro valor");
        print(registros);
        return registros;
      } else {
        print("Failed to load jobs from API3");
      }
    } catch (e) {
      print(e);
    }
    return registros;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vistaPasos().then((value){
      setState(() {
        Lista4.clear();
        Lista4.addAll(value);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    _showSuccesSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Estado de Pasos',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const Text(
              '   Datos de Revisión',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 50.0,
            ),
            Visibility(
                visible: true,
                child: Lista4.isNotEmpty
                    ? Expanded(
                  child: ListView.builder(
                    itemCount: Lista4.length,
                    itemBuilder: (_,int index) {
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          //leading: Text(Lista4[index].estado),
                          title: Text(Lista4[index].numero.toString() + " - "+Lista4[index].nombre.toString()),
                          subtitle: Text(Lista4[index].horaFecha),
                        ),
                      );
                    },
                  ),
                )
                    : Container())
          ],
        ),
      ),
    );
  }
}
