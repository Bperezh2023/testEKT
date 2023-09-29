import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:get/get.dart';
import 'package:simple_s3/simple_s3.dart';
import 'package:uuid/uuid.dart';
import '../Pages/placaPorEntregar.dart';
import '../Services/userService.dart';
import '../model/AppSetting.dart';
import '../model/ModelBusqueda.dart';
import 'Indicadores.dart';
import 'navigatorBar.dart';

class ReviewSignaturePage extends StatelessWidget {
  final Uint8List signature;
  final RespuestaBusqueda items;
  ReviewSignaturePage({Key? key, required this.signature,required this.items})
      : super(key: key);

  late BuildContext dialogContext;// global declaration
  late BuildContext dialogContext20;// global declaration
  late BuildContext dialogContext21;// global declaration
  late BuildContext dialogContext2;// global declaration
  @override

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
          actions: [
            IconButton(
              onPressed: () => saveSignature(context),
              icon: const Icon(Icons.save),
            ),
          ],
          centerTitle: true,
          title: const Text('Save Signature'),
        ),
        body: Center(
          child: Image.memory(signature),
        ));
  }

  Future? saveSignature(BuildContext context) async {

    final service = UserService();

    _deleteFormDialog3(context){
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
    _deleteFormDialog4(context){
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


    _deleteFormDialog2(context){
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Indicadores()),
                    );
                  },
                ),
              ],
            );
          }
      );
    }

    _showSuccesSnackBar(String message, context) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    final status = await Permission.storage.status;

    if (!status.isGranted) {
      await Permission.storage.request();
    }
    String id = "";
    const uuid = Uuid();
    id = uuid.v4();
    print(2);
    print(id);
    //making signature name unique
    final time = DateTime.now().toIso8601String().replaceAll('.', ':');
    final name = 'signature_$id';
    print("nombre1");
    print(name);

    final result = await ImageGallerySaver.saveImage(signature, name: name);
    final isSuccessful = result['isSuccess'];

    if (isSuccessful) {
      _deleteFormDialog3(context);
      final directory = await getExternalStorageDirectory();
      final picturesDirectory = '${directory?.path}/Pictures';
      print("picturesDirectory");
      print(picturesDirectory);
      print("nombre2");
      print(name);
      print("nombre mas path");
      print('/storage/emulated/0/Pictures/$name.jpg');
      print('/storage/emulated/0/Pictures/signature_2023-02-22T16_01_48_304827.jpg');
      SimpleS3 _simpleS3 = SimpleS3();
      String result = await _simpleS3.uploadFile(
        File('/storage/emulated/0/Pictures/$name.jpg'),
        bucketId,
        PoolId,
        AWSRegions.usEast1,
        fileName: id+ ".jpg",
      );
      print("folio en subir info");
      print(items.folioEmplacado);
      var resultado = await service.Subir_InfoDB2(items.folioEmplacado, id);
      var resultados2 =  service.ActualizacionEntregas(items.folioEmplacado);
      Navigator.of(context).pop();
      _deleteFormDialog2(context);
    } else {
      _deleteFormDialog3(context);
      final directory = await getExternalStorageDirectory();
      final picturesDirectory = '${directory?.path}/Pictures';
      print("picturesDirectory");
      print(picturesDirectory);
      print("nombre2");
      print(name);
      print("nombre mas path");
      print('/storage/emulated/0/Pictures/$name.jpg');
      print('/storage/emulated/0/Pictures/signature_2023-02-22T16_01_48_304827.jpg');
      SimpleS3 _simpleS3 = SimpleS3();
      String result = await _simpleS3.uploadFile(
        File('/storage/emulated/0/Pictures/$name.jpg'),
        bucketId,
        PoolId,
        AWSRegions.usEast1,
        fileName: id+ ".jpg",
      );
      print("folio en subir info");
      print(items.folioEmplacado);
      var resultado = await service.Subir_InfoDB2(items.folioEmplacado, id);
      var resultados2 =  service.ActualizacionEntregas(items.folioEmplacado);
      Navigator.of(context).pop();
      _deleteFormDialog2(context);
    }
  }
}