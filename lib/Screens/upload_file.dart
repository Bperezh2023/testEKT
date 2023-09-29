import 'dart:convert';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../Services/userService.dart';
import '../model/ModelBusqueda.dart';
import '../model/User.dart';
import '../model/modelApi.dart';
import '../model/modelDepartamento.dart';
import '../model/modelMuni.dart';
import 'package:http/http.dart' as http;

class update_info extends StatefulWidget {
  final RespuestaBusqueda items;
  update_info( this.items, {Key? key}) : super(key: key);

  static var Categoria = "";
  @override
  State<update_info> createState() => _update_infoState();
}

class _update_infoState extends State<update_info> {

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
  static int Categoria2 = 0;
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

  int _selectedValue =0;
  int tipodeVenta = 0;
  int tipodeVenta2 = 0;
  int tipoCliente = 0;
  int tipoCliente2 = 0;
  int Departamento =0;
  int Municipio = 0;
  int idGenero = 0;
  int idGenero2 = 0;
  int valorRetornado = 0;

  String? dropdownvalue;

  List? statesList;
  String? _myState;
  String? _myState2;
  List? citiesList;
  String? _myCity;
  String? _myCity2;

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

  void initState(){
    _getStateList();
    setState(() {
      _tfidSucursal.text = widget.items.idSucursal.toString();
      _tfPedido.text = widget.items.idPedido.toString();
      _tfChasis.text = widget.items.numeroSerie.toString();
      _tfNombres.text = widget.items.nombre.toString();
      _tfDPI.text = widget.items.dpi.toString();
      _tfNIT.text = widget.items.nit.toString();
      _tfDireccion.text = widget.items.direccion.toString();
      _tfTelefono.text = widget.items.telefono.toString();
      _tfCorreo.text = widget.items.correo.toString();
      valorRetornado = widget.items.idTipoVenta;
      idGenero2 = widget.items.idGenero;
      print("idGenero");
      print(idGenero);
      tipodeVenta2 = widget.items.idTipoVenta;
      tipoCliente2 = widget.items.idTipo;
      print("tipocliente2");
      print(tipoCliente2);
      //_getCitiesList();
      _myState = widget.items.idDepartamento.toString();
      if(_myState != "0")
      {
        _getCitiesList();
      }
      _myCity = widget.items.idMunicipio.toString();
      widget.items.folioEmplacado.toString();
      print(widget.items.folioEmplacado.toString());
      widget.items.idUsuarioModifico.toString();
      widget.items.idEstado.toString();
      widget.items.idTipo.toString();
    });
  }

  @override



  @override
  Widget build(BuildContext context) {
    _showSuccesSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Actualización de Emplacados"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _keyForm,
            child: Column(
              children: [
                const Text(
                  "Datos para Actualizar Emplacado:",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500),
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
                    child: DropdownButtonFormField(
                      hint: Text('Selecciona el Tipo de Venta'),
                      value: tipodeVenta2 == 0 ? null : tipodeVenta2,
                      items:[
                        DropdownMenuItem(child: Text("Crédito") , value: 1),
                        DropdownMenuItem(child: Text("Contado") , value: 2),
                      ], onChanged: (value) {
                      setState(() {
                        tipodeVenta2 = value as int;
                        print(tipodeVenta2);
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
                  height: 35.0,
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
                    key: UniqueKey(),
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      hint: Text('Selecciona el Tipo de Cliente'),
                      value: tipoCliente2 == 0 ? null : tipoCliente2,
                      items: [
                        DropdownMenuItem(child: Text("Individual") , value: 1),
                        DropdownMenuItem(child: Text("Empresa") , value: 2)
                      ], onChanged: (value2) {
                      setState(() {
                        print("Tipo Cliente Nuevo");
                        print(tipoCliente2);
                        tipoCliente2 = value2 as int;
                        print(tipoCliente);
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
                TextFormField(
                  validator: (value){
                    if(value!.trim().isEmpty) {
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
                    if(value!.trim().isEmpty) {
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
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    key: UniqueKey(),
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      hint: Text('Selecciona tu Tipo de Género'),
                      value: idGenero2 == 0 ? null : idGenero2,
                      items: [
                        DropdownMenuItem(child: Text("Masculino") , value: 1),
                        DropdownMenuItem(child: Text("Femenino") , value: 2),
                        DropdownMenuItem(child: Text("Empresa") , value: 3),
                      ], onChanged: (value) {
                      setState(() {
                        idGenero2 = value as int;
                        print(idGenero2);
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
                const SizedBox(
                  height: 20.0,
                ),
                const SizedBox(
                  width: 20.0,
                ),
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField<String>(
                      value: _myState == "0" ? null : _myState,
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
                          _myCity = null;
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
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField<String>(
                      value: _myCity == "0" ? null : _myCity,
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
                TextFormField(
                  validator: (value){
                    if(value!.trim().isEmpty) {
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
                      print("exp");
                      print(RegExp(r"^([a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+=?^_`{|}~]+)(@[a-zA-Z0-9]+)(\.[a-zA-Z]{2,3})(|\.[a-zA-Z]{2,3})").hasMatch(value));
                      if(!RegExp(r"^([a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+=?^_`{|}~]+)(@[a-zA-Z0-9]+)(\.[a-zA-Z]{2,3})(|\.[a-zA-Z]{2,3})$").hasMatch(value)){
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
                          //_CalcularPromedio();
                          if(_keyForm.currentState!.validate()){
                            print("tipo de Genero");
                            print(idGenero2);
                            print("folio");
                            print(widget.items.folioEmplacado);
                            var result = await UserService.ActualizarInfo(_tfidSucursal.text, _tfPedido.text, _tfChasis.text, _tfDPI.text.trim(), _tfNIT.text.trim(), _tfDireccion.text.trim(), _tfTelefono.text.trim(), _tfNombres.text.trim(), _tfCorreo.text.trim(), _tfComentario.text, tipodeVenta2, tipoCliente2, _myCity.toString(), _myState.toString(), widget.items.folioEmplacado.toString(),  widget.items.idUsuarioModifico.toString(), widget.items.idEstado.toString(), idGenero2).then((response){
                              if(response == 200){
                                _showSuccesSnackBar("Emplacado Actualizado con éxito");
                              }else{
                                switch(response){
                                  case 400:
                                    _showSuccesSnackBar("Error, validar los campos de información");
                                    break;
                                  case 401:
                                    _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.");
                                    break;
                                  case 404:
                                    _showSuccesSnackBar("No fue encontrado el cambio.");
                                    break;
                                  case 500:
                                    _showSuccesSnackBar("No se completo la petición intente mas tarde.");
                                    break;
                                }
                              }
                            });

                            //var resulta = await _userService.
                          }else{
                            _showSuccesSnackBar("Error, validar la inforamción de los campos");
                          }
                        }, child: const Text('Actualizar Datos')),
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
                const SizedBox(
                  height: 40.0,
                ),
                Text(
                  textAlign: TextAlign.left,
                  "-Digitalización-",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.blueGrey,
                      //Color.fromARGB(255, 16, 28, 156),
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null) {
                      return 'Comentario Vacío';
                    }
                    return null;
                  },
                  controller: _tfComentario,
                  decoration:  InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Ingrese su Comentario',
                    labelText: 'Comentario',
                    errorText: _validatecomentario ? "Ingrese su Nombre Completo para seguir con el registro" : null,
                  ),
                ),

                const SizedBox(
                  height: 40.0,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 35.0,
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.blue[900],
                            textStyle: const TextStyle(fontSize: 15)
                        ),
                        onPressed: () async {
                          //_CalcularPromedio();
                          if(_keyForm.currentState!.validate()) {
                            print("este es el folio");
                            print(widget.items.folioEmplacado.toString());
                            var result = await _userService.GuardarComentario(
                                _tfComentario.text,
                                widget.items.folioEmplacado.toString());
                            _showSuccesSnackBar(
                                "Comentario guardado con éxito");
                          }
                        }, child: const Text('Guardar Comentario')),
                    const SizedBox(
                      width: 20.0,
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.blueGrey,
                            textStyle: const TextStyle(fontSize: 15)
                        ),
                        onPressed: (){

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
}
