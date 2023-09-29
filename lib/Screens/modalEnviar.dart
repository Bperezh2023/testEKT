import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Services/userService.dart';
import '../model/ModelBusqueda.dart';
import '../model/modelRespBusqueda.dart';
import 'homepage.dart';

class modalEnviar extends StatefulWidget {
  final RespuestaBusqueda items;
  const modalEnviar(this.items, {Key? key}) : super(key: key);

  @override
  State<modalEnviar> createState() => _modalEnviarState();
}

class _modalEnviarState extends State<modalEnviar> {
  late BuildContext dialogContext; // global declaration
  List<RespuestaBusqueda> List1 = <RespuestaBusqueda>[];
  List<RespuestaBusquedaSimple> List2 = <RespuestaBusquedaSimple>[];
  late BuildContext dialogContext20; // global declaration
  late BuildContext dialogContext21; // global declaration
  late BuildContext dialogContext22; // global declaration
  late BuildContext dialogContext23; // global declaration
  late BuildContext dialogContext2; // global declaration
  late BuildContext dialogContext3; // global
  int RadioGroup2 = 1;
  final service = UserService();

  _showSuccesSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  ErrorBusqueda() {
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

  ErrorSubirArchivo() {
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

  _deleteFormDialog3() {
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

  _deleteFormDialog4() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          dialogContext22 = context;
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

  _deleteFormDialog2() {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Subír Documentos"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(children: [
          Text(
            ' Selecciona el método para \n           subir el archivo',
            style: TextStyle(
                fontSize: 25,
                color: Colors.blueGrey,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 80.0,
          ),
          Text(
            "¿Desea enviar su archivo a revisión?",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 60.0,
          ),
          Row(
            children: [
              const SizedBox(
                width: 75.0,
              ),
              Radio(
                  value: 1,
                  groupValue: RadioGroup2,
                  onChanged: (value) {
                    setState(() {
                      RadioGroup2 = 1;
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
                  value: 2,
                  groupValue: RadioGroup2,
                  onChanged: (value) {
                    setState(() {
                      RadioGroup2 = 2;
                    });
                  }),
              Text("NO"),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 46,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 40.0,
          ),
          Text(
            "   Si mandas tu archivo a revisión cambiará de \n    estado y la persona encargada podrá verlo \n                                 nuevamente.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          Visibility(
            visible: widget.items.idTipo == 0 ? true : false,
            child: Text(
              ' ERROR, ACTUALICE EL TIPO DE CLIENTE',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.red,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Visibility(
            visible: widget.items.idTipo == 2 ? true : false,
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                key: UniqueKey(),
                alignedDropdown: true,
                child: DropdownButtonFormField(
                  hint: Text('Selecciona tu tipo de envío'),
                  items: [
                    DropdownMenuItem(child: Text("Archivo Completo"), value: 1),
                    DropdownMenuItem(child: Text("DPI"), value: 2),
                    DropdownMenuItem(child: Text("Factura"), value: 3),
                    DropdownMenuItem(child: Text("RTU"), value: 4),
                    DropdownMenuItem(child: Text("Acta de Entrega"), value: 5),
                    DropdownMenuItem(
                        child: Text("Carta de Responsabilidad"), value: 6),
                    DropdownMenuItem(
                        child: Text("Nombramiento (Reg/Mer)"), value: 7)
                  ],
                  onChanged: (value2) {
                    //setState(() {
                    print("Tipo de Envío");
                    print(widget.items.idTipo);
                    widget.items.idTipo = value2 as int;
                    print(widget.items.idTipo);
                    if (widget.items.idTipo == 1) {
                      _deleteFormDialog3();
                      var result =
                          service.Subir_Info2(widget.items.folioEmplacado)
                              .then((response) {
                        print("respuesta 600");
                        print(response);
                        if (response == 200) {
                          print("acaba de entrar no.1");
                          var result2 =
                              service.Subir_InfoDB(widget.items.folioEmplacado)
                                  .then((response2) {
                            if (response2 == 201) {
                              print("acaba de entrar no.2");
                              _showSuccesSnackBar(
                                  "¡Archivo subido con éxito!.");
                            } else {
                              print("acaba de entrar no.3");
                              print(response2);
                              switch (response2) {
                                case 400:
                                  _showSuccesSnackBar(
                                      "Intentelo de nuevo, los datos son erroneos.");
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.");
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.");
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.");
                                  break;
                              }
                            }
                            if (RadioGroup2 == 1) {
                              var resultado = service.ActualizacionEntregas2(
                                  widget.items.folioEmplacado);
                            } else {}
                          });
                        } else {
                          switch (response) {
                            case 400:
                              _showSuccesSnackBar(
                                  "Intentelo de nuevo, los datos son erroneos.");
                              break;
                            case 401:
                              _showSuccesSnackBar(
                                  "No esta autorizado para ejecutar esta acción.");
                              break;
                            case 404:
                              _showSuccesSnackBar(
                                  "Usuario o contraseña incorrectos.");
                              break;
                            case 500:
                              _showSuccesSnackBar(
                                  "No se completo la petición intente mas tarde.");
                              break;
                            case 600:
                              _showSuccesSnackBar(
                                  "Intenta nuevamente, solo se admite las extensiones (.jpg, .png, .pdf y .jpeg)");
                              break;
                          }
                        }
                        Navigator.of(dialogContext).pop();
                      });
                    }
                    if (widget.items.idTipo == 2) {
                      _deleteFormDialog3();
                      var result =
                          service.Subir_Info2(widget.items.folioEmplacado)
                              .then((response) {
                        print("respuesta 600");
                        print(response);
                        if (response == 200) {
                          print("acaba de entrar no.1");
                          var result2 =
                              service.Subir_InfoDPI(widget.items.folioEmplacado)
                                  .then((response2) {
                            if (response2 == 201) {
                              print("acaba de entrar no.2");
                              _showSuccesSnackBar(
                                  "¡Archivo subido con éxito!.");
                              //_deleteFormDialog2();
                            } else {
                              print("acaba de entrar no.3");
                              print(response2);
                              switch (response2) {
                                case 400:
                                  _showSuccesSnackBar(
                                      "Intentelo de nuevo, los datos son erroneos.");
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.");
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.");
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.");
                                  break;
                              }
                            }
                            if (RadioGroup2 == 1) {
                              var resultado = service.ActualizacionEntregas2(
                                  widget.items.folioEmplacado);
                            } else {}
                          });
                        } else {
                          switch (response) {
                            case 400:
                              _showSuccesSnackBar(
                                  "Intentelo de nuevo, los datos son erroneos.");
                              break;
                            case 401:
                              _showSuccesSnackBar(
                                  "No esta autorizado para ejecutar esta acción.");
                              break;
                            case 404:
                              _showSuccesSnackBar(
                                  "Usuario o contraseña incorrectos.");
                              break;
                            case 500:
                              _showSuccesSnackBar(
                                  "No se completo la petición intente mas tarde.");
                              break;
                            case 600:
                              _showSuccesSnackBar(
                                  "Intenta nuevamente, solo se admite las extensiones (.jpg, .png, .pdf y .jpeg)");
                              break;
                          }
                        }
                        Navigator.of(dialogContext).pop();
                      });
                    } else if (widget.items.idTipo == 3) {
                      _deleteFormDialog3();
                      var result =
                          service.Subir_Info2(widget.items.folioEmplacado)
                              .then((response) {
                        print("respuesta 600");
                        print(response);
                        if (response == 200) {
                          print("acaba de entrar no.1");
                          var result2 = service.Subir_InfoFactura(
                                  widget.items.folioEmplacado)
                              .then((response2) {
                            if (response2 == 201) {
                              print("acaba de entrar no.2");
                              _showSuccesSnackBar(
                                  "¡Archivo subido con éxito!.");
                              //_deleteFormDialog2();
                            } else {
                              print("acaba de entrar no.3");
                              print(response2);
                              switch (response2) {
                                case 400:
                                  _showSuccesSnackBar(
                                      "Intentelo de nuevo, los datos son erroneos.");
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.");
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.");
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.");
                                  break;
                              }
                            }
                            if (RadioGroup2 == 1) {
                              var resultado = service.ActualizacionEntregas2(
                                  widget.items.folioEmplacado);
                            } else {}
                          });
                        } else {
                          switch (response) {
                            case 400:
                              _showSuccesSnackBar(
                                  "Intentelo de nuevo, los datos son erroneos.");
                              break;
                            case 401:
                              _showSuccesSnackBar(
                                  "No esta autorizado para ejecutar esta acción.");
                              break;
                            case 404:
                              _showSuccesSnackBar(
                                  "Usuario o contraseña incorrectos.");
                              break;
                            case 500:
                              _showSuccesSnackBar(
                                  "No se completo la petición intente mas tarde.");
                              break;
                            case 600:
                              _showSuccesSnackBar(
                                  "Intenta nuevamente, solo se admite las extensiones (.jpg, .png, .pdf y .jpeg)");
                              break;
                          }
                        }
                        Navigator.of(dialogContext).pop();
                      });
                    } else if (widget.items.idTipo == 4) {
                      _deleteFormDialog3();
                      var result =
                          service.Subir_Info2(widget.items.folioEmplacado)
                              .then((response) {
                        print("respuesta 600");
                        print(response);
                        if (response == 200) {
                          print("acaba de entrar no.1");
                          var result2 =
                              service.Subir_InfoRTU(widget.items.folioEmplacado)
                                  .then((response2) {
                            if (response2 == 201) {
                              print("acaba de entrar no.2");
                              _showSuccesSnackBar(
                                  "¡Archivo subido con éxito!.");
                              //_deleteFormDialog2();
                            } else {
                              print("acaba de entrar no.3");
                              print(response2);
                              switch (response2) {
                                case 400:
                                  _showSuccesSnackBar(
                                      "Intentelo de nuevo, los datos son erroneos.");
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.");
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.");
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.");
                                  break;
                              }
                            }
                            if (RadioGroup2 == 1) {
                              var resultado = service.ActualizacionEntregas2(
                                  widget.items.folioEmplacado);
                            } else {}
                          });
                        } else {
                          switch (response) {
                            case 400:
                              _showSuccesSnackBar(
                                  "Intentelo de nuevo, los datos son erroneos.");
                              break;
                            case 401:
                              _showSuccesSnackBar(
                                  "No esta autorizado para ejecutar esta acción.");
                              break;
                            case 404:
                              _showSuccesSnackBar(
                                  "Usuario o contraseña incorrectos.");
                              break;
                            case 500:
                              _showSuccesSnackBar(
                                  "No se completo la petición intente mas tarde.");
                              break;
                            case 600:
                              _showSuccesSnackBar(
                                  "Intenta nuevamente, solo se admite las extensiones (.jpg, .png, .pdf y .jpeg)");
                              break;
                          }
                        }
                        Navigator.of(dialogContext).pop();
                      });
                    } else if (widget.items.idTipo == 5) {
                      _deleteFormDialog3();
                      var result =
                          service.Subir_Info2(widget.items.folioEmplacado)
                              .then((response) {
                        print("respuesta 600");
                        print(response);
                        if (response == 200) {
                          print("acaba de entrar no.1");
                          var result2 = service.Subir_InfoActa(
                                  widget.items.folioEmplacado)
                              .then((response2) {
                            if (response2 == 201) {
                              print("acaba de entrar no.2");
                              _showSuccesSnackBar(
                                  "¡Archivo subido con éxito!.");
                              //_deleteFormDialog2();
                            } else {
                              print("acaba de entrar no.3");
                              print(response2);
                              switch (response2) {
                                case 400:
                                  _showSuccesSnackBar(
                                      "Intentelo de nuevo, los datos son erroneos.");
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.");
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.");
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.");
                                  break;
                              }
                            }
                            if (RadioGroup2 == 1) {
                              var resultado = service.ActualizacionEntregas2(
                                  widget.items.folioEmplacado);
                            } else {}
                          });
                        } else {
                          switch (response) {
                            case 400:
                              _showSuccesSnackBar(
                                  "Intentelo de nuevo, los datos son erroneos.");
                              break;
                            case 401:
                              _showSuccesSnackBar(
                                  "No esta autorizado para ejecutar esta acción.");
                              break;
                            case 404:
                              _showSuccesSnackBar(
                                  "Usuario o contraseña incorrectos.");
                              break;
                            case 500:
                              _showSuccesSnackBar(
                                  "No se completo la petición intente mas tarde.");
                              break;
                            case 600:
                              _showSuccesSnackBar(
                                  "Intenta nuevamente, solo se admite las extensiones (.jpg, .png, .pdf y .jpeg)");
                              break;
                          }
                        }
                        Navigator.of(dialogContext).pop();
                      });
                    } else if (widget.items.idTipo == 6) {
                      _deleteFormDialog3();
                      var result =
                          service.Subir_Info2(widget.items.folioEmplacado)
                              .then((response) {
                        print("respuesta 600");
                        print(response);
                        if (response == 200) {
                          print("acaba de entrar no.1");
                          var result2 = service.Subir_InfoResponsabilidad(
                                  widget.items.folioEmplacado)
                              .then((response2) {
                            if (response2 == 201) {
                              print("acaba de entrar no.2");
                              _showSuccesSnackBar(
                                  "¡Archivo subido con éxito!.");
                              //_deleteFormDialog2();
                            } else {
                              print("acaba de entrar no.3");
                              print(response2);
                              switch (response2) {
                                case 400:
                                  _showSuccesSnackBar(
                                      "Intentelo de nuevo, los datos son erroneos.");
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.");
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.");
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.");
                                  break;
                              }
                            }
                            if (RadioGroup2 == 1) {
                              var resultado = service.ActualizacionEntregas2(
                                  widget.items.folioEmplacado);
                            } else {}
                          });
                        } else {
                          switch (response) {
                            case 400:
                              _showSuccesSnackBar(
                                  "Intentelo de nuevo, los datos son erroneos.");
                              break;
                            case 401:
                              _showSuccesSnackBar(
                                  "No esta autorizado para ejecutar esta acción.");
                              break;
                            case 404:
                              _showSuccesSnackBar(
                                  "Usuario o contraseña incorrectos.");
                              break;
                            case 500:
                              _showSuccesSnackBar(
                                  "No se completo la petición intente mas tarde.");
                              break;
                            case 600:
                              _showSuccesSnackBar(
                                  "Intenta nuevamente, solo se admite las extensiones (.jpg, .png, .pdf y .jpeg)");
                              break;
                          }
                        }
                        Navigator.of(dialogContext).pop();
                      });
                    } else if (widget.items.idTipo == 7) {
                      _deleteFormDialog3();
                      var result =
                          service.Subir_Info2(widget.items.folioEmplacado)
                              .then((response) {
                        print("respuesta 600");
                        print(response);
                        if (response == 200) {
                          print("acaba de entrar no.1");
                          var result2 = service.Subir_InfoRegMer(
                                  widget.items.folioEmplacado)
                              .then((response2) {
                            if (response2 == 201) {
                              print("acaba de entrar no.2");
                              _showSuccesSnackBar(
                                  "¡Archivo subido con éxito!.");
                              //_deleteFormDialog2();
                            } else {
                              print("acaba de entrar no.3");
                              print(response2);
                              switch (response2) {
                                case 400:
                                  _showSuccesSnackBar(
                                      "Intentelo de nuevo, los datos son erroneos.");
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.");
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.");
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.");
                                  break;
                              }
                            }
                            if (RadioGroup2 == 1) {
                              var resultado = service.ActualizacionEntregas2(
                                  widget.items.folioEmplacado);
                            } else {}
                          });
                        } else {
                          switch (response) {
                            case 400:
                              _showSuccesSnackBar(
                                  "Intentelo de nuevo, los datos son erroneos.");
                              break;
                            case 401:
                              _showSuccesSnackBar(
                                  "No esta autorizado para ejecutar esta acción.");
                              break;
                            case 404:
                              _showSuccesSnackBar(
                                  "Usuario o contraseña incorrectos.");
                              break;
                            case 500:
                              _showSuccesSnackBar(
                                  "No se completo la petición intente mas tarde.");
                              break;
                            case 600:
                              _showSuccesSnackBar(
                                  "Intenta nuevamente, solo se admite las extensiones (.jpg, .png, .pdf y .jpeg)");
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
            visible: widget.items.idTipo == 1 ? true : false,
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                key: UniqueKey(),
                alignedDropdown: true,
                child: DropdownButtonFormField(
                  hint: Text('Selecciona tu tipo de envío'),
                  items: [
                    DropdownMenuItem(child: Text("Archivo Completo"), value: 1),
                    DropdownMenuItem(child: Text("DPI"), value: 2),
                    DropdownMenuItem(child: Text("Factura"), value: 3),
                    DropdownMenuItem(child: Text("RTU"), value: 4),
                    DropdownMenuItem(child: Text("Acta de Entrega"), value: 5),
                    DropdownMenuItem(
                        child: Text("Carta de Responsabilidad"), value: 6)
                  ],
                  onChanged: (value2) {
                    //setState(() {
                    print("Tipo de Envío");
                    print(widget.items.idTipo);
                    widget.items.idTipo = value2 as int;
                    print(widget.items.idTipo);
                    if (widget.items.idTipo == 1) {
                      _deleteFormDialog3();
                      var result =
                          service.Subir_Info2(widget.items.folioEmplacado)
                              .then((response) {
                        print("respuesta 600");
                        print(response);
                        if (response == 200) {
                          print("acaba de entrar no.1");
                          var result2 =
                              service.Subir_InfoDB(widget.items.folioEmplacado)
                                  .then((response2) {
                            if (response2 == 201) {
                              print("acaba de entrar no.2");
                              _showSuccesSnackBar(
                                  "¡Archivo subido con éxito!.");
                              //_deleteFormDialog2();
                            } else {
                              print("acaba de entrar no.3");
                              print(response2);
                              switch (response2) {
                                case 400:
                                  _showSuccesSnackBar(
                                      "Intentelo de nuevo, los datos son erroneos.");
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.");
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.");
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.");
                                  break;
                              }
                            }
                            if (RadioGroup2 == 1) {
                              var resultado = service.ActualizacionEntregas2(
                                  widget.items.folioEmplacado);
                            } else {}
                          });
                        } else {
                          switch (response) {
                            case 400:
                              _showSuccesSnackBar(
                                  "Intentelo de nuevo, los datos son erroneos.");
                              break;
                            case 401:
                              _showSuccesSnackBar(
                                  "No esta autorizado para ejecutar esta acción.");
                              break;
                            case 404:
                              _showSuccesSnackBar(
                                  "Usuario o contraseña incorrectos.");
                              break;
                            case 500:
                              _showSuccesSnackBar(
                                  "No se completo la petición intente mas tarde.");
                              break;
                            case 600:
                              _showSuccesSnackBar(
                                  "Intenta nuevamente, solo se admite las extensiones (.jpg, .png, .pdf y .jpeg)");
                              break;
                          }
                        }
                        Navigator.of(dialogContext).pop();
                      });
                    }
                    if (widget.items.idTipo == 2) {
                      _deleteFormDialog3();
                      var result =
                          service.Subir_Info2(widget.items.folioEmplacado)
                              .then((response) {
                        print("respuesta 600");
                        print(response);
                        if (response == 200) {
                          print("acaba de entrar no.1");
                          var result2 =
                              service.Subir_InfoDPI(widget.items.folioEmplacado)
                                  .then((response2) {
                            if (response2 == 201) {
                              print("acaba de entrar no.2");
                              _showSuccesSnackBar(
                                  "¡Archivo subido con éxito!.");
                              //_deleteFormDialog2();
                            } else {
                              print("acaba de entrar no.3");
                              print(response2);
                              switch (response2) {
                                case 400:
                                  _showSuccesSnackBar(
                                      "Intentelo de nuevo, los datos son erroneos.");
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.");
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.");
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.");
                                  break;
                              }
                            }
                            if (RadioGroup2 == 1) {
                              var resultado = service.ActualizacionEntregas2(
                                  widget.items.folioEmplacado);
                            } else {}
                          });
                        } else {
                          switch (response) {
                            case 400:
                              _showSuccesSnackBar(
                                  "Intentelo de nuevo, los datos son erroneos.");
                              break;
                            case 401:
                              _showSuccesSnackBar(
                                  "No esta autorizado para ejecutar esta acción.");
                              break;
                            case 404:
                              _showSuccesSnackBar(
                                  "Usuario o contraseña incorrectos.");
                              break;
                            case 500:
                              _showSuccesSnackBar(
                                  "No se completo la petición intente mas tarde.");
                              break;
                            case 600:
                              _showSuccesSnackBar(
                                  "Intenta nuevamente, solo se admite las extensiones (.jpg, .png, .pdf y .jpeg)");
                              break;
                          }
                        }
                        Navigator.of(dialogContext).pop();
                      });
                    } else if (widget.items.idTipo == 3) {
                      _deleteFormDialog3();
                      var result =
                          service.Subir_Info2(widget.items.folioEmplacado)
                              .then((response) {
                        print("respuesta 600");
                        print(response);
                        if (response == 200) {
                          print("acaba de entrar no.1");
                          var result2 = service.Subir_InfoFactura(
                                  widget.items.folioEmplacado)
                              .then((response2) {
                            if (response2 == 201) {
                              print("acaba de entrar no.2");
                              _showSuccesSnackBar(
                                  "¡Archivo subido con éxito!.");
                              //_deleteFormDialog2();
                            } else {
                              print("acaba de entrar no.3");
                              print(response2);
                              switch (response2) {
                                case 400:
                                  _showSuccesSnackBar(
                                      "Intentelo de nuevo, los datos son erroneos.");
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.");
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.");
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.");
                                  break;
                              }
                            }
                            if (RadioGroup2 == 1) {
                              var resultado = service.ActualizacionEntregas2(
                                  widget.items.folioEmplacado);
                            } else {}
                          });
                        } else {
                          switch (response) {
                            case 400:
                              _showSuccesSnackBar(
                                  "Intentelo de nuevo, los datos son erroneos.");
                              break;
                            case 401:
                              _showSuccesSnackBar(
                                  "No esta autorizado para ejecutar esta acción.");
                              break;
                            case 404:
                              _showSuccesSnackBar(
                                  "Usuario o contraseña incorrectos.");
                              break;
                            case 500:
                              _showSuccesSnackBar(
                                  "No se completo la petición intente mas tarde.");
                              break;
                            case 600:
                              _showSuccesSnackBar(
                                  "Intenta nuevamente, solo se admite las extensiones (.jpg, .png, .pdf y .jpeg)");
                              break;
                          }
                        }
                        Navigator.of(dialogContext).pop();
                      });
                    } else if (widget.items.idTipo == 4) {
                      _deleteFormDialog3();
                      var result =
                          service.Subir_Info2(widget.items.folioEmplacado)
                              .then((response) {
                        print("respuesta 600");
                        print(response);
                        if (response == 200) {
                          print("acaba de entrar no.1");
                          var result2 =
                              service.Subir_InfoRTU(widget.items.folioEmplacado)
                                  .then((response2) {
                            if (response2 == 201) {
                              print("acaba de entrar no.2");
                              _showSuccesSnackBar(
                                  "¡Archivo subido con éxito!.");
                              //_deleteFormDialog2();
                            } else {
                              print("acaba de entrar no.3");
                              print(response2);
                              switch (response2) {
                                case 400:
                                  _showSuccesSnackBar(
                                      "Intentelo de nuevo, los datos son erroneos.");
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.");
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.");
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.");
                                  break;
                              }
                            }
                            if (RadioGroup2 == 1) {
                              var resultado = service.ActualizacionEntregas2(
                                  widget.items.folioEmplacado);
                            } else {}
                          });
                        } else {
                          switch (response) {
                            case 400:
                              _showSuccesSnackBar(
                                  "Intentelo de nuevo, los datos son erroneos.");
                              break;
                            case 401:
                              _showSuccesSnackBar(
                                  "No esta autorizado para ejecutar esta acción.");
                              break;
                            case 404:
                              _showSuccesSnackBar(
                                  "Usuario o contraseña incorrectos.");
                              break;
                            case 500:
                              _showSuccesSnackBar(
                                  "No se completo la petición intente mas tarde.");
                              break;
                            case 600:
                              _showSuccesSnackBar(
                                  "Intenta nuevamente, solo se admite las extensiones (.jpg, .png, .pdf y .jpeg)");
                              break;
                          }
                        }
                        Navigator.of(dialogContext).pop();
                      });
                    } else if (widget.items.idTipo == 5) {
                      _deleteFormDialog3();
                      var result =
                          service.Subir_Info2(widget.items.folioEmplacado)
                              .then((response) {
                        print("respuesta 600");
                        print(response);
                        if (response == 200) {
                          print("acaba de entrar no.1");
                          var result2 = service.Subir_InfoActa(
                                  widget.items.folioEmplacado)
                              .then((response2) {
                            if (response2 == 201) {
                              print("acaba de entrar no.2");
                              _showSuccesSnackBar(
                                  "¡Archivo subido con éxito!.");
                              //_deleteFormDialog2();
                            } else {
                              print("acaba de entrar no.3");
                              print(response2);
                              switch (response2) {
                                case 400:
                                  _showSuccesSnackBar(
                                      "Intentelo de nuevo, los datos son erroneos.");
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.");
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.");
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.");
                                  break;
                              }
                            }
                            if (RadioGroup2 == 1) {
                              var resultado = service.ActualizacionEntregas2(
                                  widget.items.folioEmplacado);
                            } else {}
                          });
                        } else {
                          switch (response) {
                            case 400:
                              _showSuccesSnackBar(
                                  "Intentelo de nuevo, los datos son erroneos.");
                              break;
                            case 401:
                              _showSuccesSnackBar(
                                  "No esta autorizado para ejecutar esta acción.");
                              break;
                            case 404:
                              _showSuccesSnackBar(
                                  "Usuario o contraseña incorrectos.");
                              break;
                            case 500:
                              _showSuccesSnackBar(
                                  "No se completo la petición intente mas tarde.");
                              break;
                            case 600:
                              _showSuccesSnackBar(
                                  "Intenta nuevamente, solo se admite las extensiones (.jpg, .png, .pdf y .jpeg)");
                              break;
                          }
                        }
                        Navigator.of(dialogContext).pop();
                      });
                    } else if (widget.items.idTipo == 6) {
                      _deleteFormDialog3();
                      var result =
                          service.Subir_Info2(widget.items.folioEmplacado)
                              .then((response) {
                        print("respuesta 600");
                        print(response);
                        if (response == 200) {
                          print("acaba de entrar no.1");
                          var result2 = service.Subir_InfoResponsabilidad(
                                  widget.items.folioEmplacado)
                              .then((response2) {
                            if (response2 == 201) {
                              print("acaba de entrar no.2");
                              _showSuccesSnackBar(
                                  "¡Archivo subido con éxito!.");
                              //_deleteFormDialog2();
                            } else {
                              print("acaba de entrar no.3");
                              print(response2);
                              switch (response2) {
                                case 400:
                                  _showSuccesSnackBar(
                                      "Intentelo de nuevo, los datos son erroneos.");
                                  break;
                                case 401:
                                  _showSuccesSnackBar(
                                      "No esta autorizado para ejecutar esta acción.");
                                  break;
                                case 404:
                                  _showSuccesSnackBar(
                                      "Usuario o contraseña incorrectos.");
                                  break;
                                case 500:
                                  _showSuccesSnackBar(
                                      "No se completo la petición intente mas tarde.");
                                  break;
                              }
                            }
                            if (RadioGroup2 == 1) {
                              var resultado = service.ActualizacionEntregas2(
                                  widget.items.folioEmplacado);
                            } else {}
                          });
                        } else {
                          switch (response) {
                            case 400:
                              _showSuccesSnackBar(
                                  "Intentelo de nuevo, los datos son erroneos.");
                              break;
                            case 401:
                              _showSuccesSnackBar(
                                  "No esta autorizado para ejecutar esta acción.");
                              break;
                            case 404:
                              _showSuccesSnackBar(
                                  "Usuario o contraseña incorrectos.");
                              break;
                            case 500:
                              _showSuccesSnackBar(
                                  "No se completo la petición intente mas tarde.");
                              break;
                            case 600:
                              _showSuccesSnackBar(
                                  "Intenta nuevamente, solo se admite las extensiones (.jpg, .png, .pdf y .jpeg)");
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
        ]),
      ),
    );
  }
}
