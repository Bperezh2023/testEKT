import 'dart:async';
import 'dart:convert';
import 'package:app_itk4/Screens/pageFirma.dart';
import 'package:app_itk4/Screens/pasos.dart';
import 'package:app_itk4/Screens/revision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import 'modalEnviar.dart';
import 'upload_file.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/ModelBusqueda.dart';
import '../model/ModeloService.dart';
import '../model/modelApi.dart';
import '../model/modelRespBusqueda.dart';
import '../services/userService.dart';
import 'Comments.dart';
import 'Imageness.dart';
import 'busqueda2.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class JobsListView extends StatelessWidget {
  final int selector;
  JobsListView(this.selector, {Key? key}) : super(key: key);
  var registros = <RespuestaBusquedaSimple>[];
  List<RespuestaBusqueda> Respuesta = <RespuestaBusqueda>[];
  static int folioComments = 0;
  int seleccionTipo = 0;
  final service = UserService();
  late BuildContext dialogContext20; // global declaration
  late BuildContext dialogContext21; // global declaration
  late BuildContext dialogContext2; // global declaration
  late BuildContext dialogContext3; // global
  late BuildContext dialogContext; // global
  int RadioGroup2 = 1;

  @override
  Widget build(BuildContext context2) {
    return FutureBuilder<List<RespuestaBusquedaSimple>>(
      future: _fetchJobs(),
      builder: (context2, snapshot) {
        if (snapshot.hasData) {
          List<RespuestaBusquedaSimple>? data = snapshot.data;
          return _jobsListView(data, context2);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<RespuestaBusquedaSimple>> _fetchJobs() async {
    var registros = <RespuestaBusquedaSimple>[];
    final prefs = await SharedPreferences.getInstance();
    var Sucursal2 = prefs.getInt('Sucursal');
    var Empleado2 = prefs.getInt('Empleado');
    var token2 = prefs.getString('token');
    print("Sucursal");
    print(Sucursal2);
    print("Empleado");
    print(Empleado2);
    print("token");
    print(token2);

    print(123456789);
    print(selector);
    print("termina selector");
    try {
      Map mentalmap = {
        "idSucursal": Sucursal2,
        "idPedido": "",
        "numeroSerie": "",
        "cliente": {"nombre": "", "dpi": "", "nit": ""}
      };
      final UrlBusqueda =
          'https://apis.italikaguatemala-dev.com/motocicletas/emplacados/busquedas';
      final response = await http
          .post(Uri.parse(UrlBusqueda), body: jsonEncode(mentalmap), headers: {
        "Content-Type": "application/json",
        //"Content-Length": "0"
        //, "Host": "calculated when request is sent"
        //,"User-Agent": "PostmanRuntime/7.29.2"
        "Accept": "/",
        "Authorization": "Bearer " + await prefs.getString('token')!

      });
      print(2);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        var registros = <RespuestaBusquedaSimple>[];
        var datos = json.decode(response.body);
        var datos2 = datos['resultado'];
        print("aqui ya paso!");
        print(datos2);
        for (datos in datos2) {
          Map<String, dynamic> param2 = {
            "folioEmplacado": datos["folioEmplacado"],
            "idSucursal": datos["idSucursal"].toString(),
            "idPedido": datos["idPedido"].toString(),
            "idEstado": ValidarEstado2(datos["idEstado"]),
            "nombre": datos["cliente"]["nombre"],
            "dpi": datos["cliente"]["dpi"],
            "nit": datos["cliente"]["nit"],
          };

          if (datos["idEstado"] == selector) {
            print("respuesa modelo");
            print(param2);
            registros.add(RespuestaBusquedaSimple.fromJson(param2));
            print("Modelo lleno");
            print(registros);
          }
        }
        print("otro valor");
        print(registros);
        return registros;
      } else {
        switch(response.statusCode){

          case 400:
            _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.",BuildContext);
            break;
          case 401:
            _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.", BuildContext);
            break;
          case 404:
            _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.",BuildContext);
            break;
          case 500:
            _showSuccesSnackBar("No se completo la petición intente mas tarde.",BuildContext);
            break;
        }
      }
    } catch (e) {
      print(e);
    }
    return registros;
  }

  ListView _jobsListView(data, context2) {
    return ListView.builder(
        physics: ClampingScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, int index) {
          ListTile _tile(String title, String subtitle, String trailing,
                  IconData icon) =>
              ListTile(
                title: Text(title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    )),
                subtitle: Text(subtitle,
                    style: TextStyle(
                        color: ValidarEstado(subtitle),
                        fontWeight: FontWeight.w500)),
                trailing: Text(
                  trailing,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () async {
                  await service.DetalleBusquedaService(
                          data[index].folioEmplacado)
                      .then((value) {
                    print(value);
                    Respuesta.clear();
                    Respuesta.addAll(value);
                    print("ontap");
                    print(Respuesta.length);
                  });
                  DetalleBusqueda(context, Respuesta, 0);
                },
                leading: Icon(
                  icon,
                  color: Colors.blue[500],
                ),
              );
          return _tile(data[index].nombre, data[index].idEstado.toString(),
              data[index].idPedido.toString(), Icons.motorcycle);
        });
  }

  String? _validateTextField(String value) {
    if (value.isEmpty) {
      return 'Por favor, ingrese un valor';
    }
    return null;
  }

  ErrorBusqueda(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          dialogContext20 = context;
          return AlertDialog(
            title: Text(
              "Error al encontrar emplacado",
              style: TextStyle(color: Colors.teal, fontSize: 25),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    'No se pudo encontrar el emplacado, favor intente nuevamente',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Aceptar',
                  style: TextStyle(color: Colors.teal, fontSize: 16),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  ErrorSubirArchivo(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          dialogContext21 = context;
          return AlertDialog(
            title: Text(
              "Error al cargar el emplacado",
              style: TextStyle(color: Colors.teal, fontSize: 25),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    'La extensión debe ser .pdf o .jpg, intenta nuevamente',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Aceptar',
                  style: TextStyle(color: Colors.teal, fontSize: 16),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _deleteFormDialog3(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context;
          return AlertDialog(
            scrollable: true,
            title: Text(
              "   Subiendo Archivo",
              style: TextStyle(color: Colors.blueGrey, fontSize: 25),
            ),
            actions: [
              SpinKitFadingCircle(
                size: 100,
                color: Colors.blue[900],
              ),
            ],
          );
        });
  }

  _deleteFormDialog4(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Error al Cargar el Archivo",
              style: TextStyle(color: Colors.teal, fontSize: 25),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    'Tu archivo no se pudo subir con éxito, intentalo de nuevo.',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Aceptar',
                  style: TextStyle(color: Colors.teal, fontSize: 16),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _deleteFormDialog2(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          dialogContext2 = context;
          return AlertDialog(
            title: Text(
              "Carga de Archivo",
              style: TextStyle(color: Colors.teal, fontSize: 25),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    '¡Tu archivo se ha subido con éxito!: ',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Aceptar',
                  style: TextStyle(color: Colors.teal, fontSize: 16),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _showSuccesSnackBar(String message, BuildContext) {
    ScaffoldMessenger.of(BuildContext).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /*_alertdialog(String folioEmplacado, context){
    showDialog(
        context: context,
        builder: (BuildContext context2){
          return AlertDialog(
            title: Text("Confirmación",
              style: TextStyle(color: Colors.blue[900], fontSize: 25),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('¿Estás seguro que deseas enviar tu archivo a revisión?',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Sí',
                  style: TextStyle(color: Colors.blue[900], fontSize: 16),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _deleteFormDialog3(context);
                  var result = await _service.Subir_Info2(folioEmplacado).then((response){
                    if(response == 200){
                      var result2 =  _service.Subir_InfoDB(folioEmplacado).then((response2){
                        if(response2 == 201){
                          Navigator.of(dialogContext).pop();
                          _deleteFormDialog2(context);
                        }else{
                          switch(response2){
                            case 400:
                              Navigator.of(dialogContext).pop();
                              _deleteFormDialog4(context);
                              break;
                            case 401:
                              _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.", context);
                              break;
                            case 404:
                              _showSuccesSnackBar("Usuario o contraseña incorrectos.", context);
                              break;
                            case 500:
                              _showSuccesSnackBar("No se completo la petición intente mas tarde.", context);
                              break;
                          }
                        }
                        var resultado =  _service.ActualizacionEntregas2(folioEmplacado);
                      });
                      _deleteFormDialog2(context2);
                    }else{
                      switch(response){
                        case 400:
                          Navigator.of(dialogContext).pop();
                          _deleteFormDialog4(context);
                          break;
                        case 401:
                          _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.", context);
                          break;
                        case 404:
                          _showSuccesSnackBar("Usuario o contraseña incorrectos.", context);
                          break;
                        case 500:
                          _showSuccesSnackBar("No se completo la petición intente mas tarde.", context);
                          break;
                      }
                    }
                  });
                },
              ),
              TextButton(
                child: Text('No',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _deleteFormDialog3(context);
                  var result = await _service.Subir_Info2(folioEmplacado).then((response){
                    if(response == 200){
                      var result2 =  _service.Subir_InfoDB(folioEmplacado).then((response2){
                        if(response2 == 201){
                          Navigator.of(dialogContext).pop();
                          _deleteFormDialog2(context);
                        }else{
                          switch(response2){
                            case 400:
                              Navigator.of(dialogContext).pop();
                              _deleteFormDialog4(context);
                              break;
                            case 401:
                              _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.", context);
                              break;
                            case 404:
                              _showSuccesSnackBar("Usuario o contraseña incorrectos.", context);
                              break;
                            case 500:
                              _showSuccesSnackBar("No se completo la petición intente mas tarde.", context);
                              break;
                          }

                        }
                      });
                    }else{
                      switch(response){
                        case 400:
                          Navigator.of(dialogContext).pop();
                          _deleteFormDialog4(context);
                          break;
                        case 401:
                          _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.", context);
                          break;
                        case 404:
                          _showSuccesSnackBar("Usuario o contraseña incorrectos.", context);
                          break;
                        case 500:
                          _showSuccesSnackBar("No se completo la petición intente mas tarde.", context);
                          break;
                      }
                    }
                  });
                },
              ),
            ],
          );
        }
    );
  }*/
  _alertdialog(String folioEmplacado, int TipoCliente, context) {
    print("tipo de cliente");
    print(TipoCliente);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          dialogContext3 = context;
          return AlertDialog(
            title: Text(
              "Confirmación",
              style: TextStyle(color: Colors.blue[900], fontSize: 25),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    '¿Estás seguro que deseas enviar tu archivo a revisión?',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  const SizedBox(
                    width: 75.0,
                  ),
                  Radio(
                      value: 1,
                      groupValue: RadioGroup2,
                      onChanged: (value) {
                          RadioGroup2 = 1;
                      }),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Text("SI"),
                  const SizedBox(
                    width: 50.0,
                  ),
                  Radio(
                      value: 2,
                      groupValue: RadioGroup2,
                      onChanged: (value) {
                          RadioGroup2 = 2;
                      }),
                  Text("NO"),
                ],
              ),
              Visibility(
                visible: TipoCliente == 2 ? true : false,
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    key: UniqueKey(),
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      hint: Text('Selecciona tu tipo de envío'),
                      items: [
                        DropdownMenuItem(
                            child: Text("Archivo Completo"), value: 1),
                        DropdownMenuItem(child: Text("DPI"), value: 2),
                        DropdownMenuItem(child: Text("Factura"), value: 3),
                        DropdownMenuItem(child: Text("RTU"), value: 4),
                        DropdownMenuItem(
                            child: Text("Acta de Entrega"), value: 5),
                        DropdownMenuItem(
                            child: Text("Carta de Responsabilidad"), value: 6),
                        DropdownMenuItem(
                            child: Text("Nombramiento (Reg/Mer)"), value: 7)
                      ],
                      onChanged: (value2) {
                        //setState(() {
                        print("Tipo de Envío");
                        print(seleccionTipo);
                        seleccionTipo = value2 as int;
                        print(seleccionTipo);
                        if (seleccionTipo == 1) {
                          _deleteFormDialog3(context);
                          var result = service.Subir_Info2(folioEmplacado)
                              .then((response) {
                                print("respuesta 600");
                                print(response);
                            if (response == 200) {
                              var result2 = service.Subir_InfoDB(folioEmplacado)
                                  .then((response2) {
                                if (response2 == 201) {
                                  Navigator.of(context).pop();
                                  _deleteFormDialog2(context);
                                } else {
                                  switch (response2) {
                                    case 400:
                                      Navigator.of(dialogContext).pop();
                                      _deleteFormDialog4(context);
                                      break;
                                    case 401:
                                      _showSuccesSnackBar(
                                          "No esta autorizado para ejecutar esta acción.",
                                          context);
                                      break;
                                    case 404:
                                      _showSuccesSnackBar(
                                          "Usuario o contraseña incorrectos.",
                                          context);
                                      break;
                                    case 500:
                                      _showSuccesSnackBar(
                                          "No se completo la petición intente mas tarde.",
                                          context);
                                      break;

                                  }
                                }
                                //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                              });

                            } else {
                              print("aqui tampoco llegó");
                              switch (response) {
                                case 400:
                                  Navigator.of(dialogContext).pop();
                                  _deleteFormDialog4(context);
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.",
                                      context);
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.",
                                      context);
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.",
                                      context);
                                  break;
                                case 600:
                                  print("llego hasta aquí 2");
                                  Navigator.of(context).pop();
                                  ErrorSubirArchivo(context);
                                  break;
                              }
                            }
                            Navigator.of(dialogContext).pop();
                          });
                        }
                        if (seleccionTipo == 2) {
                          _deleteFormDialog3(context);
                          var result = service.Subir_Info2(folioEmplacado)
                              .then((response) {
                            if (response == 200) {
                              print("acaba de entrar no.1");
                              var result2 =
                                  service.Subir_InfoDPI(folioEmplacado)
                                      .then((response2) {
                                if (response2 == 201) {
                                  print("acaba de entrar no.2");
                                  Navigator.of(context).pop();
                                  _deleteFormDialog2(context);
                                } else {
                                  print("acaba de entrar no.3");
                                  print(response2);
                                  switch (response2) {
                                    case 400:
                                      Navigator.of(dialogContext).pop();
                                      _deleteFormDialog4(context);
                                      break;
                                    case 401:
                                      _showSuccesSnackBar(
                                          "No esta autorizado para ejecutar esta acción.",
                                          context);
                                      break;
                                    case 404:
                                      _showSuccesSnackBar(
                                          "Usuario o contraseña incorrectos.",
                                          context);
                                      break;
                                    case 500:
                                      _showSuccesSnackBar(
                                          "No se completo la petición intente mas tarde.",
                                          context);
                                      break;
                                    case 600:
                                      _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                      break;
                                  }
                                }
                                //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                              });
                            } else {
                              switch (response) {
                                case 400:
                                  _deleteFormDialog4(context);
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.",
                                      context);
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.",
                                      context);
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.",
                                      context);
                                  break;
                                case 600:
                                  _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                  break;
                              }
                            }
                            Navigator.of(dialogContext).pop();
                          });
                        } else if (seleccionTipo == 3) {
                          _deleteFormDialog3(context);
                          var result = service.Subir_Info2(folioEmplacado)
                              .then((response) {
                            if (response == 200) {
                              print("acaba de entrar no.1");
                              var result2 =
                                  service.Subir_InfoFactura(folioEmplacado)
                                      .then((response2) {
                                if (response2 == 201) {
                                  print("acaba de entrar no.2");
                                  Navigator.of(context).pop();
                                  _deleteFormDialog2(context);
                                } else {
                                  print("acaba de entrar no.3");
                                  print(response2);
                                  switch (response2) {
                                    case 400:
                                      Navigator.of(dialogContext).pop();
                                      _deleteFormDialog4(context);
                                      break;
                                    case 401:
                                      _showSuccesSnackBar(
                                          "No esta autorizado para ejecutar esta acción.",
                                          context);
                                      break;
                                    case 404:
                                      _showSuccesSnackBar(
                                          "Usuario o contraseña incorrectos.",
                                          context);
                                      break;
                                    case 500:
                                      _showSuccesSnackBar(
                                          "No se completo la petición intente mas tarde.",
                                          context);
                                      break;
                                    case 600:
                                      _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                      break;
                                  }
                                }
                                //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                              });
                            } else {
                              switch (response) {
                                case 400:
                                  _deleteFormDialog4(context);
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.",
                                      context);
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.",
                                      context);
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.",
                                      context);
                                  break;
                                case 600:
                                  _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                  break;
                              }
                            }
                            Navigator.of(dialogContext).pop();
                          });
                        } else if (seleccionTipo == 4) {
                          _deleteFormDialog3(context);
                          var result = service.Subir_Info2(folioEmplacado)
                              .then((response) {
                            if (response == 200) {
                              print("acaba de entrar no.1");
                              var result2 =
                                  service.Subir_InfoRTU(folioEmplacado)
                                      .then((response2) {
                                if (response2 == 201) {
                                  print("acaba de entrar no.2");
                                  Navigator.of(context).pop();
                                  _deleteFormDialog2(context);
                                } else {
                                  print("acaba de entrar no.3");
                                  print(response2);
                                  switch (response2) {
                                    case 400:
                                      Navigator.of(dialogContext).pop();
                                      _deleteFormDialog4(context);
                                      break;
                                    case 401:
                                      _showSuccesSnackBar(
                                          "No esta autorizado para ejecutar esta acción.",
                                          context);
                                      break;
                                    case 404:
                                      _showSuccesSnackBar(
                                          "Usuario o contraseña incorrectos.",
                                          context);
                                      break;
                                    case 500:
                                      _showSuccesSnackBar(
                                          "No se completo la petición intente mas tarde.",
                                          context);
                                      break;
                                    case 600:
                                      _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                      break;
                                  }
                                }
                                //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                              });
                            } else {
                              switch (response) {
                                case 400:
                                  _deleteFormDialog4(context);
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.",
                                      context);
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.",
                                      context);
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.",
                                      context);
                                  break;
                                case 600:
                                  _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                  break;
                              }
                            }
                            Navigator.of(dialogContext).pop();
                          });
                        } else if (seleccionTipo == 5) {
                          _deleteFormDialog3(context);
                          var result = service.Subir_Info2(folioEmplacado)
                              .then((response) {
                            if (response == 200) {
                              print("acaba de entrar no.1");
                              var result2 =
                                  service.Subir_InfoActa(folioEmplacado)
                                      .then((response2) {
                                if (response2 == 201) {
                                  print("acaba de entrar no.2");
                                  Navigator.of(context).pop();
                                  _deleteFormDialog2(context);
                                } else {
                                  print("acaba de entrar no.3");
                                  print(response2);
                                  switch (response2) {
                                    case 400:
                                      Navigator.of(dialogContext).pop();
                                      _deleteFormDialog4(context);
                                      break;
                                    case 401:
                                      _showSuccesSnackBar(
                                          "No esta autorizado para ejecutar esta acción.",
                                          context);
                                      break;
                                    case 404:
                                      _showSuccesSnackBar(
                                          "Usuario o contraseña incorrectos.",
                                          context);
                                      break;
                                    case 500:
                                      _showSuccesSnackBar(
                                          "No se completo la petición intente mas tarde.",
                                          context);
                                      break;
                                    case 600:
                                      _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                      break;
                                  }
                                }
                                //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                              });
                            } else {
                              switch (response) {
                                case 400:
                                  _deleteFormDialog4(context);
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.",
                                      context);
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.",
                                      context);
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.",
                                      context);
                                  break;
                                case 600:
                                  _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                  break;
                              }
                            }
                            Navigator.of(dialogContext).pop();
                          });
                        } else if (seleccionTipo == 6) {
                          _deleteFormDialog3(context);
                          var result = service.Subir_Info2(folioEmplacado)
                              .then((response) {
                            if (response == 200) {
                              print("acaba de entrar no.1");
                              var result2 = service.Subir_InfoResponsabilidad(
                                      folioEmplacado)
                                  .then((response2) {
                                if (response2 == 201) {
                                  print("acaba de entrar no.2");
                                  Navigator.of(context).pop();
                                  _deleteFormDialog2(context);
                                } else {
                                  print("acaba de entrar no.3");
                                  print(response2);
                                  switch (response2) {
                                    case 400:
                                      Navigator.of(dialogContext).pop();
                                      _deleteFormDialog4(context);
                                      break;
                                    case 401:
                                      _showSuccesSnackBar(
                                          "No esta autorizado para ejecutar esta acción.",
                                          context);
                                      break;
                                    case 404:
                                      _showSuccesSnackBar(
                                          "Usuario o contraseña incorrectos.",
                                          context);
                                      break;
                                    case 500:
                                      _showSuccesSnackBar(
                                          "No se completo la petición intente mas tarde.",
                                          context);
                                      break;
                                    case 600:
                                      _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                      break;
                                  }
                                }
                                //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                              });
                            } else {
                              switch (response) {
                                case 400:
                                  _deleteFormDialog4(context);
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.",
                                      context);
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.",
                                      context);
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.",
                                      context);
                                  break;
                                case 600:
                                  _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                  break;
                              }
                            }
                            Navigator.of(dialogContext).pop();
                          });
                        } else if (seleccionTipo == 7) {
                          _deleteFormDialog3(context);
                          var result = service.Subir_Info2(folioEmplacado)
                              .then((response) {
                            if (response == 200) {
                              print("acaba de entrar no.1");
                              var result2 =
                                  service.Subir_InfoRegMer(folioEmplacado)
                                      .then((response2) {
                                if (response2 == 201) {
                                  print("acaba de entrar no.2");
                                  Navigator.of(context).pop();
                                  _deleteFormDialog2(context);
                                } else {
                                  print("acaba de entrar no.3");
                                  print(response2);
                                  switch (response2) {
                                    case 400:
                                      Navigator.of(dialogContext).pop();
                                      _deleteFormDialog4(context);
                                      break;
                                    case 401:
                                      _showSuccesSnackBar(
                                          "No esta autorizado para ejecutar esta acción.",
                                          context);
                                      break;
                                    case 404:
                                      _showSuccesSnackBar(
                                          "Usuario o contraseña incorrectos.",
                                          context);
                                      break;
                                    case 500:
                                      _showSuccesSnackBar(
                                          "No se completo la petición intente mas tarde.",
                                          context);
                                      break;
                                    case 600:
                                      _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                      break;
                                  }
                                }
                                //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                              });
                            } else {
                              switch (response) {
                                case 400:
                                  _deleteFormDialog4(context);
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.",
                                      context);
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.",
                                      context);
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.",
                                      context);
                                  break;
                                case 600:
                                  _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                  break;
                              }
                            }
                            Navigator.of(dialogContext).pop();
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Tipo de Envío Vacío';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: TipoCliente == 1 ? true : false,
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    key: UniqueKey(),
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      hint: Text('Selecciona tu tipo de envío'),
                      items: [
                        DropdownMenuItem(
                            child: Text("Archivo Completo"), value: 1),
                        DropdownMenuItem(child: Text("DPI"), value: 2),
                        DropdownMenuItem(child: Text("Factura"), value: 3),
                        DropdownMenuItem(child: Text("RTU"), value: 4),
                        DropdownMenuItem(
                            child: Text("Acta de Entrega"), value: 5),
                        DropdownMenuItem(
                            child: Text("Carta de Responsabilidad"), value: 6)
                      ],
                      onChanged: (value2) {
                        //setState(() {
                        print("Tipo de Envío");
                        print(seleccionTipo);
                        seleccionTipo = value2 as int;
                        print(seleccionTipo);
                        if (seleccionTipo == 1) {
                          _deleteFormDialog3(context);
                          var result = service.Subir_Info2(folioEmplacado)
                              .then((response) {
                            print("respuesta 600");
                            print(response);
                            if (response == 200) {
                              var result2 = service.Subir_InfoDB(folioEmplacado)
                                  .then((response2) {
                                if (response2 == 201) {
                                  Navigator.of(context).pop();
                                  _deleteFormDialog2(context);
                                } else {
                                  switch (response2) {
                                    case 400:
                                      Navigator.of(dialogContext).pop();
                                      _deleteFormDialog4(context);
                                      break;
                                    case 401:
                                      _showSuccesSnackBar(
                                          "No esta autorizado para ejecutar esta acción.",
                                          context);
                                      break;
                                    case 404:
                                      _showSuccesSnackBar(
                                          "Usuario o contraseña incorrectos.",
                                          context);
                                      break;
                                    case 500:
                                      _showSuccesSnackBar(
                                          "No se completo la petición intente mas tarde.",
                                          context);
                                      break;

                                  }
                                }
                                //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                              });

                            } else {
                              print("aqui tampoco llegó");
                              switch (response) {
                                case 400:
                                  Navigator.of(dialogContext).pop();
                                  _deleteFormDialog4(context);
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.",
                                      context);
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.",
                                      context);
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.",
                                      context);
                                  break;
                                case 600:
                                  print("llego hasta aquí 2");
                                  Navigator.of(context).pop();
                                  ErrorSubirArchivo(context);
                                  break;
                              }
                            }
                            Navigator.of(dialogContext).pop();
                          });
                        }
                        if (seleccionTipo == 2) {
                          _deleteFormDialog3(context);
                          var result = service.Subir_Info2(folioEmplacado)
                              .then((response) {
                            if (response == 200) {
                              print("acaba de entrar no.1");
                              var result2 =
                              service.Subir_InfoDPI(folioEmplacado)
                                  .then((response2) {
                                if (response2 == 201) {
                                  print("acaba de entrar no.2");
                                  Navigator.of(context).pop();
                                  _deleteFormDialog2(context);
                                } else {
                                  print("acaba de entrar no.3");
                                  print(response2);
                                  switch (response2) {
                                    case 400:
                                      Navigator.of(dialogContext).pop();
                                      _deleteFormDialog4(context);
                                      break;
                                    case 401:
                                      _showSuccesSnackBar(
                                          "No esta autorizado para ejecutar esta acción.",
                                          context);
                                      break;
                                    case 404:
                                      _showSuccesSnackBar(
                                          "Usuario o contraseña incorrectos.",
                                          context);
                                      break;
                                    case 500:
                                      _showSuccesSnackBar(
                                          "No se completo la petición intente mas tarde.",
                                          context);
                                      break;
                                    case 600:
                                      _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                      break;
                                  }
                                }
                                //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                              });
                            } else {
                              switch (response) {
                                case 400:
                                  _deleteFormDialog4(context);
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.",
                                      context);
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.",
                                      context);
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.",
                                      context);
                                  break;
                                case 600:
                                  _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                  break;
                              }
                            }
                            Navigator.of(dialogContext).pop();
                          });
                        } else if (seleccionTipo == 3) {
                          _deleteFormDialog3(context);
                          var result = service.Subir_Info2(folioEmplacado)
                              .then((response) {
                            if (response == 200) {
                              print("acaba de entrar no.1");
                              var result2 =
                              service.Subir_InfoFactura(folioEmplacado)
                                  .then((response2) {
                                if (response2 == 201) {
                                  print("acaba de entrar no.2");
                                  Navigator.of(context).pop();
                                  _deleteFormDialog2(context);
                                } else {
                                  print("acaba de entrar no.3");
                                  print(response2);
                                  switch (response2) {
                                    case 400:
                                      Navigator.of(dialogContext).pop();
                                      _deleteFormDialog4(context);
                                      break;
                                    case 401:
                                      _showSuccesSnackBar(
                                          "No esta autorizado para ejecutar esta acción.",
                                          context);
                                      break;
                                    case 404:
                                      _showSuccesSnackBar(
                                          "Usuario o contraseña incorrectos.",
                                          context);
                                      break;
                                    case 500:
                                      _showSuccesSnackBar(
                                          "No se completo la petición intente mas tarde.",
                                          context);
                                      break;
                                    case 600:
                                      _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                      break;
                                  }
                                }
                                //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                              });
                            } else {
                              switch (response) {
                                case 400:
                                  _deleteFormDialog4(context);
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.",
                                      context);
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.",
                                      context);
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.",
                                      context);
                                  break;
                                case 600:
                                  _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                  break;
                              }
                            }
                            Navigator.of(dialogContext).pop();
                          });
                        } else if (seleccionTipo == 4) {
                          _deleteFormDialog3(context);
                          var result = service.Subir_Info2(folioEmplacado)
                              .then((response) {
                            if (response == 200) {
                              print("acaba de entrar no.1");
                              var result2 =
                              service.Subir_InfoRTU(folioEmplacado)
                                  .then((response2) {
                                if (response2 == 201) {
                                  print("acaba de entrar no.2");
                                  Navigator.of(context).pop();
                                  _deleteFormDialog2(context);
                                } else {
                                  print("acaba de entrar no.3");
                                  print(response2);
                                  switch (response2) {
                                    case 400:
                                      Navigator.of(dialogContext).pop();
                                      _deleteFormDialog4(context);
                                      break;
                                    case 401:
                                      _showSuccesSnackBar(
                                          "No esta autorizado para ejecutar esta acción.",
                                          context);
                                      break;
                                    case 404:
                                      _showSuccesSnackBar(
                                          "Usuario o contraseña incorrectos.",
                                          context);
                                      break;
                                    case 500:
                                      _showSuccesSnackBar(
                                          "No se completo la petición intente mas tarde.",
                                          context);
                                      break;
                                    case 600:
                                      _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                      break;
                                  }
                                }
                                //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                              });
                            } else {
                              switch (response) {
                                case 400:
                                  _deleteFormDialog4(context);
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.",
                                      context);
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.",
                                      context);
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.",
                                      context);
                                  break;
                                case 600:
                                  _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                  break;
                              }
                            }
                            Navigator.of(dialogContext).pop();
                          });
                        } else if (seleccionTipo == 5) {
                          _deleteFormDialog3(context);
                          var result = service.Subir_Info2(folioEmplacado)
                              .then((response) {
                            if (response == 200) {
                              print("acaba de entrar no.1");
                              var result2 =
                              service.Subir_InfoActa(folioEmplacado)
                                  .then((response2) {
                                if (response2 == 201) {
                                  print("acaba de entrar no.2");
                                  Navigator.of(context).pop();
                                  _deleteFormDialog2(context);
                                } else {
                                  print("acaba de entrar no.3");
                                  print(response2);
                                  switch (response2) {
                                    case 400:
                                      Navigator.of(dialogContext).pop();
                                      _deleteFormDialog4(context);
                                      break;
                                    case 401:
                                      _showSuccesSnackBar(
                                          "No esta autorizado para ejecutar esta acción.",
                                          context);
                                      break;
                                    case 404:
                                      _showSuccesSnackBar(
                                          "Usuario o contraseña incorrectos.",
                                          context);
                                      break;
                                    case 500:
                                      _showSuccesSnackBar(
                                          "No se completo la petición intente mas tarde.",
                                          context);
                                      break;
                                    case 600:
                                      _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                      break;
                                  }
                                }
                                //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                              });
                            } else {
                              switch (response) {
                                case 400:
                                  _deleteFormDialog4(context);
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.",
                                      context);
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.",
                                      context);
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.",
                                      context);
                                  break;
                                case 600:
                                  _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                  break;
                              }
                            }
                            Navigator.of(dialogContext).pop();
                          });
                        } else if (seleccionTipo == 6) {
                          _deleteFormDialog3(context);
                          var result = service.Subir_Info2(folioEmplacado)
                              .then((response) {
                            if (response == 200) {
                              print("acaba de entrar no.1");
                              var result2 = service.Subir_InfoResponsabilidad(
                                  folioEmplacado)
                                  .then((response2) {
                                if (response2 == 201) {
                                  print("acaba de entrar no.2");
                                  Navigator.of(context).pop();
                                  _deleteFormDialog2(context);
                                } else {
                                  print("acaba de entrar no.3");
                                  print(response2);
                                  switch (response2) {
                                    case 400:
                                      Navigator.of(dialogContext).pop();
                                      _deleteFormDialog4(context);
                                      break;
                                    case 401:
                                      _showSuccesSnackBar(
                                          "No esta autorizado para ejecutar esta acción.",
                                          context);
                                      break;
                                    case 404:
                                      _showSuccesSnackBar(
                                          "Usuario o contraseña incorrectos.",
                                          context);
                                      break;
                                    case 500:
                                      _showSuccesSnackBar(
                                          "No se completo la petición intente mas tarde.",
                                          context);
                                      break;
                                    case 600:
                                      _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                      break;
                                  }
                                }
                                //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                              });
                            } else {
                              switch (response) {
                                case 400:
                                  _deleteFormDialog4(context);
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.",
                                      context);
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.",
                                      context);
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.",
                                      context);
                                  break;
                                case 600:
                                  _showSuccesSnackBar("Debe ingresar un archivo con extensión: .pdf, .jpg, .png o .jpeg", context);
                                  break;
                              }
                            }
                            Navigator.of(dialogContext).pop();
                          });
                        }
                        //});
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Tipo de Envío Vacío';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          );
        });
  }

  Future<void> DetalleBusqueda(
      BuildContext context, List<RespuestaBusqueda> _items2, int index) async {
    // ignore: prefer_equal_for_default_values
    //var formatter = new DateFormat('dd-MM-yyyy');
    print(index.toString());
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (context) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                SizedBox(
                  height: 10,
                ),
                Text("Detalles de Emplacado", style: TextStyle(fontSize: 25)),
                SizedBox(
                  height: 25,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Estado:                                   ",
                        style: TextStyle(color: Colors.black87),
                      ),
                      TextSpan(
                        text: _items2[index].idEstado.toString(),
                        style: TextStyle(
                            color: ValidarEstado(
                                _items2[index].idEstado.toString())),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Pedido:                               " +
                    _items2[index].idPedido.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("Nombre Completo:          " +
                    _items2[index].nombre.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("DPI:                                     " +
                    _items2[index].dpi.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("Sucursal:                            " +
                    _items2[index].idSucursal.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("Direccion:                          " +
                    _items2[index].direccion.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("Telefono:                           +502 " +
                    _items2[index].telefono.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("Chasis:                               " +
                    _items2[index].numeroSerie.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("Propietario:                       " +
                    _items2[index].nombre.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("Fecha Creación:               " +
                    _items2[index].horaFechaCreado.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("NIT:                                    " +
                    _items2[index].nit.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("Correo Electronico:          " +
                    _items2[index].correo.toString()),
                SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: _items2[index].idEstado == "Nuevos"
                      ? true
                      : _items2[index].idEstado == "Pendiente de Revisar"
                          ? true
                          : _items2[index].idEstado == "Documentos Rechazados"
                              ? true
                              : false,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TimelineDemoApp(
                                      folioEmplacado:
                                          _items2[index].folioEmplacado)),
                            );
                          },
                          child: Icon(Icons.comment_outlined,
                              size: 40, color: Colors.blueGrey)),
                      SizedBox(
                        width: 28,
                      ),
                      MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      update_info(_items2[index])),
                            );
                          },
                          child: Icon(Icons.update,
                              size: 40, color: Colors.blueGrey)),
                      SizedBox(
                        width: 30,
                      ),
                      MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      modalEnviar(_items2[index])),
                            );
                          },
                          child: Icon(Icons.upload,
                              size: 40, color: Colors.blueGrey)),
                    ],
                  ),
                ),
                Visibility(
                  visible: _items2[index].idEstado == "Nuevos"
                      ? true
                      : _items2[index].idEstado == "Pendiente de Revisar"
                          ? true
                          : _items2[index].idEstado == "Documentos Rechazados"
                              ? true
                              : false,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text("Comentarios",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: 45,
                      ),
                      Text("Actualizar",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: 35,
                      ),
                      Text("Subir Archivos",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: _items2[index].idEstado == "Nuevos"
                      ? true
                      : _items2[index].idEstado == "Pendiente de Revisar"
                          ? true
                          : _items2[index].idEstado == "Documentos Rechazados"
                              ? true
                              : false,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Revision(_items2[index])),
                            );
                          },
                          child: Icon(Icons.remove_red_eye_outlined,
                              size: 40, color: Colors.blueGrey)),
                      SizedBox(
                        width: 35,
                      ),
                      MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => busqueda2(
                                      folioEmplacado:
                                          _items2[index].folioEmplacado)),
                            );
                          },
                          child: Icon(Icons.view_list_outlined,
                              size: 40, color: Colors.blueGrey)),
                      SizedBox(
                        width: 35,
                      ),
                      MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PasosRevision(
                                      _items2[index].folioEmplacado)),
                            );
                          },
                          child: Icon(Icons.amp_stories_outlined,
                              size: 40, color: Colors.blueGrey)),
                    ],
                  ),
                ),
                Visibility(
                  visible: _items2[index].idEstado == "Nuevos"
                      ? true
                      : _items2[index].idEstado == "Pendiente de Revisar"
                          ? true
                          : _items2[index].idEstado == "Documentos Rechazados"
                              ? true
                              : false,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text("Revisión",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: 50,
                      ),
                      Text("Ver Archivos",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: 48,
                      ),
                      Text("Ver Status",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Visibility(
                  visible: _items2[index].idEstado == "Documentos Aceptados"
                      ? true
                      : _items2[index].idEstado == "En Pagos"
                          ? true
                          : _items2[index].idEstado == "Enviado a SAT"
                              ? true
                              : _items2[index].idEstado == "En Italika"
                                  ? true
                                  : _items2[index].idEstado ==
                                          "Entregado al Cliente"
                                      ? true
                                      : false,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                      ),
                      MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PasosRevision(
                                      _items2[index].folioEmplacado)),
                            );
                          },
                          child: Icon(Icons.amp_stories_outlined,
                              size: 40, color: Colors.blueGrey)),
                      SizedBox(
                        width: 70,
                      ),
                      MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TimelineDemoApp(
                                      folioEmplacado:
                                          _items2[index].folioEmplacado)),
                            );
                          },
                          child: Icon(Icons.comment_outlined,
                              size: 40, color: Colors.blueGrey)),
                    ],
                  ),
                ),
                Visibility(
                  visible: _items2[index].idEstado == "Documentos Aceptados" ? true : _items2[index].idEstado == "En Pagos" ? true : _items2[index].idEstado == "Enviado a SAT" ? true : _items2[index].idEstado == "En Italika" ? true : _items2[index].idEstado == "Entregado al Cliente" ? true : false,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 58,
                      ),
                      Text("Ver Status",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: 90,
                      ),
                      Text("Comentarios",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Visibility(
                  visible: _items2[index].idEstado == "Enviado a Sucursal"
                      ? true
                      : false,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                      ),
                      MaterialButton(
                          onPressed: () async {
                            //_alertdialog(Lista3[index].folioEmplacado);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PaginaFirma(_items2[index])),
                            );
                          },
                          child: Icon(Icons.grid_view_rounded,
                              size: 40, color: Colors.blueGrey)),
                      SizedBox(
                        width: 70,
                      ),
                      MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TimelineDemoApp(
                                      folioEmplacado:
                                          _items2[index].folioEmplacado)),
                            );
                          },
                          child: Icon(Icons.comment_outlined,
                              size: 40, color: Colors.blueGrey)),
                    ],
                  ),
                ),
                Visibility(
                  visible: _items2[index].idEstado == "Enviado a Sucursal" ? true : false,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                      ),
                      Text("Entregar Placa",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: 72,
                      ),
                      Text("Comentarios",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: _items2[index].idEstado == "Enviado a Sucursal"
                      ? true
                      : false,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                      ),
                      MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PasosRevision(
                                      _items2[index].folioEmplacado)),
                            );
                          },
                          child: Icon(Icons.amp_stories_outlined,
                              size: 40, color: Colors.blueGrey)),
                      SizedBox(
                        width: 70,
                      ),
                      MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => busqueda2(
                                      folioEmplacado:
                                          _items2[index].folioEmplacado)),
                            );
                          },
                          child: Icon(Icons.view_list_outlined,
                              size: 40, color: Colors.blueGrey)),
                    ],
                  ),
                ),
                Visibility(
                  visible: _items2[index].idEstado == "Enviado a Sucursal"
                      ? true
                      : false,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 58,
                      ),
                      Text("Ver Estatus",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: 80,
                      ),
                      Text("Ver Archivos",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        });
  }

  ValidarEstado(String Estado) {
    if (Estado == "Nuevos") {
      return Colors.blue;
    } else if (Estado == "Documentos Aceptados") {
      return Colors.green;
    } else if (Estado == "Documentos Rechazados") {
      return Colors.red;
    } else if (Estado == "En Pagos") {
      return Colors.teal;
    } else if (Estado == "Enviado a SAT") {
      return Colors.blue;
    } else if (Estado == "En Italika") {
      return Colors.blue[900];
    } else if (Estado == "Placa en Sucursal") {
      return Colors.red[900];
    } else if (Estado == "Placa Entregada a Cliente") {
      return Colors.green[800];
    } else if (Estado == "Pendiente de Revisar") {
      return Colors.yellow[900];
    }
  }

  ValidarEstado2(int Estado) {
    if (Estado == 8) {
      return "Nuevos";
    } else if (Estado == 1) {
      return "Documentos Aceptados";
    } else if (Estado == 2) {
      return "Documentos Rechazados";
    } else if (Estado == 3) {
      return "En Pagos";
    } else if (Estado == 4) {
      return "Enviado a SAT";
    } else if (Estado == 5) {
      return "En Italika";
    } else if (Estado == 6) {
      return "Placa en Sucursal";
    } else if (Estado == 7) {
      return "Placa Entregada a Cliente";
    } else if (Estado == 0) {
      return "Pendiente de Revisar";
    }
  }
}
