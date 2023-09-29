import 'dart:convert';

import 'package:app_itk4/model/ModelBusqueda.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../Screens/Comments.dart';
import '../Screens/Imageness.dart';
import '../Screens/busqueda2.dart';
import '../Screens/revision.dart';
import '../Screens/upload_file.dart';
import '../model/EntregaPlacaModel.dart';
import '../model/ModeloService.dart';
import '../model/User.dart';
import '../model/modelRespBusqueda.dart';
import '../services/userService.dart';

class BusquedaPlaca extends StatefulWidget {
  const BusquedaPlaca({Key? key}) : super(key: key);

  @override
  State<BusquedaPlaca> createState() => _BusquedaPlacaState();
}

class _BusquedaPlacaState extends State<BusquedaPlaca> {
  List<RespuestaBusqueda> Lista3 = <RespuestaBusqueda>[];
  String resulbusqueda = "";
  bool rPedidos = true;
  bool rNIT = false;
  bool rFechas1 = false;
  bool rFechas2 = false;
  bool control = false;
  final _service = UserService();
  bool _isSearching = false;
  bool _isSearching2 = false;
  int RadioGroup = 1;
  List<RespuestaBusqueda> List1 = <RespuestaBusqueda>[];
  List<RespuestaPlaca> List2 = <RespuestaPlaca>[];
  List<ResumeModel> listResume = <ResumeModel>[];
  final _tfPlacas = TextEditingController();
  final _tfSucursal = TextEditingController();
  final _tfChasis = TextEditingController();
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

  _deleteFormDialog3(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Busqueda Emplacado",
              style: TextStyle(color: Colors.teal, fontSize: 25),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Actualmente no se cuenta con ningun registro como el que busca, favor validar nuevamente...',
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

  _alertdialog(String folioEmplacado){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Confirmación",
              style: TextStyle(color: Colors.blue[900], fontSize: 25),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Tu archivo será entregado, ¿Estás segur@ que deseas entregarlo?',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Aceptar',
                  style: TextStyle(color: Colors.blue[900], fontSize: 16),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Visibility(
                    visible: _isSearching2,
                    child: CircularProgressIndicator(),
                  );
                  print("aqui va el folio del emplacado");
                  print(folioEmplacado);
                  setState(() {
                    _isSearching2 = true;
                  });
                  var result = await _service.Subir_Info2(folioEmplacado).then((response){
                    if(response == 200){
                      var result2 =  _service.Subir_InfoDB(folioEmplacado).then((response2){
                        if(response2 == 200){
                          _deleteFormDialog2();
                        }else{
                          switch(response2){
                            case 400:
                              _showSuccesSnackBar("Error, validar su información en los campos.");
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
                        var resultado =  _service.ActualizacionEntregas(folioEmplacado);
                      });
                      _deleteFormDialog2();
                    }else{
                      switch(response){
                        case 400:
                          _showSuccesSnackBar("Error, validar su información en los campos.");
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
                  });
                  setState(() {
                    _isSearching2= false;
                  });
                },
              ),
              TextButton(
                child: Text('Cancelar',
                  style: TextStyle(color: Colors.red, fontSize: 16),
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



  Future<void> DetalleBusqueda(BuildContext context,  List<RespuestaBusqueda> _items2, int index) async {
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

                Row(
                  children: [
                    SizedBox(
                      width: 50,
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
                      width: 70,
                    ),
                    MaterialButton(
                        onPressed: () async {
                          _alertdialog(Lista3[index].folioEmplacado);
                        },
                        child: Icon(Icons.upload, size: 40, color: Colors.blueGrey)),

                  ],

                ),
                Row(
                  children: [
                    SizedBox(
                      width: 55,
                    ),
                    Text("Ver Archivos", style: TextStyle(
                        fontWeight: FontWeight.w500)),
                    SizedBox(
                      width: 70,
                    ),
                    Text("Subir Archivos", style: TextStyle(
                        fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 50,
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
                Row(
                  children: [
                    SizedBox(
                      width: 68,
                    ),
                    Text("Revisión", style: TextStyle(
                        fontWeight: FontWeight.w500)),
                    SizedBox(
                      width: 90,
                    ),
                    Text("Comentarios", style: TextStyle(
                        fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                /*Visibility(
                //visible: pdf,
                //visible: rPedidos,
                child: Center(
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 5,
                  ),
                ),
              ),*/
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
          'Entrega de Emplacados',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const SizedBox(

            ),
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
                  width: 50.0,
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
                        _tfSucursal.clear();
                        _tfChasis.clear();
                        List2.clear();
                        ;
                      });
                    }),
                const SizedBox(
                  height: 50.0,
                ),
                Text("PLACAS"),
                const SizedBox(
                  height: 50.0,
                ),
                const SizedBox(
                  width: 25.0,
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
                        _tfSucursal.clear();
                        _tfPlacas.clear();
                        //fechaIniSel = "";
                        //fechaFinSel = "";
                        //fechaIni.clear();
                        //fechaFin.clear();
                        //Nit.clear();
                            ;
                      });
                    }),
                Text("CHASIS"),
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
                  controller: _tfPlacas,

                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: "PLACAS",
                      border: OutlineInputBorder(),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0)),
                ),
              ),
            ),
            /*const SizedBox(
              height: 10.0,
            ),*/
           /* Visibility(
              visible: rNIT,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _tfSucursal,
                  validator: (value) {
                    if (value!.isEmpty) {
                      //setState((){ VerLista = true;});
                      return "Ingrese su Sucursal.";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: "SUCURSAL",
                      border: OutlineInputBorder(),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0)),
                ),
              ),
            ),*/
            /*const SizedBox(
              height: 10.0,
            ),*/
            Visibility(
              visible: rFechas1,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _tfChasis,
                  //keyboardType: TextInputType.,
                  validator: (value) {
                    if (value!.isEmpty) {
                      //setState((){ VerLista = true;});
                      return "Ingrese su Chasis";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: "CHASIS",
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

                await _service.BusquedaPlacas(
                    _tfPlacas.text, _tfSucursal.text, _tfChasis.text).then((
                    value) {
                  print(value);
                  List2.clear();
                  List2.addAll(value);
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
                          leading: Text(List2[index].placa.toString()),
                          title: Text(List2[index].marca),
                          subtitle: Text(List2[index].nombreCliente.toString()),
                          trailing: const Icon(Icons.info_outline),
                          onTap: () async {
                            await _service.DetalleBusquedaService(List2[index].folioEmplacado).then((value) {
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
    if(Estado == "ND")
    {
      return Colors.blue;
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
    else if (Estado == "Enviado a Sucursal")
    {
      return Colors.blue;
    }
    else if (Estado == "Entregado al Cliente")
    {
      return Colors.green[800];
    }
    else if (Estado == "Pendiente de Revisar")
    {
      return Colors.red[900];
    }
  }
}
