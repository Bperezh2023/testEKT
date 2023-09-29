import 'package:app_itk4/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Services/userService.dart';
import '../model/ModelBusqueda.dart';
import 'homepage.dart';


class PaginaFirma extends StatefulWidget {
  final RespuestaBusqueda items;
  const PaginaFirma( this.items, {Key? key}) : super(key: key);

  @override
  State<PaginaFirma> createState() => _PaginaFirmaState();
}

class _PaginaFirmaState extends State<PaginaFirma> {
  @override
  final _service = UserService();
  late BuildContext dialogContext;// global declaration
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
                  print("aqui va el folio del emplacado");
                  print(folioEmplacado);
                  var result = await _service.Subir_InfoPNG(folioEmplacado).then((response){
                    if(response == 200){
                      var result2 =  _service.Subir_InfoDB2(folioEmplacado, "").then((response2){
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
                        //var resultado =  _service.ActualizacionEntregas(folioEmplacado);
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


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Firma del Cliente"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
           Text(
          '  Informe de Terminos y \n Condiciones de la Placa',
          style: TextStyle(
              fontSize: 25,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w500),
        ),
         SizedBox(
          height: 80.0,
            ),
             Text(
              "Por medio de la presente, yo " + widget.items.nombre.toString() + " que me identifico con numero de DPI: "
                  + widget.items.dpi+" dejo constancia que me fue entregada la placa de circulacion del vehiculo con serie: "
                  + widget.items.numeroSerie + " libero de cualquier responsabilidad a ELEKTRA DE GUATEMALA, S.A. de cualquier"
                  "responsabilidad civil, penal, administrativa y/o de cualquier naturaleza en virtud de haber recibido la placa.",
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
                SizedBox(
                  width: 130,
                ),
                MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(widget.items)),
                      );
                    },
                    child: Icon(Icons.account_box_rounded, size: 40, color: Colors.blueGrey)),
                SizedBox(
                  width: 70,
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 130,
                ),
                Text("Firma Cliente", style: TextStyle(
                    fontWeight: FontWeight.w500)),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ]
        ),
      ),
    );
  }
}
