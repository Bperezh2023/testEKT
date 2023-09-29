import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/ModelApiDownload.dart';
import '../model/ModelBusqueda.dart';
import '../model/ModelFiles.dart';
import '../model/ModeloService.dart';
import '../services/userService.dart';
import 'JobsListView.dart';

class busqueda2 extends StatefulWidget {
  final String folioEmplacado;
  const busqueda2({Key? key, required this.folioEmplacado}) : super(key: key);

  @override
  State<busqueda2> createState() => _busqueda2State();
}

class _busqueda2State extends State<busqueda2> {
  List _items = [];
  bool isSearching2 = false;
  List<RespuestaFiles> registros = <RespuestaFiles>[];
  final _service = UserService();
  // Fetch content from the json file
  /*Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/sample.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["items"];
    });
  }*/


  informacion() async {
    final prefs = await SharedPreferences.getInstance();
    print("aqui va el folio de busqueda2");
    print(widget.folioEmplacado);
    var registros = <RespuestaFiles>[];
        try {
          Map mentalmap = {
        "inventario": "emplacados",
        "folioInventario": widget.folioEmplacado
          };
          final UrlBusqueda = 'https://apis.italikaguatemala-dev.com/archivos/busquedas';
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
            var registros = <RespuestaFiles>[];
            var datos = json.decode(response.body);
            var datos2 = datos['resultado']["archivos"];
            print("aqui ya paso!");
            print(datos2);
            for (datos in datos2) {
              Map<String, dynamic> respuesta ={
                "id": datos["id"].toString(),
                "nombre": datos["nombre"].toString(),
                "codigoArchivo": datos["codigoArchivo"].toString(),
              };
              print(1111);
              print(respuesta);
              registros.add(RespuestaFiles.fromJson(respuesta));
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
  void initState()  {
    // TODO: implement initState
    super.initState();
    informacion().then((value){
      setState(() {
        registros.clear();
        registros.addAll(value);
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
          'Documentos Emplacado',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // Display te dahta loaded from sample.json
            Visibility(
              visible: isSearching2,
              child: CircularProgressIndicator(),
            ),
            registros.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                itemCount: registros.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.picture_as_pdf),
                        onPressed: () {},
                      ),
                      title: Text(registros[index].nombre.toString()),
                      onTap: () async {
                          setState(() {
                            isSearching2 = true;
                          });
                          var result = await _service.Bajar_Info(registros[index].codigoArchivo.toString());
                          setState(() {
                          isSearching2 = false;
                          });
                        },
                    ),
                  );
                },
              ),
            )
                : Container()
          ],
        ),
      ),
    );
  }


}