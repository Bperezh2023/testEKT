import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import '../services/userService.dart';
import 'busqueda.dart';
class Imageness extends StatefulWidget {
  const Imageness({Key? key}) : super(key: key);

  @override
  State<Imageness> createState() => _ImagenessState();
}

class _ImagenessState extends State<Imageness> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "images to pdf",
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
      ),
      home: Firstpage(),
    );
  }
}

class Firstpage extends StatefulWidget {
  @override
  _FirstpageState createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  final picker = ImagePicker();
  final pdf = pw.Document();
  List<File> image = [];
  var pageformat = "A4";
  final _userService = UserService();
  final UserService services = new UserService();
  Future<Uint8List>? MyInterest;
  var prueba;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          image.length == 0
              ? Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Seleccione imagenes de la Cámara o Galeria',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              : PdfPreview(
            maxPageWidth: 1000,
            // useActions: false,
            // canChangePageFormat: true,
            canChangeOrientation: true,
            // pageFormats:pageformat,
            canDebug: false,

            build: (format) => generateDocument(
              format,
              image.length,
              image,
            ),
          ),
          Align(
            alignment: Alignment(-0.5, 0.8),
            child: FloatingActionButton(
              elevation: 0.0,
              child: new Icon(
                Icons.image,
              ),
              backgroundColor: Colors.blue[900],
              onPressed: getImageFromGallery,
            ),
          ),
          Align(
            alignment: Alignment(0.5, 0.8),
            child: FloatingActionButton(
              elevation: 0.0,
              child: new Icon(
                Icons.camera,
              ),
              backgroundColor: Colors.blue[900],
              onPressed: getImageFromcamera,

            ),
          ),
          /*Align(
            alignment: Alignment(0.6, 0.8),
            child: FloatingActionButton(
              elevation: 0.0,
              child: new Icon(
                Icons.image,
              ),
              backgroundColor: Colors.red[900],
              onPressed: services.Subir_Info(),
            ),
          ),*/
        ],
      ),
    );
  }

  getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image.add(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });
  }

  getImageFromcamera() async {

    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        image.add(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });
  }

  Future<Uint8List> generateDocument(PdfPageFormat format, imagelenght, image) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);
    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();
    for (var im in image) {
      final showimage = pw.MemoryImage(im.readAsBytesSync());

      doc.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            pageFormat: format.copyWith(
              marginBottom: 0,
              marginLeft: 0,
              marginRight: 0,
              marginTop: 0,
            ),
            orientation: pw.PageOrientation.portrait,
            // buildBackground: (context) =>
            //     pw.Image(showimage, fit: pw.BoxFit.contain),
            theme: pw.ThemeData.withFont(
              base: font1,
              bold: font2,
            ),
          ),
          build: (context) {
            return pw.Center(
              child: pw.Image(showimage, fit: pw.BoxFit.contain),
            );
          },
        ),
      );
    }
    /*Future getAllData() async{
      return doc.save();
    }*/
    return doc.save();
    //final result = await _userService.Subir_Info();
  }
  //services.Subir_Info();
  // Route route = MaterialPageRoute(builder: (context) => UserService().Subir_Info());

}
