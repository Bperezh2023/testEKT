import 'dart:ffi';
import 'package:app_itk4/Screens/Imageness.dart';
import 'package:app_itk4/Screens/pasos.dart';
import 'package:app_itk4/Screens/revision.dart';
import 'package:app_itk4/Screens/upload_file.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/ModelBusqueda.dart';
import '../model/ModeloService.dart';
import '../model/ModeloService.dart';
import '../model/User.dart';
import '../model/modelApi.dart';
import '../model/modelRespBusqueda.dart';
import '../services/userService.dart';
import 'package:alert_dialog/alert_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Comments.dart';
import 'busqueda2.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'modalEnviar.dart';

class Busqueda extends StatefulWidget {
  const Busqueda({Key? key}) : super(key: key);

  @override
  State<Busqueda> createState() => _BusquedaState();
}

class _BusquedaState extends State<Busqueda> {
  List<RespuestaBusqueda> Lista3 = <RespuestaBusqueda>[];
  String resulbusqueda = "";
  bool rPedidos = true;
  bool rNIT = false;
  bool rFechas1 = false;
  bool rFechas2 = false;
  bool control = false;
  int seleccionTipo = 0;
  final service = UserService();
  bool _isSearching = false;
  bool _isSearching2 = false;
  bool isVisible = false;
  bool exito = false;
  int RadioGroup = 1;
  int RadioGroup2 = 20;
  late BuildContext dialogContext;// global declaration
  List<RespuestaBusqueda> List1 = <RespuestaBusqueda>[];
  List<RespuestaBusquedaSimple> List2 = <RespuestaBusquedaSimple>[];
  late BuildContext dialogContext20;// global declaration
  late BuildContext dialogContext21;// global declaration
  late BuildContext dialogContext22;// global declaration
  late BuildContext dialogContext23;// global declaration
  late BuildContext dialogContext2;// global declaration
  late BuildContext dialogContext3;// global
  List<ResumeModel> listResume = <ResumeModel>[];
  final _tfPedidos = TextEditingController();
  final _tfNIT = TextEditingController();
  final _tfFechas = TextEditingController();
  final _tfFechas2 = TextEditingController();
  var _items = [];
  late List<User> _userList;
  var id;
  final _keyForm = GlobalKey<FormState>();

  createUuid() {
    const uuid = Uuid();
    //Create UUID version-4
    return uuid.v4();
  }

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/sample.json');
    final data = await json.decode(response);
    setState(() {
    });
  }

  _showSuccesSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String? _validateTextField(String value) {
    if (value.isEmpty) {
      return 'Por favor, ingrese un valor';
    }
    return null;
  }

  ErrorBusqueda(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          dialogContext20 = context;
          return AlertDialog(
            title: Text("Error al encontrar emplacado",
              style: TextStyle(color: Colors.teal, fontSize: 25),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('No se pudo encontrar el emplacado, favor intente nuevamente',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Aceptar',
                  style: TextStyle(color: Colors.teal, fontSize: 16),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  ErrorSubirArchivo(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          dialogContext21 = context;
          return AlertDialog(
            title: Text("Error al cargar el emplacado",
              style: TextStyle(color: Colors.teal, fontSize: 25),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('La extensión debe ser .pdf o .jpg, intenta nuevamente',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Aceptar',
                  style: TextStyle(color: Colors.teal, fontSize: 16),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  _deleteFormDialog3(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          dialogContext = context;
          return AlertDialog(
            scrollable: true,
            title: Text("   Subiendo Archivo",
              style: TextStyle(color: Colors.blueGrey, fontSize: 25),
            ),
            actions: [
              SpinKitFadingCircle(
                size: 100,
                color: Colors.blue[900],
              ),
            ],
          );
        }
    );
  }

  _deleteFormDialog4(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          dialogContext22 = context;
          return AlertDialog(
            title: Text("Error al Cargar el Archivo",
              style: TextStyle(color: Colors.teal, fontSize: 25),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Tu archivo no se pudo subir con éxito, intentalo de nuevo.',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Aceptar',
                  style: TextStyle(color: Colors.teal, fontSize: 16),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }


  _deleteFormDialog2(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          dialogContext2 = context;
          return AlertDialog(
            title: Text("Carga de Archivo",
              style: TextStyle(color: Colors.teal, fontSize: 25),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('¡Tu archivo se ha subido con éxito!: ',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Aceptar',
                  style: TextStyle(color: Colors.teal, fontSize: 16),
                ),
                onPressed: () async {

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  _alertdialog(String folioEmplacado, int TipoCliente) {
    print("tipo de cliente");
    print(TipoCliente);
    showDialog(
        context: context,
        builder: (BuildContext context){
          dialogContext3 = context;
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
              Row(
                children: [
                  const SizedBox(
                    width: 75.0,
                  ),
                  Radio(
                      value: 10,
                      groupValue: RadioGroup2,
                      onChanged: (value) {
                        setState(() {
                          RadioGroup2 = 10;
                        });
                      }),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Text("SI"),
                  const SizedBox(
                    width: 50.0,
                  ),
                  Radio(
                      value: 20,
                      groupValue: RadioGroup2,
                      onChanged: (value) {
                        setState(() {
                          RadioGroup2 = 20;

                        });
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
                      DropdownMenuItem(child: Text("Archivo Completo") , value: 1),
                      DropdownMenuItem(child: Text("DPI") , value: 2),
                      DropdownMenuItem(child: Text("Factura") , value: 3),
                      DropdownMenuItem(child: Text("RTU") , value: 4),
                      DropdownMenuItem(child: Text("Acta de Entrega") , value: 5),
                      DropdownMenuItem(child: Text("Carta de Responsabilidad") , value: 6),
                      DropdownMenuItem(child: Text("Nombramiento (Reg/Mer)") , value: 7)
                    ], onChanged: (value2) {
                    //setState(() {
                      print("Tipo de Envío");
                      print(seleccionTipo);
                      seleccionTipo = value2 as int;
                      print(seleccionTipo);
                      if(seleccionTipo == 1){
                        Navigator.of(context).pop();
                        _deleteFormDialog3();
                        var result =  service.Subir_Info2(folioEmplacado).then((response){
                          print("respuesta 600");
                          print(response);
                          if(response == 200){
                            print("acaba de entrar no.1");
                            var result2 =  service.Subir_InfoDB(folioEmplacado).then((response2){
                              if(response2 == 201){
                                print("acaba de entrar no.2");
                                _deleteFormDialog2();
                              }else{
                                print("acaba de entrar no.3");
                                print(response2);
                                switch(response2){
                                  case 400:
                                    _deleteFormDialog4();
                                    break;
                                  case 401:
                                    _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                    break;
                                  case 404:
                                    _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                    break;
                                  case 500:
                                    _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                    break;
                                }
                              }
                              //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                            });
                          }else{
                            switch(response){
                              case 400:
                                Navigator.of(dialogContext).pop();
                                _deleteFormDialog4();
                                break;
                              case 401:
                                _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                break;
                              case 404:
                                _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                break;
                              case 500:
                                _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                break;
                              case 600:
                                Navigator.of(dialogContext).pop();
                                _deleteFormDialog4();
                                break;
                            }
                          }
                          Navigator.of(dialogContext).pop();
                        });
                      }
                      if(seleccionTipo == 2){
                        Navigator.of(context).pop();
                        _deleteFormDialog3();
                        var result =  service.Subir_Info2(folioEmplacado).then((response){
                          if(response == 200){
                            print("acaba de entrar no.1");
                            var result2 =  service.Subir_InfoDPI(folioEmplacado).then((response2){
                              if(response2 == 201){
                                print("acaba de entrar no.2");
                                _deleteFormDialog2();
                              }else{
                                print("acaba de entrar no.3");
                                print(response2);
                                switch(response2){
                                  case 400:
                                    _deleteFormDialog4();
                                    break;
                                  case 401:
                                    _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                    break;
                                  case 404:
                                    _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                    break;
                                  case 500:
                                    _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                    break;
                                }
                              }
                              //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                            });

                          }else{
                            switch(response){
                              case 400:
                                _deleteFormDialog4();
                                break;
                              case 401:
                                _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                break;
                              case 404:
                                _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                break;
                              case 500:
                                _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                break;
                            }
                          }
                          Navigator.of(dialogContext).pop();
                        });
                      }
                      else if(seleccionTipo == 3){
                        Navigator.of(context).pop();
                        _deleteFormDialog3();
                        var result =  service.Subir_Info2(folioEmplacado).then((response){
                          if(response == 200){
                            print("acaba de entrar no.1");
                            var result2 =  service.Subir_InfoFactura(folioEmplacado).then((response2){
                              if(response2 == 201){
                                print("acaba de entrar no.2");
                                _deleteFormDialog2();
                              }else{
                                print("acaba de entrar no.3");
                                print(response2);
                                switch(response2){
                                  case 400:
                                    _deleteFormDialog4();
                                    break;
                                  case 401:
                                    _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                    break;
                                  case 404:
                                    _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                    break;
                                  case 500:
                                    _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                    break;
                                }
                              }
                              //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                            });

                          }else{
                            switch(response){
                              case 400:
                                _deleteFormDialog4();
                                break;
                              case 401:
                                _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                break;
                              case 404:
                                _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                break;
                              case 500:
                                _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                break;
                            }
                          }
                          Navigator.of(dialogContext).pop();
                        });
                      }
                      else if(seleccionTipo == 4){
                        Navigator.of(context).pop();
                        _deleteFormDialog3();
                        var result =  service.Subir_Info2(folioEmplacado).then((response){
                          if(response == 200){
                            print("acaba de entrar no.1");
                            var result2 =  service.Subir_InfoRTU(folioEmplacado).then((response2){
                              if(response2 == 201){
                                print("acaba de entrar no.2");
                                _deleteFormDialog2();
                              }else{
                                print("acaba de entrar no.3");
                                print(response2);
                                switch(response2){
                                  case 400:
                                    _deleteFormDialog4();
                                    break;
                                  case 401:
                                    _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                    break;
                                  case 404:
                                    _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                    break;
                                  case 500:
                                    _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                    break;
                                }
                              }
                              //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                            });

                          }else{
                            switch(response){
                              case 400:
                                _deleteFormDialog4();
                                break;
                              case 401:
                                _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                break;
                              case 404:
                                _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                break;
                              case 500:
                                _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                break;
                            }
                          }
                          Navigator.of(dialogContext).pop();
                        });
                      }
                      else if(seleccionTipo == 5){
                        Navigator.of(context).pop();
                        _deleteFormDialog3();
                        var result =  service.Subir_Info2(folioEmplacado).then((response){
                          if(response == 200){
                            print("acaba de entrar no.1");
                            var result2 =  service.Subir_InfoActa(folioEmplacado).then((response2){
                              if(response2 == 201){
                                print("acaba de entrar no.2");
                                _deleteFormDialog2();
                              }else{
                                print("acaba de entrar no.3");
                                print(response2);
                                switch(response2){
                                  case 400:
                                    _deleteFormDialog4();
                                    break;
                                  case 401:
                                    _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                    break;
                                  case 404:
                                    _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                    break;
                                  case 500:
                                    _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                    break;
                                }
                              }
                              //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                            });

                          }else{
                            switch(response){
                              case 400:
                                _deleteFormDialog4();
                                break;
                              case 401:
                                _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                break;
                              case 404:
                                _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                break;
                              case 500:
                                _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                break;
                            }
                          }
                          Navigator.of(dialogContext).pop();
                        });
                      }
                      else if(seleccionTipo == 6){
                        Navigator.of(context).pop();
                        _deleteFormDialog3();
                        var result =  service.Subir_Info2(folioEmplacado).then((response){
                          if(response == 200){
                            print("acaba de entrar no.1");
                            var result2 =  service.Subir_InfoResponsabilidad(folioEmplacado).then((response2){
                              if(response2 == 201){
                                print("acaba de entrar no.2");
                                _deleteFormDialog2();
                              }else{
                                print("acaba de entrar no.3");
                                print(response2);
                                switch(response2){
                                  case 400:
                                    _deleteFormDialog4();
                                    break;
                                  case 401:
                                    _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                    break;
                                  case 404:
                                    _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                    break;
                                  case 500:
                                    _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                    break;
                                }
                              }
                              //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                            });

                          }else{
                            switch(response){
                              case 400:
                                _deleteFormDialog4();
                                break;
                              case 401:
                                _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                break;
                              case 404:
                                _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                break;
                              case 500:
                                _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                break;
                            }
                          }
                          Navigator.of(dialogContext).pop();
                        });
                      }
                      else if(seleccionTipo == 7){
                        Navigator.of(context).pop();
                        _deleteFormDialog3();
                        var result =  service.Subir_Info2(folioEmplacado).then((response){
                          if(response == 200){
                            print("acaba de entrar no.1");
                            var result2 =  service.Subir_InfoRegMer(folioEmplacado).then((response2){
                              if(response2 == 201){
                                print("acaba de entrar no.2");
                                _deleteFormDialog2();
                              }else{
                                print("acaba de entrar no.3");
                                print(response2);
                                switch(response2){
                                  case 400:
                                    _deleteFormDialog4();
                                    break;
                                  case 401:
                                    _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                    break;
                                  case 404:
                                    _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                    break;
                                  case 500:
                                    _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                    break;
                                }
                              }
                              //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                            });

                          }else{
                            switch(response){
                              case 400:
                                _deleteFormDialog4();
                                break;
                              case 401:
                                _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                break;
                              case 404:
                                _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                break;
                              case 500:
                                _showSuccesSnackBar("No se completo la petición intente mas tarde.");
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
              Visibility(
                visible: TipoCliente == 1 ? true : false,
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    key: UniqueKey(),
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      hint: Text('Selecciona tu tipo de envío'),
                      items: [
                        DropdownMenuItem(child: Text("Archivo Completo") , value: 1),
                        DropdownMenuItem(child: Text("DPI") , value: 2),
                        DropdownMenuItem(child: Text("Factura") , value: 3),
                        DropdownMenuItem(child: Text("RTU") , value: 4),
                        DropdownMenuItem(child: Text("Acta de Entrega") , value: 5),
                        DropdownMenuItem(child: Text("Carta de Responsabilidad") , value: 6)
                      ], onChanged: (value2) {
                      //setState(() {
                        print("Tipo de Envío");
                        print(seleccionTipo);
                        seleccionTipo = value2 as int;
                        print(seleccionTipo);
                        if(seleccionTipo == 1){
                          Navigator.of(context).pop();
                          _deleteFormDialog3();
                          var result =  service.Subir_Info2(folioEmplacado).then((response){
                            if(response == 200){
                              print("acaba de entrar no.1");
                              var result2 =  service.Subir_InfoDB(folioEmplacado).then((response2){
                                if(response2 == 201){
                                  print("acaba de entrar no.2");
                                  _deleteFormDialog2();
                                }else{
                                  print("acaba de entrar no.3");
                                  print(response2);
                                  switch(response2){
                                    case 400:
                                      _deleteFormDialog4();
                                      break;
                                    case 401:
                                      _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                      break;
                                    case 404:
                                      _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                      break;
                                    case 500:
                                      _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                      break;
                                  }
                                }
                                //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                              });

                            }else{
                              switch(response){
                                case 400:
                                  _deleteFormDialog4();
                                  break;
                                case 401:
                                  _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                  break;
                                case 404:
                                  _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                  break;
                                case 500:
                                  _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                  break;
                              }
                            }
                            Navigator.of(dialogContext).pop();
                          });
                        }
                        if(seleccionTipo == 2){
                          Navigator.of(context).pop();
                          _deleteFormDialog3();
                          var result =  service.Subir_Info2(folioEmplacado).then((response){
                            if(response == 200){
                              print("acaba de entrar no.1");
                              var result2 =  service.Subir_InfoDPI(folioEmplacado).then((response2){
                                if(response2 == 201){
                                  print("acaba de entrar no.2");
                                  _deleteFormDialog2();
                                }else{
                                  print("acaba de entrar no.3");
                                  print(response2);
                                  switch(response2){
                                    case 400:
                                      _deleteFormDialog4();
                                      break;
                                    case 401:
                                      _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                      break;
                                    case 404:
                                      _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                      break;
                                    case 500:
                                      _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                      break;
                                  }
                                }
                                //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                              });

                            }else{
                              switch(response){
                                case 400:
                                  _deleteFormDialog4();
                                  break;
                                case 401:
                                  _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                  break;
                                case 404:
                                  _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                  break;
                                case 500:
                                  _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                  break;
                              }
                            }
                            Navigator.of(dialogContext).pop();
                          });
                        }
                        else if(seleccionTipo == 3){
                          Navigator.of(context).pop();
                          _deleteFormDialog3();
                          var result =  service.Subir_Info2(folioEmplacado).then((response){
                            if(response == 200){
                              print("acaba de entrar no.1");
                              var result2 =  service.Subir_InfoFactura(folioEmplacado).then((response2){
                                if(response2 == 201){
                                  print("acaba de entrar no.2");
                                  _deleteFormDialog2();
                                }else{
                                  print("acaba de entrar no.3");
                                  print(response2);
                                  switch(response2){
                                    case 400:
                                      _deleteFormDialog4();
                                      break;
                                    case 401:
                                      _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                      break;
                                    case 404:
                                      _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                      break;
                                    case 500:
                                      _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                      break;
                                  }
                                }
                                //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                              });

                            }else{
                              switch(response){
                                case 400:
                                  _deleteFormDialog4();
                                  break;
                                case 401:
                                  _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                  break;
                                case 404:
                                  _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                  break;
                                case 500:
                                  _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                  break;
                              }
                            }
                            Navigator.of(dialogContext).pop();
                          });
                        }
                        else if(seleccionTipo == 4){
                          Navigator.of(context).pop();
                          _deleteFormDialog3();
                          var result =  service.Subir_Info2(folioEmplacado).then((response){
                            if(response == 200){
                              print("acaba de entrar no.1");
                              var result2 =  service.Subir_InfoRTU(folioEmplacado).then((response2){
                                if(response2 == 201){
                                  print("acaba de entrar no.2");
                                  _deleteFormDialog2();
                                }else{
                                  print("acaba de entrar no.3");
                                  print(response2);
                                  switch(response2){
                                    case 400:
                                      _deleteFormDialog4();
                                      break;
                                    case 401:
                                      _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                      break;
                                    case 404:
                                      _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                      break;
                                    case 500:
                                      _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                      break;
                                  }
                                }
                                //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                              });

                            }else{
                              switch(response){
                                case 400:
                                  _deleteFormDialog4();
                                  break;
                                case 401:
                                  _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                  break;
                                case 404:
                                  _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                  break;
                                case 500:
                                  _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                  break;
                              }
                            }
                            Navigator.of(dialogContext).pop();
                          });
                        }
                        else if(seleccionTipo == 5){
                          Navigator.of(context).pop();
                          _deleteFormDialog3();
                          var result =  service.Subir_Info2(folioEmplacado).then((response){
                            if(response == 200){
                              print("acaba de entrar no.1");
                              var result2 =  service.Subir_InfoActa(folioEmplacado).then((response2){
                                if(response2 == 201){
                                  print("acaba de entrar no.2");
                                  _deleteFormDialog2();
                                }else{
                                  print("acaba de entrar no.3");
                                  print(response2);
                                  switch(response2){
                                    case 400:
                                      _deleteFormDialog4();
                                      break;
                                    case 401:
                                      _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                      break;
                                    case 404:
                                      _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                      break;
                                    case 500:
                                      _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                      break;
                                  }
                                }
                                //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                              });

                            }else{
                              switch(response){
                                case 400:
                                  _deleteFormDialog4();
                                  break;
                                case 401:
                                  _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                  break;
                                case 404:
                                  _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                  break;
                                case 500:
                                  _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                  break;
                              }
                            }
                            Navigator.of(dialogContext).pop();
                          });
                        }
                        else if(seleccionTipo == 6){
                          Navigator.of(context).pop();
                          _deleteFormDialog3();
                          var result =  service.Subir_Info2(folioEmplacado).then((response){
                            if(response == 200){
                              print("acaba de entrar no.1");
                              var result2 =  service.Subir_InfoResponsabilidad(folioEmplacado).then((response2){
                                if(response2 == 201){
                                  print("acaba de entrar no.2");
                                  _deleteFormDialog2();
                                }else{
                                  print("acaba de entrar no.3");
                                  print(response2);
                                  switch(response2){
                                    case 400:
                                      _deleteFormDialog4();
                                      break;
                                    case 401:
                                      _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                      break;
                                    case 404:
                                      _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                      break;
                                    case 500:
                                      _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                      break;
                                  }
                                }
                                //var resultado =  service.ActualizacionEntregas2(folioEmplacado);
                              });

                            }else{
                              switch(response){
                                case 400:
                                  _deleteFormDialog4();
                                  break;
                                case 401:
                                  _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                  break;
                                case 404:
                                  _showSuccesSnackBar("Usuario o contraseña incorrectos.");
                                  break;
                                case 500:
                                  _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                  break;
                              }
                            }
                            Navigator.of(dialogContext).pop();
                          });
                        }
                     // });
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
        }
    );
  }



  Future<void> DetalleBusqueda(BuildContext context,  List<RespuestaBusqueda> _items2, int index) async {
    // ignore: prefer_equal_for_default_values
    //var formatter = new DateFormat('dd-MM-yyyy');
    print(index.toString());
    print("idEstado2");
    print(_items2[index].idEstado);
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
                        text:  _items2[index].idEstado.toString(),
                        style: TextStyle(color:ValidarEstado(_items2[index].idEstado.toString())) ,

                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Pedido:                               " + _items2[index].idPedido.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("Nombre Completo:          " + _items2[index].nombre.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("DPI:                                     " + _items2[index].dpi.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("Sucursal:                            " + _items2[index].idSucursal.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("Direccion:                          " + _items2[index].direccion.toString()),
                SizedBox(

                  height: 10,
                ),
                Text("Telefono:                           +502 " + _items2[index].telefono.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("Chasis:                               " + _items2[index].numeroSerie.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("Propietario:                       " + _items2[index].nombre.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("Fecha Creación:               " + _items2[index].horaFechaCreado.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("NIT:                                    " + _items2[index].nit.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("Correo Electronico:          " + _items2[index].correo.toString()),
                SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: _items2[index].idEstado == "Nuevos" ? true : _items2[index].idEstado == "Pendiente de Revisar" ? true : _items2[index].idEstado == "Documentos Rechazados" ? true : false,
                  child:Row(
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
                                        folioEmplacado: _items2[index].folioEmplacado)),
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
                  visible: _items2[index].idEstado == "Nuevos" ? true : _items2[index].idEstado == "Pendiente de Revisar" ? true : _items2[index].idEstado == "Documentos Rechazados" ? true : false,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text("Comentarios", style: TextStyle(
                            fontWeight: FontWeight.w500)),
                        SizedBox(
                          width: 45,
                        ),
                        Text("Actualizar", style: TextStyle(
                            fontWeight: FontWeight.w500)),
                        SizedBox(
                          width: 35,
                        ),
                        Text("Subir Archivos", style: TextStyle(
                            fontWeight: FontWeight.w500)),
                      ],
                    ),
                ),
                SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: _items2[index].idEstado == "Nuevos" ? true : _items2[index].idEstado == "Pendiente de Revisar" ? true : _items2[index].idEstado == "Documentos Rechazados" ? true : false,
                    child:Row(
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
                                MaterialPageRoute(builder: (context) => busqueda2(folioEmplacado: _items2[index].folioEmplacado)),
                              );
                            },
                            child: Icon(Icons.view_list_outlined, size: 40, color: Colors.blueGrey)),
                        SizedBox(
                          width: 35,
                        ),
                        MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PasosRevision(_items2[index].folioEmplacado)),
                              );
                            },
                            child: Icon(Icons.amp_stories_outlined, size: 40, color: Colors.blueGrey)),
                      ],
                    ),
                ),

                Visibility(
                  visible: _items2[index].idEstado == "Nuevos" ? true : _items2[index].idEstado == "Pendiente de Revisar" ? true : _items2[index].idEstado == "Documentos Rechazados" ? true : false,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text("Revisión", style: TextStyle(
                            fontWeight: FontWeight.w500)),
                        SizedBox(
                          width: 50,
                        ),
                        Text("Ver Archivos", style: TextStyle(
                            fontWeight: FontWeight.w500)),
                        SizedBox(
                          width: 48,
                        ),
                        Text("Ver Status", style: TextStyle(
                            fontWeight: FontWeight.w500)),
                      ],
                    ),
                ),
                Visibility(
                    visible: _items2[index].idEstado == "Documentos Aceptados" ? true : _items2[index].idEstado == "En Pagos" ? true : _items2[index].idEstado == "Enviado a SAT" ? true : _items2[index].idEstado == "En Italika" ? true : _items2[index].idEstado == "Enviado a Sucursal" ? true : _items2[index].idEstado == "Entregado al Cliente" ? true : false,
                    child:  Row(
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PasosRevision(_items2[index].folioEmplacado)),
                              );
                            },
                            child: Icon(Icons.amp_stories_outlined, size: 40, color: Colors.blueGrey)),
                        SizedBox(
                          width: 70,
                        ),
                        MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TimelineDemoApp(
                                        folioEmplacado: _items2[index].folioEmplacado)),
                              );
                            },
                            child: Icon(Icons.comment_outlined,
                                size: 40, color: Colors.blueGrey)),
                      ],
                    ),
                ),
                Visibility(
                    visible: _items2[index].idEstado == "Documentos Aceptados" ? true : _items2[index].idEstado == "En Pagos" ? true : _items2[index].idEstado == "Enviado a SAT" ? true : _items2[index].idEstado == "En Italika" ? true : _items2[index].idEstado == "Enviado a Sucursal" ? true : _items2[index].idEstado == "Entregado al Cliente" ? true : false,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 58,
                        ),
                        Text("Ver Status", style: TextStyle(
                            fontWeight: FontWeight.w500)),
                        SizedBox(
                          width: 90,
                        ),
                        Text("Comentarios", style: TextStyle(
                            fontWeight: FontWeight.w500)),
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
          'Descarga y Carga de Archivos',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const Text(
              'Elige tu método de Busqueda',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 50.0,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 31.0,
                ),
                Radio(
                    value: 1,
                    groupValue: RadioGroup,
                    onChanged: (value) {
                      setState(() {
                        RadioGroup = 1;
                        rPedidos = true;
                        rNIT = false;
                        rFechas1 = false;
                        rFechas2 = false;
                        //_fechaIniSel.clear();
                        _tfNIT.clear();
                        _tfFechas.clear();
                        _tfFechas2.clear();
                        List2.clear();
                        ;
                      });
                    }),
                const SizedBox(
                  height: 50.0,
                ),
                Text("PEDIDOS"),
                Radio(
                    value: 2,
                    groupValue: RadioGroup,
                    onChanged: (value) {
                      setState(() {
                        RadioGroup = 2;
                        rPedidos = false;
                        rNIT = true;
                        rFechas1 = false;
                        rFechas2 = false;
                        //fechaIniSel = "";
                        //fechaFinSel = "";
                        //fechaIni.clear();
                        //fechaFin.clear();
                        //Nit.clear();
                        _tfPedidos.clear();
                        _tfFechas.clear();
                        _tfFechas2.clear();
                        List2.clear();
                      });
                    }),
                Text("NIT"),
                const SizedBox(
                  height: 50.0,
                ),
                Radio(
                    value: 3,
                    groupValue: RadioGroup,
                    onChanged: (value) {
                      setState(() {
                        RadioGroup = 3;
                        rPedidos = false;
                        rNIT = false;
                        rFechas1 = true;
                        rFechas2 = true;
                        List2.clear();
                        _tfPedidos.clear();
                        _tfFechas.clear();
                        _tfFechas2.clear();
                        //fechaIniSel = "";
                        //fechaFinSel = "";
                        //fechaIni.clear();
                        //fechaFin.clear();
                        //Nit.clear();
                            ;
                      });
                    }),
                Text("DPI"),
              ],
            ),
            /*const SizedBox(
              height: 50.0,
            ),*/
            Visibility(
              visible: rPedidos,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  validator: (value){
                    if(value!.isEmpty) {
                      return "Pedido vacío";
                    }
                    return null;
                  },
                  controller: _tfPedidos,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: "PEDIDOS",
                      border: OutlineInputBorder(),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0)),
                ),
              ),
            ),
            /*const SizedBox(
              height: 10.0,
            ),*/
            Visibility(
              visible: rNIT,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  controller: _tfNIT,
                  validator: (value) {
                    if (value!.isEmpty) {
                      //setState((){ VerLista = true;});
                      return "Ingrese su NIT.";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: "NIT",
                      border: OutlineInputBorder(),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0)),
                ),
              ),
            ),
            Visibility(
              visible: rFechas1,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _tfFechas,
                  //keyboardType: TextInputType.,
                  validator: (value) {
                    if (value!.isEmpty) {
                      //setState((){ VerLista = true;});
                      return "Ingrese su DPI";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: "DPI",
                      border: OutlineInputBorder(),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0)),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const SizedBox(
              height: 10.0,
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              child: const Text('Buscar'),
              onPressed: () async {
                //await UserService.CalcularTF3(_tfPedidos.text);
                  setState(() {
                    _isSearching = true;
                  });

                   await service.BusquedaFolio(_tfPedidos.text, _tfNIT.text, _tfFechas.text).then((value) {
                    print(value);
                    print("identificador");
                    print(UserService.respuestaCode);
                    if(UserService.respuestaCode == 200){
                      List2.clear();
                      List2.addAll(value);
                    }else{
                      switch(UserService.respuestaCode){
                        case 400:
                          ErrorBusqueda();
                          break;
                        case 401:
                          _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                          break;
                        case 404:
                          ErrorBusqueda();
                          break;
                        case 500:
                          _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                          break;
                      }
                    }
                    //print(carlos[0].pedido.toString());
                  });

                  setState(() {
                    control = true;
                    _isSearching = false;
                  });
              },
            ),
            // Display the data loaded from sample.json
            Visibility(
              visible: _isSearching,
              child: CircularProgressIndicator(),
            ),
            Visibility(
                visible: control,
                child: List2.isNotEmpty
                    ? Expanded(
                  child: ListView.builder(
                    itemCount: List2.length,
                    itemBuilder: (_,int index) {
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Text(List2[index].idPedido.toString()),
                          title: Text(List2[index].nombre),
                          subtitle: Text(List2[index].nit),
                          trailing: const Icon(Icons.info_outline),
                          onTap: () async {
                            await service.DetalleBusquedaService(List2[index].folioEmplacado).then((value) {
                              print("aqui va el value");
                              print(value);
                              Lista3.clear();
                              Lista3.addAll(value);
                              DetalleBusqueda(context, Lista3, 0);
                              //print(carlos[0].pedido.toString());
                            });
                          },
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

  ValidarEstado(String Estado){
    if(Estado == "Nuevos")
    {
      return Colors.blue[900];
    }
    else if (Estado == "Documentos Aceptados")
    {
      return Colors.green;
    }
    else if (Estado == "Documentos Rechazados")
    {
      return Colors.red;
    }
    else if (Estado == "En Pagos")
    {
      return Colors.teal;
    }
    else if (Estado == "Enviado a SAT")
    {
      return Colors.blue;
    }
    else if (Estado == "En Italika")
    {
      return Colors.blue[900];
    }
    else if (Estado == "Placa en Sucursal")
    {
      return Colors.blue;
    }
    else if (Estado == "Placa Entregada a Cliente")
    {
      return Colors.green[800];
    }
    else if (Estado == "Pendiente de Revisar")
    {
      return Colors.yellow[900];
    }
  }
}