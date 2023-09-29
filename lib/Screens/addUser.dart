import 'dart:convert';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timeline/defaults.dart';
import 'package:flutter_timeline/event_item.dart';
import 'package:flutter_timeline/indicator_position.dart';
import 'package:flutter_timeline/timeline.dart';
import 'package:flutter_timeline/timeline_theme.dart';
import 'package:flutter_timeline/timeline_theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_timeline/timeline_theme.dart';
import 'package:flutter_timeline/timeline_theme_data.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../Services/userService.dart';
import '../model/User.dart';
import '../model/modelDepartamento.dart';
import '../model/modelMuni.dart';
import 'package:http/http.dart' as http;

class AddUser extends StatefulWidget {
  AddUser({Key? key}) : super(key: key);
  double sucursal = 0;
  double telefono = 0;
  double pedido = 0;
  double dpi = 0;

  @override
  State<AddUser> createState() => _AddUserState();
}


class _AddUserState extends State<AddUser> {
  var _lista = ['Empresa','Particular'];
  String _vista = 'Seleccione una opcion';
  var _userNameController=TextEditingController();
  var _userContractController=TextEditingController();
  var _userDescriptionController=TextEditingController();
  bool _validateName = false;
  bool _validateContact = false;
  bool _validateDescription = false;
  final _userService = UserService();
  static String miValor="";
  List<String> listaDeOpciones = <String>["A","B","C","D","E","F","G"];
  String ? selectedItems = 'Prueba1';
  String dropdowncurrentvalue = "Opcion1";
  RespuestaDepto? selectedUser;
  List<RespuestaDepto> igualar = <RespuestaDepto>[RespuestaDepto(1, 'Guatemala'), RespuestaDepto(2, 'El Progreso')];
  final _keyForm = GlobalKey<FormState>();
  //SUCURSAL
  final _tfidSucursal = TextEditingController();
  bool _validateidSucursal = false;
  final _tfSucursal = TextEditingController();
  bool _validateSucursal = false;
  final _tfTipoSucursal = TextEditingController();
  bool _validateTipoSucursal = false;
  final _tfPedido = TextEditingController();
  bool _validatePedido = false;
  final _tfTipoVenta = TextEditingController();
  bool _validateTipoVenta = false;
  final _tfChasis = TextEditingController();
  bool _validateChasis = false;
  bool control = false;

  //Datos del Cliente
  final _tfTipoCliente = TextEditingController();
  bool _validateTipoCliente = false;
  final _tfNombres = TextEditingController();
  bool _validateNombres = false;
  final _tfNIT = TextEditingController();
  bool _validateNIT = false;
  final _tfDPI = TextEditingController();
  bool _validateDPI = false;
  final _tfDepartamento = TextEditingController();
  bool _validateDepartamento = false;
  final _tfMunicipio = TextEditingController();
  bool _validateMunicipio = false;
  final _tfDireccion = TextEditingController();
  bool _validateDire = false;
  final _tfTelefono = TextEditingController();
  bool _validateTel = false;
  final _tfCorreo = TextEditingController();
  bool _validatecorreo = false;
  final _tfComentario = TextEditingController();
  bool _validatecomentario = false;
  static var Categoria = "";
  int _selectedValue =0;
  int _tipodeVenta = 0;
  int _tipoCliente = 0;
  bool vista = false;
  bool vista2 = false;
  bool vista3 = false;
  bool vista4 = false;
  int idGenero = 0;
  int Departamento =0;
  int Municipio = 0;
  bool validacion = false;

  List? statesList;
  String? _myState;
  List? citiesList;
  String? _myCity;
  String TipoVenta = "";
  String TipoCliente = "";
  List? Depto;
  List? Muni;

  /*Future<String> _getStateList() async {

    var registros = <RespuestaDepto>[];

    final jobsListAPIUrl = 'https://webapi.elektraguate.com/api/municipios/departamentos/';
    final response = await http.get(Uri.parse(jobsListAPIUrl));

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      var datos = json.decode(response.body);

      setState(() {
        statesList = datos;
      });
      return jobsListAPIUrl;
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<String> _getStateList() async {
    final String response = await rootBundle.loadString('assets/Depto.json');
    final data = await json.decode(response);
    setState(() {
      statesList = data['items'];
    });
    return response;
  }

  Future<String> _getCitiesList() async {
    final String response = await rootBundle.loadString('assets/municipio.json');
    final data = await json.decode(response);
    setState(() {
      citiesList = data['municipio'];
    });
    return response;
  }*/

  Future<String> _getStateList() async {

    var registros = <RespuestaDepto>[];

    final jobsListAPIUrl = 'https://webapi.elektraguate.com/api/municipios/departamentos/';
    final response = await http.get(Uri.parse(jobsListAPIUrl));

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      var datos = json.decode(response.body);

      setState(() {
        statesList = datos;
      });
      return jobsListAPIUrl;
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  var baseUrl = "https://webapi.elektraguate.com/api/municipios/";
  String cityInfoUrl =
      'http://cleanions.bestweb.my/api/location/get_city_by_state_id';
  Future<String> _getCitiesList() async {
    final jobsListAPIUrl = 'https://webapi.elektraguate.com/api/municipios/' + _myState.toString();
    final response = await http.get(Uri.parse(jobsListAPIUrl));

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      var datos = json.decode(response.body);

      setState(() {
        citiesList = datos;
      });
      return jobsListAPIUrl;
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  // Get State information by API


  Future<String> _getCitiesList2() async {
    final jobsListAPIUrl = 'https://webapi.elektraguate.com/api/municipios/' + _myState.toString();
    final response = await http.get(Uri.parse(jobsListAPIUrl));

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      var datos = json.decode(response.body);

      setState(() {
        citiesList = datos;
      });
      return jobsListAPIUrl;
    } else {
      throw Exception('Failed to load jobs from API');
    }
    return jobsListAPIUrl;
  }

  /*Future<String> _getCitiesList() async {

    final String respuesta = await rootBundle.loadString('assets/municipio.json');
    final data = await json.decode(respuesta);
    setState(() {
      citiesList = data['municipio'];
    });
    print(123);
    print(citiesList);
    final jobsListAPIUrl = citiesList.where((element) => element.departamentoId ==  _myState.toString());
    //final response = await http.get(Uri.parse(jobsListAPIUrl));
    print(jobsListAPIUrl);
    return respuesta;
  }*/

  @override

  void initState(){
    _getStateList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Cuerpo(),
      ],
    );
  }

  Widget Cuerpo(){
    _showSuccesSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Nuevo Emplacado"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _keyForm,
            child: Column(
              children: [
                const Text(
                  "Datos para Emplacado:",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.blueGrey,
                      //Color.fromARGB(255, 16, 28, 156),
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 20.0,
                ),

                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty) {
                      return "Pedido está vacío";
                    }
                    return null;
                  },
                  controller: _tfPedido,
                  keyboardType: TextInputType.number,
                  decoration:  InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Ejemplo: 1540',
                    labelText: 'Pedido',
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      hint: Text('Selecciona el Tipo de Venta'),
                      items: [
                        DropdownMenuItem(child: Text("Crédito") , value: 1),
                        DropdownMenuItem(child: Text("Contado") , value: 2)
                      ], onChanged: (value) {
                      setState(() {
                        _tipodeVenta = value as int;
                        print(_tipodeVenta);
                      });
                    },
                      validator: (value) {
                        if (value == null) {
                          return 'Tipo de Venta Vacío';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isNotEmpty){
                      print(RegExp(r'^[A-Z]+$').hasMatch(value));
                      if(!RegExp(r'^[A-Z0-9]+$').hasMatch(value)){
                        //_tfNIT.clear();
                        return "Error, Chasis inválido";
                      }
                    }
                    return null;
                  },
                  controller: _tfChasis,
                  decoration:  InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Ejemplo: LJDSFJA154063',
                    labelText: 'Chasis',
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  textAlign: TextAlign.left,
                  "-Datos del Cliente-",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.blueGrey,
                      //Color.fromARGB(255, 16, 28, 156),
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 35.0,
                ),
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      hint: Text('Selecciona el Tipo de Cliente'),
                      items: [
                        DropdownMenuItem(child: Text("Empresa") , value: 2),
                        DropdownMenuItem(child: Text("Individual") , value: 1)
                      ], onChanged: (value) {
                      setState(() {
                        _tipoCliente = value as int;
                        if(_tipoCliente == 2){
                            vista = true;
                            vista2 = false;
                            vista3 = true;
                            vista4 = false;
                        }else if(_tipoCliente == 1){
                          vista = false;
                          vista2 = true;
                          vista3 = false;
                          vista4 = true;
                        }
                        print(_tipoCliente);
                      });
                    },
                      validator: (value) {
                        if (value == null) {
                          return 'Tipo de Cliente Vacío';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Visibility(
                  visible: vista,
                  child: TextFormField(
                  validator: (value){
                    if(value!.isEmpty) {
                      return "Razón Social Vacía";
                    }
                    return null;
                  },
                  controller: _tfNombres,
                  decoration:  InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Ingrese el Nombre de la Empresa',
                    labelText: 'Razón Social',
                    ),
                  ),
                ),

                Visibility(
                  visible: vista2,
                  child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty) {
                        return "Nombre Completo Vacío";
                      }
                      return null;
                    },
                    controller: _tfNombres,
                    decoration:  InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Ingrese su Nombre Completo',
                      labelText: 'Nombre Completo',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty) {
                      return "DPI Vacío";
                    }
                    if(value.length != 13){
                      return "DPI Incorrecto";
                    }
                    return null;
                  },
                  controller: _tfDPI,
                  keyboardType: TextInputType.number,
                  decoration:  InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Ingrese su DPI',
                    labelText: 'DPI',
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty) {
                      return "Nit Vacío";
                    }
                    if(RegExp(r'[-,_]').hasMatch(value)){
                      //_tfNIT.clear();
                      return "Error, NIT inválido";
                    }
                    return null;
                  },
                  controller: _tfNIT,
                  decoration:  InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Ingrese su NIT',
                    labelText: 'NIT',
                    errorText: _validateNIT ? "Ingrese su NIT para seguir con el registro" : null,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Visibility(
                  visible: vista3,
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField(
                        hint: Text('Selecciona el Género'),
                        items: [
                          DropdownMenuItem(child: Text("Empresa") , value: 3),
                        ], onChanged: (value) {
                        setState(() {
                          idGenero = value as int;
                          print(idGenero);
                        });
                      },
                        validator: (value) {
                          if (value == null) {
                            return 'Genero Vacío';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: vista4,
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField(
                          hint: Text('Selecciona el Género'),
                          items: [
                            DropdownMenuItem(child: Text("Masculino") , value: 1),
                            DropdownMenuItem(child: Text("Femenino") , value: 2),
                          ], onChanged: (value) {
                          setState(() {
                            idGenero = value as int;
                            print(idGenero);
                          });
                        },
                          validator: (value) {
                            if (value == null) {
                              return 'Genero Vacío';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField<String>(
                      value: _myState,
                      iconSize: 30,
                      icon: (null),
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                      hint: Text('Seleccione Departamento'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _myState = newValue!;
                          _getCitiesList();
                          print(_myState);
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Departamento Vacío';
                        }
                        return null;
                      },
                      items: statesList?.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item['departamento']),
                          value: item['id'].toString(),
                        );
                      }).toList() ??
                          [],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField<String>(
                      value: _myCity,
                      iconSize: 30,
                      icon: (null),
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                      hint: Text('Seleccione Municipio'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _myCity = newValue!;
                          print(_myCity);
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Municipio Vacío';
                        }
                        return null;
                      },
                      items: citiesList?.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item['municipio']),
                          value: item['id'].toString(),
                        );
                      }).toList() ??
                          [],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty) {
                      return "Dirección Vacía";
                    }
                    return null;
                  },
                  controller: _tfDireccion,
                  decoration:  InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Ingrese su dirección exacta',
                    labelText: 'Dirección',
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty) {
                      return "Teléfono vacío";
                    }
                    if(value.length != 8){
                      return "Teléfono Incorrecto";
                    }
                    return null;
                  },
                  controller: _tfTelefono,
                  keyboardType: TextInputType.number,
                  decoration:  InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Ingrese su teléfono',
                    labelText: 'Teléfono',
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isNotEmpty){
                      print(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value));
                      if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                        //_tfNIT.clear();
                        return "Error, Correo inválido";
                      }
                    }
                    return null;
                  },
                  controller: _tfCorreo,
                  decoration:  InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Ingrese su correo electrónico',
                    labelText: 'Correo',
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),

                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 60.0,
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.blue[900],
                            textStyle: const TextStyle(fontSize: 15)
                        ),
                        onPressed: () async {
                          if(_keyForm.currentState!.validate()){


                            bool r =  await ValidarChasisPedido(_tfChasis.text, _tfPedido.text);
                            print("r");
                            print(r);
                            if(r == true)
                              {
                                //_showSuccesSnackBar("Guardado");
                                var resultado =  UserService.CargaApiUser(_tfidSucursal.text, _tfPedido.text, _tfChasis.text, _tfDPI.text, _tfNIT.text, _tfDireccion.text, _tfTelefono.text, _tfNombres.text, _tfCorreo.text, _tfComentario.text, _tipodeVenta, _tipoCliente,_myCity.toString(), _myState.toString(), idGenero).then((response2){
                                  if(response2 == 201){
                                    _showSuccesSnackBar("Emplacado creado con éxito");
                                    _tfSucursal.clear();
                                    _tfTipoSucursal.clear();
                                    _tfPedido.clear();
                                    _tfChasis.clear();
                                    _tfNombres.clear();
                                    _tfDPI.clear();
                                    _tfNIT.clear();
                                    _tfDireccion.clear();
                                    _tfTelefono.clear();
                                    _tfCorreo.clear();
                                  }else{
                                    switch(response2){
                                      case 400:
                                        _showSuccesSnackBar("Datos incorrectos, validar la información en los campos.");
                                        break;
                                      case 401:
                                        _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                        break;
                                      case 404:
                                        _showSuccesSnackBar("Datos incorrectos.");
                                        break;
                                      case 500:
                                        _showSuccesSnackBar("No se completo la petición, intente mas tarde.");
                                        break;
                                    }
                                  }
                                });
                              }
                          }else{
                            _showSuccesSnackBar("Error, validar la inforamción de los campos");
                          }
                        }, child: const Text('Guardar Datos')),
                    const SizedBox(
                      width: 10.0,
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.blueGrey,
                            textStyle: const TextStyle(fontSize: 15)
                        ),
                        onPressed: (){
                          _tfSucursal.clear();
                          _tfTipoSucursal.clear();
                          _tfPedido.clear();
                          _tfChasis.clear();
                          _tfNombres.clear();
                          _tfDPI.clear();
                          _tfNIT.clear();
                          _tfDireccion.clear();
                          _tfTelefono.clear();
                          _tfCorreo.clear();
                        }, child: const Text('Descartar Datos')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ValidarEstado2(int Estado){
    if(Estado == 0)
    {
      return "ND";
    }
    else if (Estado == 1)
    {
      return "Documentos Aceptados";
    }
    else if (Estado == 2)
    {
      return "Documentos Rechazados";
    }
    else if (Estado == 3)
    {
      return "En Pagos";
    }
    else if (Estado == 4)
    {
      return "Enviado a SAT";
    }
    else if (Estado == 5)
    {
      return "En Italika";
    }
    else if (Estado == 6)
    {
      return "Enviado a Sucursal";
    }
    else if (Estado == 7)
    {
      return "Entregado al Cliente";
    }
  }

 Future<bool>  ValidarChasisPedido(String _tfChasis, String _tfPedido) async {
    _showSuccesSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    bool validarChasis = false;
    bool validarPedido = false;
    bool validaExisChasis = false;

     await _userService.ValidacionChasis(_tfChasis, "").then((response){
      if(response == 200){
        validarChasis = false;
        _showSuccesSnackBar("Error, este Chasis ya se encuentra generado en otro emplacado");
      }else{
        validarChasis = true;
      }
    });

    await _userService.ValidacionChasis("", _tfPedido).then((response2){
      if(response2 == 200){
        validarPedido = false;
        _showSuccesSnackBar("Error, este Pedido ya se encuentra generado en otro emplacado");
      }else{
        validarPedido = true;
      }
    });

    await _userService.ValidacionChasis2(_tfChasis).then((response3){
      if(response3 == 200){
        validaExisChasis = true;
      }else{
        validaExisChasis = false;
        _showSuccesSnackBar("Error, el Chasis no existe");
      }
    });

    print("val");
    print(validarChasis);
    print(validarPedido);
    print(validaExisChasis);

    if(validarChasis == true && validarPedido == true && validaExisChasis == true){
      print("t");
      return true;
    }else{
      print("f");
      return false;
    }
  }
}
