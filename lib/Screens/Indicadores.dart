import 'dart:convert';

import 'package:app_itk4/Screens/firma_cliente.dart';
import 'package:app_itk4/Screens/pageFirma.dart';
import 'package:app_itk4/main.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Menu.dart';
import '../model/modelRespBusqueda.dart';
import 'Imageness.dart';
import 'addUser.dart';
import 'busqueda.dart';
import 'homepage.dart';
import 'navigatorBar.dart';

class Indicadores extends StatefulWidget {
   Indicadores({Key? key}) : super(key: key);

  @override
  State<Indicadores> createState() => _IndicadoresState();
}

class _IndicadoresState extends State<Indicadores> {
  var ConteoEstado1 = 0;
  var ConteoEstado2 = 0;
  var ConteoEstado3 = 0;
  var ConteoEstado4 = 0;
  var ConteoEstado5 = 0;
  var ConteoEstado6 = 0;
  var ConteoEstado7 = 0;
  var ConteoEstado8 = 0;
  var ConteoEstado9 = 0;
  var Status1 = 2;
  var Status2 = 0;
  var Status3 = 4;
  var Status4 = 6;
  var Total = 0;
  bool flatbutton = true;
  List<RespuestaBusquedaSimple> data = <RespuestaBusquedaSimple>[];

  _showSuccesSnackBar(String message, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future DatosIndicadores() async {
    final prefs = await SharedPreferences.getInstance();
    var Sucursal2 = prefs.getInt('Sucursal');
    var token2 = prefs.getString('token');
    print("mi variable");
    print(Sucursal2);
    print("token");
    print(token2);

    print("aqui va el folio de busqueda2");
    //print(widget.folioEmplacado);
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
        ConteoEstado1 = 0;
        ConteoEstado2 = 0;
        ConteoEstado3 = 0;
        ConteoEstado4 = 0;
        Total = 0;
        for (datos in datos2) {
            Total++;
          if(datos["idEstado"]==0){
            print("Primer Respuesta");
            ConteoEstado1++;
          }
          if(datos["idEstado"]==1){
            print("Cuarta Respuesta");
            ConteoEstado2++;
          }
          if(datos["idEstado"]==2){
            print("Segunda Respuesta");
            ConteoEstado3++;
          }
            if(datos["idEstado"]==3){
              print("Cuarta Respuesta");
              ConteoEstado4++;
            }
          if(datos["idEstado"]==4){
            print("Tercer Respuesta");
            ConteoEstado5++;
          }
          if(datos["idEstado"]==5){
            print("Cuarta Respuesta");
            ConteoEstado6++;
          }
          if(datos["idEstado"]==6){
            print("Cuarta Respuesta");
            ConteoEstado7++;
          }
          if(datos["idEstado"]==7){
            print("Cuarta Respuesta");
            ConteoEstado8++;
          }
          if(datos["idEstado"]==8){
            print("Quinta Respuesta");
            ConteoEstado9++;
          }
        }
        print("ConteoEstado1");
        print(ConteoEstado1);
        print("otro valor");
        print("Total");
        print(Total);
        print(registros.length);
        return registros;
      } else{
        switch(response.statusCode){
          case 400:
            _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.", context);
            break;
          case 401:
            _showSuccesSnackBar("Inicie Sesión nuevamente para realizar gestiones", context);
            break;
          case 404:
            _showSuccesSnackBar("No esta autorizado para ejecutar esta acción.", context);
            break;
          case 500:
            _showSuccesSnackBar("No se completo la petición intente mas tarde.", context);
            break;
        }
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
    //requestStoragePermission();
    // requestCameraPermission();
    // requestStoragePermission2();
    // requestStoragePermission4();
    // requestStoragePermission5();
    DatosIndicadores().then((value){
      setState(() {
        data.clear();
        data.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                margin: const EdgeInsets.only(top: 50, bottom: 20),
                child: Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/f/f2/Italika-logo.png"),
              ),
              const Text(
                "Menu Emplacado Italika",
                style: TextStyle(
                    color: Color.fromARGB(255, 1, 9, 100),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const SizedBox(
                height: 60.0,
              ),
              InkWell(
                child: Container(
                  child: Column(
                    children: [
                      Container(),
                      new ListTile(
                        title: Text(
                          "Nuevo Emplacado",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        tileColor: Colors.blue[50],
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddUser()));
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddUser()));
                          },
                        ),
                      ),
                      new ListTile(
                        title: Text(
                          "Buscar Emplacado",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        tileColor: Colors.blue[50],
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Busqueda()));
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Busqueda()));
                          },
                        ),
                      ),
                      new ListTile(
                        title: Text(
                          "Entrega de Placa",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        tileColor: Colors.blue[50],
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlacaPrincipal()));
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PlacaPrincipal()));
                          },
                        ),
                      ),
                      new ListTile(
                        title: Text(
                          "Escanear Archivos",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        tileColor: Colors.blue[50],
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                //Imageness
                                  builder: (context) => Imageness()));
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.document_scanner_outlined),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  //PlainTimelineDemoScreen(folio: 0,)
                                    builder: (context) => Imageness()));
                          },
                        ),
                      ),
                      new ListTile(
                        title: Text(
                          "Cerrar Sesión",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        tileColor: Colors.blue[50],
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                //PlainTimelineDemoScreen(folio: 0,)
                                  builder: (context) => MyApp()));
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.exit_to_app_outlined),
                          color: Colors.lightBlue,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(
                        height: 153.9,
                      ),
                      Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Menú - Italika"),
      ),
      body: Center(
        child: ListView(
            children: <Widget>[
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                '          Resumen de Emplacado',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.blueGrey,
                    //Color.fromARGB(255, 16, 28, 156),
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 30.0,
              ),

              Container(
                padding: EdgeInsets.all(15.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Menu(8)));
                      },
                      child: CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 20.0,
                        animation: true,
                        percent: ConteoEstado9 / Total,
                        center: Text(
                          "  $ConteoEstado9 /\n  $Total",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.blue[900]),
                        ),
                        footer: Text(
                          "\n Nuevos\n",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.blue[900]),
                        ),
                        backgroundColor: Color.fromARGB(255, 190, 191, 202),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.blue[900],
                        //Color.fromARGB(255, 10, 24, 228),
                        //progressColor: Colors.green,
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Menu(0)));
                      },
                      child: CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 20.0,
                        animation: true,
                        percent: ConteoEstado1 / Total,
                        center: Text(
                          "  $ConteoEstado1 /\n  $Total",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.blue[900]),
                        ),
                        footer: Text(
                          "\n Pendientes de\n       Revisar",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.blue[900]),
                        ),
                        backgroundColor: Color.fromARGB(255, 190, 191, 202),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.yellow[700],
                        //Color.fromARGB(255, 10, 24, 228),
                        //progressColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        var selector = 0;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Menu(1)));
                      },
                      child: CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 20.0,
                        animation: true,
                        percent: ConteoEstado2 / Total,
                        center: Text(
                          "  $ConteoEstado2 /\n  $Total",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.blue[900]),
                        ),
                        footer: Text(
                          "\n Aceptados",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.blue[900]),
                        ),
                        backgroundColor: Color.fromARGB(255, 190, 191, 202),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.green[700],
                        //progressColor: Colors.green,
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                    ),
                    GestureDetector(
                      onTap: (){
                        var selector = 4;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Menu(2)));
                      },
                      child: CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 20.0,
                        animation: true,
                        percent: ConteoEstado3 / Total,
                        center: Text(
                          "  $ConteoEstado3 /\n  $Total",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.blue[900]),
                        ),
                        footer: Text(
                          "\n Rechazados",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.blue[900]),
                        ),
                        backgroundColor: Color.fromARGB(255, 190, 191, 202),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.red[900],
                        //progressColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Menu(3)));
                      },
                      child: CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 20.0,
                        animation: true,
                        percent: ConteoEstado4 / Total,
                        center: Text(
                          "  $ConteoEstado4 /\n  $Total",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              color: Colors.blue[900]),
                        ),
                        footer: Text(
                          "\n En Pagos",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.blue[900]),
                        ),
                        backgroundColor: Color.fromARGB(255, 190, 191, 202),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.green[700],
                        //progressColor: Colors.green,
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Menu(4)));
                      },
                      child: CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 20.0,
                        animation: true,
                        percent: ConteoEstado5 / Total,
                        center: Text(
                          "  $ConteoEstado5 /\n  $Total",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.blue[900]),
                        ),
                        footer: Text(
                          "\n Enviado a SAT",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.blue[900]),
                        ),
                        backgroundColor: Color.fromARGB(255, 190, 191, 202),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.green[700],
                        //Color.fromARGB(255, 10, 24, 228),
                        //progressColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        var selector = 0;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Menu(5)));
                      },
                      child: CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 20.0,
                        animation: true,
                        percent: ConteoEstado6 / Total,
                        center: Text(
                          "  $ConteoEstado6 /\n  $Total",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.blue[900]),
                        ),
                        footer: Text(
                          "\n   Placas \nAsignadas",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.blue[900]),
                        ),
                        backgroundColor: Color.fromARGB(255, 190, 191, 202),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.green[700],
                        //progressColor: Colors.green,
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Menu(6)));
                      },
                      child: CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 20.0,
                        animation: true,
                        percent: ConteoEstado7 / Total,
                        center: Text(
                          "  $ConteoEstado7 /\n  $Total",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.blue[900]),
                        ),
                        footer: Text(
                          "\n      Placas \n en Sucursal",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.blue[900]),
                        ),
                        backgroundColor: Color.fromARGB(255, 190, 191, 202),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.red[900],
                        //Color.fromARGB(255, 10, 24, 228),
                        //progressColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        var selector = 0;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Menu(7)));
                      },
                      child: CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 20.0,
                        animation: true,
                        percent: ConteoEstado8 / Total,
                        center: Text(
                          "  $ConteoEstado8 /\n  $Total",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.blue[900]),
                        ),
                        footer: Text(
                          "\nPlacas Entregadas \n         a Clientes",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.blue[900]),
                        ),
                        backgroundColor: Color.fromARGB(255, 190, 191, 202),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Color.fromARGB(255, 10, 24, 228),
                        //progressColor: Colors.green,
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),

            ]),
      ),
      //levanta
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Indicadores()),
          );
        },
        child: Icon(Icons.update),
      )
    );
  }
}