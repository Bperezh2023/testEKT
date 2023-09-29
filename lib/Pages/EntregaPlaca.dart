import 'package:app_itk4/Screens/revision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/Comments.dart';
import '../Screens/Imageness.dart';
import '../Screens/busqueda2.dart';
import '../Screens/pageFirma.dart';
import '../Screens/pasos.dart';
import '../Screens/upload_file.dart';
import '../model/EntregaPlacaModel.dart';
import '../model/ModelBusqueda.dart';
import '../model/modelRespBusqueda.dart';
import '../services/userService.dart';


class EntregaPlaca extends StatefulWidget {
  EntregaPlaca({Key? key}) : super(key: key);
  @override
  State<EntregaPlaca> createState() => _EntregaPlacaState();
}

class _EntregaPlacaState extends State<EntregaPlaca> {
  List<RespuestaBusquedaSimple> data = <RespuestaBusquedaSimple>[];
  List<RespuestaBusqueda> Lista3 = <RespuestaBusqueda>[];
  final _service = UserService();
  bool _isSearching = false;
  bool _isSearching2 = false;
  late BuildContext dialogContext;// global
  late BuildContext dialogContext20;// global declaration

  _showSuccesSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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

  Future tomarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    print("aqui va el folio de busqueda2");
    //print(widget.folioEmplacado);
    var Sucursal2 = prefs.getInt('Sucursal');
    var Empleado2 = prefs.getInt('Empleado');
    print("Sucursal");
    print(Sucursal2);
    print("Empleado");
    print(Empleado2);
    var registros = <RespuestaBusquedaSimple>[];
    try {
      Map mentalmap = {
        "idSucursal": Sucursal2,
        "idPedido": "",
        "numeroSerie": "",
        "cliente": {
          "nombre": "",
          "dpi": "",
          "nit": ""
        }
      };
      final UrlBusqueda = 'https://apis.italikaguatemala-dev.com/motocicletas/emplacados/busquedas';
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
        var registros = <RespuestaBusquedaSimple>[];
        var datos = json.decode(response.body);
        var datos2 = datos['resultado'];
        print("aqui ya paso!");
        print(datos2);
        for (datos in datos2) {
          Map<String, dynamic> param2 ={
            "folioEmplacado": datos["folioEmplacado"],
            "idSucursal": datos["idSucursal"].toString(),
            "idPedido": datos["idPedido"].toString(),
            "idEstado": datos["idEstado"].toString(),
            "nombre": datos["cliente"]["nombre"],
            "dpi": datos["cliente"]["dpi"],
            "nit": datos["cliente"]["nit"],
          };
          if(datos["idEstado"]==6){
            print("respuesa modelo");
            print(param2);
            registros.add(RespuestaBusquedaSimple.fromJson(param2));
            print("Modelo lleno");
            print(registros);
          }else {
        print("Failed to load jobs from API");
      }
        }
        print("otro valor");
        print(registros.length);
        return registros;
      } else {
        print("Failed to load jobs from API2");
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
    tomarDatos().then((value){
      setState(() {
        data.clear();
        data.addAll(value);
      });
    });
    print(15);
    print(tomarDatos());
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
                        onPressed: () async {
                          //_alertdialog(Lista3[index].folioEmplacado);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PaginaFirma(_items2[index])),
                          );
                        },
                        child: Icon(Icons.grid_view_rounded, size: 40, color: Colors.blueGrey)),
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
                      width: 50,
                    ),
                    Text("Entregar Placa", style: TextStyle(
                        fontWeight: FontWeight.w500)),
                    SizedBox(
                      width: 72,
                    ),
                    Text("Comentarios", style: TextStyle(
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
                            MaterialPageRoute(builder: (context) => busqueda2(folioEmplacado: _items2[index].folioEmplacado)),
                          );
                        },
                        child: Icon(Icons.view_list_outlined, size: 40, color: Colors.blueGrey)),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 58,
                    ),
                    Text("Ver Estatus", style: TextStyle(
                        fontWeight: FontWeight.w500)),
                    SizedBox(
                      width: 80,
                    ),
                    Text("Ver Archivos", style: TextStyle(
                        fontWeight: FontWeight.w500)),
                  ],
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Placas Por Entregar'),
      ),
      body: Column(
        children: [
          //data.isNotEmpty ?
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(0.5),
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.motorcycle_outlined, color: Colors.blue[500],),
                      onPressed: () {},
                    ),
                    title:Text(data[index].idPedido.toString(), style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    )),
                    //subtitle: Text('  ' +data[index].nombre.toString()),
                    subtitle: Text(data[index].nombre.toString(), style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15)),
                    //trailing: Text(data[index].id.toString()),
                    onTap: () async {
                      await _service.DetalleBusquedaService(data[index].folioEmplacado).then((value) {
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
          //   : Container()
        ],
      ),
    );
  }

  ValidarEstado(String Estado){
    if(Estado == "Nuevos")
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
