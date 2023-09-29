import 'dart:async';
import 'dart:ffi';
import 'dart:io' as io;
import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_s3/simple_s3.dart';
import 'package:pdf/pdf.dart';
import '../model/AppSetting.dart';
import '../model/EntregaPlacaModel.dart';
import '../model/ModelApiDownload.dart';
import '../model/ModelBusqueda.dart';
import '../model/ModelFiles.dart';
import '../model/ModeloService.dart';
import '../model/User.dart';
import 'package:path_provider/path_provider.dart';
import '../model/modelActualizacion.dart';
import '../model/modelApi.dart';
import '../model/modelApiFile.dart';
import '../model/modelComentario.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/modelRespBusqueda.dart';
import '../model/valiLogin.dart';

class UserService {
  double resprestamos2 = 0;
  double resprestamos3 = 0;
  double resprestamos4 = 0;
  List _items = [];
  List<RespuestaApiFile> realconect = <RespuestaApiFile>[];
  List<RespuestaApiDownload> conexion = <RespuestaApiDownload>[];
  var registros = <RespuestaBusqueda>[];
  List respuesta = [];
  var datos;
  String id = "";
  String extension = "";
  static var Categoria = "";
  static int invoice = 0;
  static int Sucursal = 0;
  static int Empleado = 0;
  static var token = "";
  static int folt = 0;
  static int pruebas = 0;
  String pruebas2 = "";
  static int respuestaCode = 0;

  Bajar_Info(String codigoArchivo) async {
    print("codigo archivo 101010");
    print(codigoArchivo);

    final AwsS3Client s3client = AwsS3Client(
        region: region,
        bucketId: bucketId,
        accessKey: IDdocsemplacado,
        secretKey: Secretdocsemplacado);

    String filename = codigoArchivo;

    //final response22 = await FilePicker.platform.pickFiles();
    final response2 = await s3client.getObject(filename);
    List<int> bytes2 = response2.bodyBytes;
    final path = (await getExternalStorageDirectory())!.path;
    final file = File('$path/$filename');
    print(22);
    print('$path/$filename');
    await file.writeAsBytes(bytes2, flush: true);
    OpenFilex.open('$path/$filename');
  }

  Subir_Info2(String folioEmplacado) async {
    try {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String documentPath = documentDirectory.path;
      final resultado = await FilePicker.platform.pickFiles();

      // Obtiene la extensión del archivo seleccionado
      extension = path.extension(resultado?.files.single.path ?? '');

      // Verifica si la extensión del archivo es .jpg o .pdf
      if (extension != '.jpg' &&
          extension != '.pdf' &&
          extension != '.jpeg' &&
          extension != '.png') {
        return 600;
      }
      const uuid = Uuid();
      id = uuid.v4();
      SimpleS3 _simpleS3 = SimpleS3();
      String result = await _simpleS3.uploadFile(
        File((resultado?.files.single.path).toString()),
        bucketId,
        PoolId,
        AWSRegions.usEast1,
        fileName: id + extension,
      );
      return 200;
    } catch (e) {
      return 400;
    }
  }

  Subir_Info3(String folioEmplacado) async {
    // returns url pointing to S3 filef
    try {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String documentPath = documentDirectory.path;
      print(2);
      print(documentPath);
      final resultado = await FilePicker.platform.pickFiles();
      String extension = path.extension(resultado?.files.single.path ?? '');

      // Verifica si la extensión del archivo es .jpg o .pdf
      if (extension != '.jpg' && extension != '.pdf') {
        print("no se pudo llegar aqu+i");
      }
      //String filename = "/storage/emulated/0/Download/Commands2.png";
      const uuid = Uuid();
      id = uuid.v4();
      print(2);
      print(id);
      SimpleS3 _simpleS3 = SimpleS3();
      String result = await _simpleS3.uploadFile(
        File((resultado?.files.single.path).toString()),
        bucketId,
        PoolId,
        AWSRegions.usEast1,
        fileName: id + extension,
      );
      return 200;
    } catch (e) {
      return (400);
    }
  }

  Subir_InfoPNG(String folioEmplacado) async {
    // returns url pointing to S3 filef
    try {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String documentPath = documentDirectory.path;
      print(2);
      print(documentPath);
      final resultado = await FilePicker.platform.pickFiles();
      //String filename = "/storage/emulated/0/Download/Commands2.png";
      const uuid = Uuid();
      id = uuid.v4();
      print(2);
      print(id);
      SimpleS3 _simpleS3 = SimpleS3();
      String result = await _simpleS3.uploadFile(
        File((resultado?.files.single.path).toString()),
        bucketId,
        PoolId,
        AWSRegions.usEast1,
        fileName: id + ".jpg",
      );
      return 200;
    } catch (e) {
      return (400);
    }
  }

  Subir_InfoDB(String folioEmplacado) async {
    final prefs = await SharedPreferences.getInstance();
    var Sucursal2 = prefs.getInt('Sucursal');
    var Empleado2 = prefs.getInt('Empleado');
    print("Sucursal");
    print(Sucursal2);
    print("Empleado");
    print(Empleado2);
    try {
      print("codigo de archivo DB");
      print(id);
      Map mentalmap = {
        "inventario": "Emplacados",
        "codigoArchivo": id + extension,
        "nombreArchivo": "Archivo Completo",
        "folioInventario": folioEmplacado,
        "usuarioCreo": Empleado2.toString(),
        "revision": true
      };
      final UrlBusqueda = 'https://apis.italikaguatemala-dev.com/archivos';
      final response = await http
          .post(Uri.parse(UrlBusqueda), body: jsonEncode(mentalmap), headers: {
        "Content-Type": "application/json",
        //"Content-Length": "0"
        //, "Host": "calculated when request is sent"
        //,"User-Agent": "PostmanRuntime/7.29.2"
        "Accept": "/",
        "Authorization": "Bearer " + await prefs.getString('token')!
        //,"Accept-Encoding": "gzip, deflate, br"
        //,"Connection": "keep-alive"
      });
      var datatab = json.decode(response.body);
      print(jsonEncode(mentalmap));
      print(response.statusCode);
      if (response.statusCode == 201) {
        print('exitoso');
      } else {
        throw Exception("Error al cargar el Api");
      }
      return response.statusCode;
    } catch (e) {
      return 400;
    }
  }

  Subir_InfoDB2(String folioEmplacado, String CodigoArchivo) async {
    final prefs = await SharedPreferences.getInstance();
    var Sucursal2 = prefs.getInt('Sucursal');
    var Empleado2 = prefs.getInt('Empleado');
    print("Sucursal");
    print(Sucursal2);
    print("Empleado");
    print(Empleado2);
    print("id");
    print(CodigoArchivo);
    try {
      print("codigo de archivo DB");
      print(id);
      Map mentalmap = {
        "inventario": "Emplacados",
        "codigoArchivo": CodigoArchivo + ".jpg",
        "nombreArchivo": folioEmplacado,
        "folioInventario": folioEmplacado,
        "usuarioCreo": Empleado2.toString(),
        "revision": true
      };
      final UrlBusqueda = 'https://apis.italikaguatemala-dev.com/archivos';
      final response = await http
          .post(Uri.parse(UrlBusqueda), body: jsonEncode(mentalmap), headers: {
        "Content-Type": "application/json",
        //"Content-Length": "0"
        //, "Host": "calculated when request is sent"
        //,"User-Agent": "PostmanRuntime/7.29.2"
        "Accept": "/",
        "Authorization": "Bearer " + await prefs.getString('token')!
        //,"Accept-Encoding": "gzip, deflate, br"
        //,"Connection": "keep-alive"
      });
      var datatab = json.decode(response.body);
      print(jsonEncode(mentalmap));
      print(response.statusCode);
      if (response.statusCode == 201) {
        print('exitoso');
      } else {
        throw Exception("Error al cargar el Api");
      }
      return response.statusCode;
    } catch (e) {
      return 400;
    }
  }

  Subir_InfoDPI(String folioEmplacado) async {
    final prefs = await SharedPreferences.getInstance();
    var Sucursal2 = prefs.getInt('Sucursal');
    var Empleado2 = prefs.getInt('Empleado');
    print("Sucursal");
    print(Sucursal2);
    print("Empleado");
    print(Empleado2);
    print("id");
    print(folioEmplacado);
    try {
      print("codigo de archivo DB");
      print(id);
      Map mentalmap = {
        "inventario": "Emplacados",
        "codigoArchivo": id + extension,
        "nombreArchivo": "DPI",
        "folioInventario": folioEmplacado,
        "usuarioCreo": Empleado2.toString(),
        "revision": true
      };
      final UrlBusqueda = 'https://apis.italikaguatemala-dev.com/archivos';
      final response = await http
          .post(Uri.parse(UrlBusqueda), body: jsonEncode(mentalmap), headers: {
        "Content-Type": "application/json",
        //"Content-Length": "0"
        //, "Host": "calculated when request is sent"
        //,"User-Agent": "PostmanRuntime/7.29.2"
        "Accept": "/",
        "Authorization": "Bearer " + await prefs.getString('token')!
        //,"Accept-Encoding": "gzip, deflate, br"
        //,"Connection": "keep-alive"
      });
      var datatab = json.decode(response.body);
      print(jsonEncode(mentalmap));
      print(response.statusCode);
      if (response.statusCode == 201) {
        print('exitoso');
      } else {
        throw Exception("Error al cargar el Api");
      }
      return response.statusCode;
    } catch (e) {
      return 400;
    }
  }

  Subir_InfoFactura(String folioEmplacado) async {
    final prefs = await SharedPreferences.getInstance();
    var Sucursal2 = prefs.getInt('Sucursal');
    var Empleado2 = prefs.getInt('Empleado');
    print("Sucursal");
    print(Sucursal2);
    print("Empleado");
    print(Empleado2);
    print("id");
    print(folioEmplacado);
    try {
      print("codigo de archivo DB");
      print(id);
      Map mentalmap = {
        "inventario": "Emplacados",
        "codigoArchivo": id + extension,
        "nombreArchivo": "Factura",
        "folioInventario": folioEmplacado,
        "usuarioCreo": Empleado2.toString(),
        "revision": true
      };
      final UrlBusqueda = 'https://apis.italikaguatemala-dev.com/archivos';
      final response = await http
          .post(Uri.parse(UrlBusqueda), body: jsonEncode(mentalmap), headers: {
        "Content-Type": "application/json",
        //"Content-Length": "0"
        //, "Host": "calculated when request is sent"
        //,"User-Agent": "PostmanRuntime/7.29.2"
        "Accept": "/",
        "Authorization": "Bearer " + await prefs.getString('token')!
        //,"Accept-Encoding": "gzip, deflate, br"
        //,"Connection": "keep-alive"
      });
      var datatab = json.decode(response.body);
      print(jsonEncode(mentalmap));
      print(response.statusCode);
      if (response.statusCode == 201) {
        print('exitoso');
      } else {
        throw Exception("Error al cargar el Api");
      }
      return response.statusCode;
    } catch (e) {
      return 400;
    }
  }

  Subir_InfoRTU(String folioEmplacado) async {
    final prefs = await SharedPreferences.getInstance();
    var Sucursal2 = prefs.getInt('Sucursal');
    var Empleado2 = prefs.getInt('Empleado');
    print("Sucursal");
    print(Sucursal2);
    print("Empleado");
    print(Empleado2);
    print("id");
    print(folioEmplacado);
    try {
      print("codigo de archivo DB");
      print(id);
      Map mentalmap = {
        "inventario": "Emplacados",
        "codigoArchivo": id + extension,
        "nombreArchivo": "RTU",
        "folioInventario": folioEmplacado,
        "usuarioCreo": Empleado2.toString(),
        "revision": true
      };
      final UrlBusqueda = 'https://apis.italikaguatemala-dev.com/archivos';
      final response = await http
          .post(Uri.parse(UrlBusqueda), body: jsonEncode(mentalmap), headers: {
        "Content-Type": "application/json",
        //"Content-Length": "0"
        //, "Host": "calculated when request is sent"
        //,"User-Agent": "PostmanRuntime/7.29.2"
        "Accept": "/",
        "Authorization": "Bearer " + await prefs.getString('token')!
        //,"Accept-Encoding": "gzip, deflate, br"
        //,"Connection": "keep-alive"
      });
      var datatab = json.decode(response.body);
      print(jsonEncode(mentalmap));
      print(response.statusCode);
      if (response.statusCode == 201) {
        print('exitoso');
      } else {
        throw Exception("Error al cargar el Api");
      }
      return response.statusCode;
    } catch (e) {
      return 400;
    }
  }

  Subir_InfoActa(String folioEmplacado) async {
    final prefs = await SharedPreferences.getInstance();
    var Sucursal2 = prefs.getInt('Sucursal');
    var Empleado2 = prefs.getInt('Empleado');
    print("Sucursal");
    print(Sucursal2);
    print("Empleado");
    print(Empleado2);
    print("id");
    print(folioEmplacado);
    try {
      print("codigo de archivo DB");
      print(id);
      Map mentalmap = {
        "inventario": "Emplacados",
        "codigoArchivo": id + extension,
        "nombreArchivo": "Acta de Entrega",
        "folioInventario": folioEmplacado,
        "usuarioCreo": Empleado2.toString(),
        "revision": true
      };
      final UrlBusqueda = 'https://apis.italikaguatemala-dev.com/archivos';
      final response = await http
          .post(Uri.parse(UrlBusqueda), body: jsonEncode(mentalmap), headers: {
        "Content-Type": "application/json",
        //"Content-Length": "0"
        //, "Host": "calculated when request is sent"
        //,"User-Agent": "PostmanRuntime/7.29.2"
        "Accept": "/",
        "Authorization": "Bearer " + await prefs.getString('token')!
        //,"Accept-Encoding": "gzip, deflate, br"
        //,"Connection": "keep-alive"
      });
      var datatab = json.decode(response.body);
      print(jsonEncode(mentalmap));
      print(response.statusCode);
      if (response.statusCode == 201) {
        print('exitoso');
      } else {
        throw Exception("Error al cargar el Api");
      }
      return response.statusCode;
    } catch (e) {
      return 400;
    }
  }

  Subir_InfoResponsabilidad(String folioEmplacado) async {
    final prefs = await SharedPreferences.getInstance();
    var Sucursal2 = prefs.getInt('Sucursal');
    var Empleado2 = prefs.getInt('Empleado');
    print("Sucursal");
    print(Sucursal2);
    print("Empleado");
    print(Empleado2);
    print("id");
    print(folioEmplacado);
    try {
      print("codigo de archivo DB");
      print(id);
      Map mentalmap = {
        "inventario": "Emplacados",
        "codigoArchivo": id + extension,
        "nombreArchivo": "Carta de Responsabilidad",
        "folioInventario": folioEmplacado,
        "usuarioCreo": Empleado2.toString(),
        "revision": true
      };
      final UrlBusqueda = 'https://apis.italikaguatemala-dev.com/archivos';
      final response = await http
          .post(Uri.parse(UrlBusqueda), body: jsonEncode(mentalmap), headers: {
        "Content-Type": "application/json",
        //"Content-Length": "0"
        //, "Host": "calculated when request is sent"
        //,"User-Agent": "PostmanRuntime/7.29.2"
        "Accept": "/",
        "Authorization": "Bearer " + await prefs.getString('token')!
        //,"Accept-Encoding": "gzip, deflate, br"
        //,"Connection": "keep-alive"
      });
      var datatab = json.decode(response.body);
      print(jsonEncode(mentalmap));
      print(response.statusCode);
      if (response.statusCode == 201) {
        print('exitoso');
      } else {
        throw Exception("Error al cargar el Api");
      }
      return response.statusCode;
    } catch (e) {
      return 400;
    }
  }

  Subir_InfoRegMer(String folioEmplacado) async {
    final prefs = await SharedPreferences.getInstance();
    var Sucursal2 = prefs.getInt('Sucursal');
    var Empleado2 = prefs.getInt('Empleado');
    print("Sucursal");
    print(Sucursal2);
    print("Empleado");
    print(Empleado2);
    print("id");
    print(folioEmplacado);
    try {
      print("codigo de archivo DB");
      print(id);
      Map mentalmap = {
        "inventario": "Emplacados",
        "codigoArchivo": id + extension,
        "nombreArchivo": "Nombramiento (Reg/Mer)",
        "folioInventario": folioEmplacado,
        "usuarioCreo": Empleado2.toString(),
        "revision": true
      };
      final UrlBusqueda = 'https://apis.italikaguatemala-dev.com/archivos';
      final response = await http
          .post(Uri.parse(UrlBusqueda), body: jsonEncode(mentalmap), headers: {
        "Content-Type": "application/json",
        //"Content-Length": "0"
        //, "Host": "calculated when request is sent"
        //,"User-Agent": "PostmanRuntime/7.29.2"
        "Accept": "/",
        "Authorization": "Bearer " + await prefs.getString('token')!
        //,"Accept-Encoding": "gzip, deflate, br"
        //,"Connection": "keep-alive"
      });
      var datatab = json.decode(response.body);
      print(jsonEncode(mentalmap));
      print(response.statusCode);
      if (response.statusCode == 201) {
        print('exitoso');
      } else {
        throw Exception("Error al cargar el Api");
      }
      return response.statusCode;
    } catch (e) {
      return 400;
    }
  }

  Future ValidacionChasis(String _tfChasis, String _tfPedido) async {
    final prefs = await SharedPreferences.getInstance();
    var Sucursal2 = prefs.getInt('Sucursal');
    var Empleado2 = prefs.getInt('Empleado');
    print("Sucursal");
    print(Sucursal2);
    print("Empleado");
    print(Empleado2);
    try {
      Map mentalmap = {};
      if (_tfPedido == "") {
        mentalmap = {
          "idSucursal": Sucursal2,
          "idPedido": "",
          "numeroSerie": _tfChasis,
          "cliente": {"nombre": "", "dpi": "", "nit": ""}
        };
      }

      if (_tfChasis == "") {
        mentalmap = {
          "idSucursal": Sucursal2,
          "idPedido": _tfPedido,
          "numeroSerie": "",
          "cliente": {"nombre": "", "dpi": "", "nit": ""}
        };
      }

      final UrlBusqueda =
          'https://apis.italikaguatemala-dev.com/motocicletas/emplacados/busquedas';
      final response = await http
          .post(Uri.parse(UrlBusqueda), body: jsonEncode(mentalmap), headers: {
        "Content-Type": "application/json",
        //"Content-Length": "0"
        //, "Host": "calculated when request is sent"
        //,"User-Agent": "PostmanRuntime/7.29.2"
        "Accept": "/",
        "Authorization": "Bearer " + await prefs.getString('token')!
        //,"Accept-Encoding": "gzip, deflate, br"
        //,"Connection": "keep-alive"
      });
      var datatab = json.decode(response.body);

      if (response.statusCode == 200) {
      } else {
        throw Exception("Error al cargar el Api");
      }
      return response.statusCode;
    } catch (e) {
      return 400;
    }
  }

  Future ValidacionChasis2(String _tfChasis) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      Map mentalmap = {"numeroSerie": _tfChasis, "marca": "ITALIKA"};

      final UrlBusqueda =
          'https://apis.italikaguatemala-dev.com/motocicletas/busquedas';
      final response = await http
          .post(Uri.parse(UrlBusqueda), body: jsonEncode(mentalmap), headers: {
        "Content-Type": "application/json",
        //"Content-Length": "0"
        //, "Host": "calculated when request is sent"
        //,"User-Agent": "PostmanRuntime/7.29.2"
        "Accept": "/",
        "Authorization": "Bearer " + await prefs.getString('token')!
        //,"Accept-Encoding": "gzip, deflate, br"
        //,"Connection": "keep-alive"
      });
      var datatab = json.decode(response.body);
      if (response.statusCode == 200) {
      } else {
        throw Exception("Error al cargar el Api");
      }
      return response.statusCode;
    } catch (e) {
      return 400;
    }
  }

  informacion(String folioEmplacado) async {
    final prefs = await SharedPreferences.getInstance();
    var registros = <RespuestaFiles>[];
    try {
      Map mentalmap = {
        "tabla": "emplacados",
        "idBucket": "",
        "nombreArchivo": "Bryan Perez",
        "folio": folioEmplacado,
        "usuarioCreo": ""
      };
      print(10);
      print(mentalmap);
      final UrlBusqueda =
          'https://apis.italikaguatemala-dev.com/archivos/busquedas';
      final response = await http
          .post(Uri.parse(UrlBusqueda), body: json.encode(mentalmap), headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer " + await prefs.getString('token')!
      });
      print(2);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        var registros = <RespuestaFiles>[];
        var datos = json.decode(response.body);
        var datos2 = datos['resultado'];
        print("aqui ya paso!");
        print(datos2);
        for (datos in datos2) {
          Map<String, dynamic> param2 = {
            "id": datos["archivos"]["id"],
            "nombre": datos["archivos"]["nombre"],
            "folio": datos["archivos"]["folio"],
            "idBucket": datos["archivos"]["idBucket"],
          };
          print(1111);
          print(param2);
          registros.add(RespuestaFiles.fromJson(param2));
        }
        print("otro valor");
        print(registros);
        return registros;
      } else {
        print("Failed to load jobs from API2");
      }
    } catch (e) {
      print(e);
    }
    return registros;
  }

  createUuid() {
    const uuid = Uuid();
    //Create UUID version-4
    return uuid.v4();
  }

  static Future CargaApiUser(
      String _tfidSucursal,
      String _tfPedido,
      String _tfChasis,
      String _tfDPI,
      String _tfNIT,
      String _tfDireccion,
      String _tfTelefono,
      String _tfNombres,
      String _tfCorreo,
      String _tfComentario,
      int _tipodeVenta,
      int _tipoCliente,
      String _myCity,
      String _myState,
      int idGenero) async {
    print(22456);
    print(_tipoCliente);
    final prefs = await SharedPreferences.getInstance();
    var Sucursal2 = prefs.getInt('Sucursal');
    var Empleado2 = prefs.getInt('Empleado').toString();
    print("Sucursal");
    print(Sucursal2);
    print("Empleado");
    print(Empleado2);
    print(123456789);
    print(_tipodeVenta);
    print(123456789);
    print(_myCity);
    try {
      Map mentalmap = {
        "idUsuarioCreo": Empleado2.toString(),
        "idPedido": _tfPedido,
        "idTipoVenta": _tipodeVenta,
        "numeroSerie": _tfChasis,
        "idSucursal": Sucursal2,
        "cliente": {
          "idTipo": _tipoCliente,
          "idDepartamento": _myState,
          "idMunicipio": _myCity,
          "nombre": _tfNombres,
          "dpi": _tfDPI,
          "nit": _tfNIT,
          "idGenero": idGenero,
          "direccion": _tfDireccion,
          "telefono": _tfTelefono,
          "correo": _tfCorreo
        }
      };
      final UrlBusqueda =
          'https://apis.italikaguatemala-dev.com/motocicletas/emplacados';
      final response = await http
          .post(Uri.parse(UrlBusqueda), body: jsonEncode(mentalmap), headers: {
        "Content-Type": "application/json",
        //"Content-Length": "0"
        //, "Host": "calculated when request is sent"
        //,"User-Agent": "PostmanRuntime/7.29.2"
        "Accept": "/",
        "Authorization": "Bearer " + await prefs.getString('token')!
        //,"Accept-Encoding": "gzip, deflate, br"
        //,"Connection": "keep-alive"
      });
      print("encode");
      print(jsonEncode(mentalmap));
      print(mentalmap);
      var datatab = json.decode(response.body);
      print("datatab here!");
      print(datatab);
      var prueba = datatab['resultado']['folioEmplacado'];
      print("otra referencia");
      print(prueba);
      print(jsonEncode(mentalmap));
      print(mentalmap);
      print(response.statusCode);
      if (response.statusCode == 201) {
        print('exitoso');
      } else {
        throw Exception("Error al cargar el Api");
      }
      return response.statusCode;
    } catch (e) {
      return 400;
    }
  }

  static Future ActualizarInfo(
      String _tfidSucursal,
      String _tfPedido,
      String _tfChasis,
      String _tfDPI,
      String _tfNIT,
      String _tfDireccion,
      String _tfTelefono,
      String _tfNombres,
      String _tfCorreo,
      String _tfComentario,
      int tipodeVenta2,
      int tipoCliente2,
      String _myCity,
      String _myState,
      String folioEmplacado,
      String idUsuarioModifico,
      String idEstado,
      int idGenero2) async {
    print("tipo de venta 2 en service");
    print(tipodeVenta2);
    print("tipo de genero");
    print(idGenero2);
    var registros = <RespuestaActualizacion>[];
    final prefs = await SharedPreferences.getInstance();
    print("folio");
    print(folioEmplacado);
    var Sucursal2 = prefs.getInt('Sucursal');
    var Empleado2 = prefs.getInt('Empleado');
    var token2 = prefs.getString('token');
    print("Sucursal");
    print(Sucursal2);
    print("Empleado");
    print(Empleado2);

    print("folio emplacado:");
    print(folioEmplacado);
    print("idUsuariomodifico");
    print(idUsuarioModifico);
    print(_myState);
    print(_myCity);
    try {
      Map mentalmap = {
        "folioEmplacado": folioEmplacado,
        "idUsuarioModifico": Empleado2.toString(),
        "idTipoVenta": tipodeVenta2,
        "cliente": {
          "idTipo": tipoCliente2,
          "idDepartamento": _myState,
          "idMunicipio": _myCity,
          "nombre": _tfNombres,
          "dpi": _tfDPI,
          "nit": _tfNIT,
          "idGenero": idGenero2,
          "direccion": _tfDireccion,
          "telefono": _tfTelefono,
          "correo": _tfCorreo
        }
      };
      final UrlBusqueda =
          'https://apis.italikaguatemala-dev.com/motocicletas/emplacados';
      final response = await http
          .put(Uri.parse(UrlBusqueda), body: jsonEncode(mentalmap), headers: {
        "Content-Type": "application/json",
        //"Content-Length": "0"
        //, "Host": "calculated when request is sent"
        //,"User-Agent": "PostmanRuntime/7.29.2"
        "Accept": "/",
        "Authorization": "Bearer " + await prefs.getString('token')!
        //,"Accept-Encoding": "gzip, deflate, br"
        //,"Connection": "keep-alive"
      });
      var datatab = json.decode(response.body);
      print(jsonEncode(mentalmap));
      print(mentalmap);
      print(response.statusCode);
      print("tipo de venta 2 en service2");
      print(tipodeVenta2);
      if (response.statusCode == 200) {
        print('exitoso');
      } else {
        throw Exception("Error al cargar el Api");
      }
      return response.statusCode;
    } catch (e) {
      print(e);
      return 400;
    }
  }

  ActualizacionEntregas(String folioEmplacado) async {
    final prefs = await SharedPreferences.getInstance();
    print("folio");
    print(folioEmplacado);
    var Sucursal2 = prefs.getInt('Sucursal');
    var Empleado2 = prefs.getInt('Empleado');
    print("Sucursal");
    print(Sucursal2);
    print("Empleado");
    print(Empleado2);

    try {
      Map mentalmap = {
        "idSucursal": Sucursal2,
        "folioEmplacado": folioEmplacado,
        "idUsuarioModifico": Empleado2.toString(),
        "idEstado": 7
      };
      final UrlBusqueda =
          'https://apis.italikaguatemala-dev.com/motocicletas/emplacados/entregas';
      final response = await http
          .put(Uri.parse(UrlBusqueda), body: jsonEncode(mentalmap), headers: {
        "Content-Type": "application/json",
        //"Content-Length": "0"
        //, "Host": "calculated when request is sent"
        //,"User-Agent": "PostmanRuntime/7.29.2"
        "Accept": "/",
        "Authorization": "Bearer " + await prefs.getString('token')!
      });
      var datatab = json.decode(response.body);
      print(jsonEncode(mentalmap));
      print(mentalmap);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('exitoso');
        print("ya termino, llegó hasta aqui");
      } else {
        throw Exception("Error al cargar el Api");
      }
    } catch (e) {
      print(e);
    }
  }

  ActualizacionEntregas2(String folioEmplacado) async {
    final prefs = await SharedPreferences.getInstance();
    print("folio");
    print(folioEmplacado);
    var Sucursal2 = prefs.getInt('Sucursal');
    var Empleado2 = prefs.getInt('Empleado');
    var token2 = prefs.getString('token');
    print("Sucursal");
    print(Sucursal2);
    print("Empleado");
    print(Empleado2);

    try {
      Map mentalmap = {
        "idSucursal": Sucursal2,
        "folioEmplacado": folioEmplacado,
        "idUsuarioModifico": Empleado2.toString(),
        "idEstado": 0
      };
      final UrlBusqueda =
          'https://apis.italikaguatemala-dev.com/motocicletas/emplacados/entregas';
      final response = await http
          .put(Uri.parse(UrlBusqueda), body: jsonEncode(mentalmap), headers: {
        "Content-Type": "application/json",
        "Accept": "/",
        "Authorization": "Bearer " + await prefs.getString('token')!
      });
      var datatab = json.decode(response.body);
      print(jsonEncode(mentalmap));
      print(mentalmap);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('exitoso');
        print("ya termino, llegó hasta aqui");
      } else {
        throw Exception("Error al cargar el Api");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print('path ${path}');
    return File('$path/counter.txt');
  }

  Future<int> deleteFile() async {
    try {
      final file = await _localFile;

      await file.delete();
    } catch (e) {}
    return 0;
  }

  Eliminar() async {
    final fileName = "Document.pdf";
    Directory? dir = await getApplicationDocumentsDirectory();
    final targetFile = Directory("${dir.path}/Download/$fileName");
    if (targetFile.existsSync()) {
      targetFile.deleteSync(recursive: true);
    } else {
      print("archivo no existe");
    }
  }

  Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      return await sourceFile.rename(newPath);
    } on FileSystemException catch (e) {
      final newFile = await sourceFile.copy(newPath);
      await sourceFile.delete();
      return newFile;
    }
  }

  Subir_Info33() async {
    final path = (await getExternalStorageDirectory())!.path;
    const uuid = Uuid();
    id = uuid.v4();
    print(2);
    print(id);
    String filename = "Document.pdf";
    SimpleS3 _simpleS3 = SimpleS3();
    String result = await _simpleS3.uploadFile(
      File('$path/$filename'),
      bucketId,
      PoolId,
      AWSRegions.usEast1,
      fileName: id,
    );
  }

  Subir_Info4() async {
    // returns url pointing to S3 file
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    print(2);
    print(documentPath);
    final resultado = await FilePicker.platform.pickFiles();
    //String filename = "/storage/emulated/0/Download/Commands2.png";
    const uuid = Uuid();
    id = uuid.v4();
    print(2);
    print(id);
    SimpleS3 _simpleS3 = SimpleS3();
    String result = await _simpleS3.uploadFile(
      File((resultado?.files.single.path).toString()),
      bucketId,
      PoolId,
      AWSRegions.usEast1,
      fileName: id + ".pdf",
    );
  }

  Future BusquedaFolio(
      String _tfPedidos, String _tfNIT, String _tfFechas) async {
    final prefs = await SharedPreferences.getInstance();
    var Sucursal2 = prefs.getInt('Sucursal');
    var token2 = prefs.getString('token');
    print("Sucursal");
    print(Sucursal2);
    var registros = <RespuestaBusquedaSimple>[];
    Map busqueda = {};

    try {
      if (_tfPedidos != "" && _tfNIT == "" && _tfFechas == "") {
        busqueda = {
          "idSucursal": Sucursal2,
          "idPedido": _tfPedidos,
          "numeroSerie": "",
          "cliente": {"nombre": "", "dpi": "", "nit": ""}
        };
      }
      if (_tfNIT != "" && _tfPedidos == "" && _tfFechas == "") {
        busqueda = {
          "idSucursal": Sucursal2,
          "idPedido": "",
          "numeroSerie": "",
          "cliente": {"nombre": "", "dpi": "", "nit": _tfNIT}
        };
      }
      if (_tfFechas != "" && _tfPedidos == "" && _tfNIT == "") {
        busqueda = {
          "idSucursal": Sucursal2,
          "idPedido": "",
          "numeroSerie": "",
          "cliente": {"nombre": "", "dpi": _tfFechas, "nit": ""}
        };
      }
      print(10);
      print(busqueda);
      final UrlBusqueda =
          'https://apis.italikaguatemala-dev.com/motocicletas/emplacados/busquedas';
      final response = await http
          .post(Uri.parse(UrlBusqueda), body: json.encode(busqueda), headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer " + await prefs.getString('token')!
      });
      print(2);
      respuestaCode = response.statusCode;
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        var registros = <RespuestaBusquedaSimple>[];
        var datos = json.decode(response.body);
        var datos2 = datos['resultado'];
        print("aqui ya paso!");
        print(datos2);
        for (datos in datos2) {
          Map<String, dynamic> param2 = {
            "folioEmplacado": datos["folioEmplacado"],
            "idSucursal": datos["idSucursal"].toString(),
            "idPedido": datos["idPedido"].toString(),
            "idEstado": datos["idEstado"].toString(),
            "nombre": datos["cliente"]["nombre"],
            "dpi": datos["cliente"]["dpi"],
            "nit": datos["cliente"]["nit"],
          };
          print(1111);
          print(param2);
          registros.add(RespuestaBusquedaSimple.fromJson(param2));
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
  }

  Future BusquedaPlacas(
      String _tfPlacas, String _tfSucursal, String _tfChasis) async {
    final prefs = await SharedPreferences.getInstance();
    var Sucursal2 = prefs.getInt('Sucursal');
    var token2 = prefs.getString('token');
    var registros = <RespuestaPlaca>[];
    Map busqueda = {};

    try {
      if (_tfPlacas != "" && _tfSucursal == "" && _tfChasis == "") {
        busqueda = {
          "idSucursal": Sucursal2,
          "folioEmplacado": "",
          "marca": "",
          "placa": _tfPlacas,
          "numeroSerie": ""
        };
      }
      if (_tfSucursal != "" && _tfPlacas == "" && _tfChasis == "") {
        busqueda = {
          "idSucursal": _tfSucursal,
          "folioEmplacado": "",
          "marca": "",
          "placa": "",
          "numeroSerie": ""
        };
      }
      if (_tfChasis != "" && _tfPlacas == "" && _tfSucursal == "") {
        busqueda = {
          "idSucursal": Sucursal2,
          "folioEmplacado": "",
          "marca": "",
          "placa": "",
          "numeroSerie": _tfChasis
        };
      }
      print(10);
      print(busqueda);
      final UrlBusqueda =
          'https://apis.italikaguatemala-dev.com/motocicletas/emplacados/entregas/busquedas';
      final response = await http
          .post(Uri.parse(UrlBusqueda), body: json.encode(busqueda), headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer " + await prefs.getString('token')!
      });
      print(2);
      respuestaCode = response.statusCode;
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        var registros = <RespuestaPlaca>[];
        var datos = json.decode(response.body);
        var datos2 = datos['resultado'];
        print("aqui ya paso!");
        print(datos2);
        for (datos in datos2) {
          Map<String, dynamic> param2 = {
            "folioEmplacado": datos["folioEmplacado"].toString(),
            "placa": datos["placa"].toString().toString(),
            "marca": datos["marca"].toString().toString(),
            "idSucursal": datos["idSucursal"],
            "nombreCliente": datos["nombreCliente"].toString(),
            "idEstado": datos["idEstado"]
          };
          if (datos["idEstado"] == 6) {
            print("respuesa modelo");
            print(param2);
            registros.add(RespuestaPlaca.fromJson(param2));
            print("Modelo lleno");
            print(registros);
          } else {
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
      respuestaCode = 400;
    }
  }

  Future CalcularTF5(String _tfPlaca, String _tfNIT, String _tfFechas,
      String _tfFechas2) async {
    var registros = <RespuestaPlaca>[];
    final prefs = await SharedPreferences.getInstance();

    var jobsListAPIUrl = "";
    try {
      if (_tfPlaca != "" && _tfNIT == "" && _tfFechas == "") {
        jobsListAPIUrl =
            'https://10.48.209.161:5002/api/EntregaPlaca/get/entregaplaca/parameter?placa=' +
                _tfPlaca;
      }
      if (_tfNIT != "" && _tfPlaca == "" && _tfFechas == "") {
        jobsListAPIUrl =
            'https://10.48.209.161:5002/api/EntregaPlaca/get/entregaplaca/parameter?sucursal=' +
                _tfNIT;
      }
      if (_tfFechas != "" && _tfPlaca == "" && _tfNIT == "") {
        jobsListAPIUrl =
            'https://10.48.209.161:5002/api/EntregaPlaca/get/entregaplaca/parameter?fecha=' +
                _tfFechas;
      }

      //final response = await http.post(Uri.parse(jobsListAPIUrl),null,"{"+JSON.stringify(UsuarioData)+"}");
      final response = await http.post(Uri.parse(jobsListAPIUrl));
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        var registros = <RespuestaPlaca>[];
        var datos = json.decode(response.body);
        for (datos in datos) {
          registros.add(RespuestaPlaca.fromJson(datos));
        }
        print(1);
        print(registros);
        List jsonResponse = json.decode(response.body);
        return registros;
      } else {
        print("Failed to load jobs from API");
      }
    } catch (e) {
      print(registros);
    }
    return registros;
  }

  GuardarComentario(String _tfComentario, String folioEmplacado) async {
    final prefs = await SharedPreferences.getInstance();
    var Empleado2 = prefs.getInt('Empleado');
    var token2 = prefs.getString('token');
    var registros = <RespuestaComentario>[];
    try {
      Map mentalmap = {
        "inventario": "Emplacados",
        "comentario": _tfComentario,
        "folioInventario": folioEmplacado,
        "usuarioCreo": Empleado2.toString()
      };
      final UrlBusqueda = 'https://apis.italikaguatemala-dev.com/comentarios';
      final response = await http
          .post(Uri.parse(UrlBusqueda), body: jsonEncode(mentalmap), headers: {
        "Content-Type": "application/json",
        "Accept": "/",
        "Authorization": "Bearer " + await prefs.getString('token')!
      });
      var datatab = json.decode(response.body);
      print("Datos mapeados");
      print(datatab);
      var prueba = datatab['resultado']['comentarios'];
      print("otra referencia");
      print(prueba);
      print(jsonEncode(mentalmap));
      print(mentalmap);
      print(response.statusCode);
      if (response.statusCode == 201) {
        print('exitoso');
      } else {
        throw Exception("Error al cargar el Api");
      }
    } catch (e) {
      print(e);
    }
  }

  DetalleBusquedaService(String folioEmplacado) async {
    final prefs = await SharedPreferences.getInstance();
    var Sucursal2 = prefs.getInt('Sucursal');
    var Empleado2 = prefs.getInt('Empleado');
    var token2 = prefs.getString('token');
    print("Sucursal");
    print(Sucursal2);
    print("Empleado");
    print(Empleado2);
    var registros = <RespuestaBusqueda>[];
    try {
      Map mentalmap = {
        "folioEmplacado": folioEmplacado,
      };
      final UrlBusqueda =
          'https://apis.italikaguatemala-dev.com/motocicletas/emplacados/detalles/busquedas';
      final response = await http
          .post(Uri.parse(UrlBusqueda), body: jsonEncode(mentalmap), headers: {
        "Content-Type": "application/json",
        "Accept": "/",
        "Authorization": "Bearer " + await prefs.getString('token')!
      });
      print("codigo respuetsa");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        var registros = <RespuestaBusqueda>[];
        var datos = json.decode(response.body);
        var datos2 = datos['resultado'];
        print("resputa resultado");
        print(datos2);

        Map<String, dynamic> res = {
          "folioEmplacado": datos2["folioEmplacado"],
          "horaFechaModificacion": datos2["horaFechaModificacion"],
          "idUsuarioModifico": datos2["idUsuarioModifico"],
          "horaFechaCreado": datos2["horaFechaCreado"],
          "idUsuarioCreo": datos2["idUsuarioCreo"],
          "idPedido": datos2["idPedido"],
          "idTipoVenta": datos2["idTipoVenta"],
          "numeroSerie": datos2["numeroSerie"],
          "idEstado": ValidarEstado(datos2["idEstado"]),
          "idSucursal": datos2["idSucursal"],
          "idTipo": datos2["cliente"]["idTipo"],
          "idDepartamento": datos2["cliente"]["idDepartamento"],
          "idMunicipio": datos2["cliente"]["idMunicipio"],
          "nombre": datos2["cliente"]["nombre"],
          "direccion": datos2["cliente"]["direccion"],
          "dpi": datos2["cliente"]["dpi"],
          "nit": datos2["cliente"]["nit"],
          "idGenero": datos2["cliente"]["idGenero"],
          "telefono": datos2["cliente"]["telefono"],
          "correo": datos2["cliente"]["correo"],
          "dpi2": datos2["revision"]["dpi"],
          "motivoDpi": datos2["revision"]["motivoDpi"],
          "factura": datos2["revision"]["factura"],
          "motivoFactura": datos2["revision"]["motivoFactura"],
          "rtu": datos2["revision"]["rtu"],
          "motivoRtu": datos2["revision"]["motivoRtu"],
          "acta": datos2["revision"]["acta"],
          "motivoActa": datos2["revision"]["motivoActa"],
          "responsabilidad": datos2["revision"]["responsabilidad"],
          "motivoResponsabilidad": datos2["revision"]["motivoResponsabilidad"],
          "docempresa": datos2["revision"]["docempresa"],
          "motivoDocEmpresa": datos2["revision"]["motivoDocEmpresa"],
        };
        print("respuesa modelo");
        print(res);
        registros.add(RespuestaBusqueda.fromJson(res));
        print("Modelo lleno");
        print(registros);
        return registros;
      } else {
        print("Failed to load jobs from API");
      }
    } catch (Error) {
      print("Error");
      print(Error);
    }
    return registros;
  }

  /*static Future Validacion(String _tfUser, String _tfPass) async {
    var registros = <RespuestaComentario>[];
    final prefs = await SharedPreferences.getInstance();
    print(123456789);
    try {
      Map mentalmap = {
        "username": _tfUser,
        "password": _tfPass
      };
      final UrlBusqueda = 'https://apis.italikaguatemala-dev.com/api/v1/User/Login';
      final response = await http.post(Uri.parse(UrlBusqueda), body: jsonEncode(mentalmap), headers: {
        "Content-Type": "application/json",
        "Accept": "/"
      });
      var datatab = json.decode(response.body);
      print(jsonEncode(mentalmap));
      print(response.statusCode);
      if (response.statusCode == 200){
        print('exitoso');
      } else {
        throw Exception("Error al cargar el Api");
      }
      return response.statusCode;
    }catch(e){
      return 400;
    }
  }*/
  static Future Validacion(String _tfUser, String _tfPass) async {
    var registros = <RespuestaLogin>[];
    final prefs = await SharedPreferences.getInstance();
    print(123456789);
    try {
      Map mentalmap = {"username": _tfUser, "password": _tfPass};
      final UrlBusqueda =
          'https://apis.italikaguatemala-dev.com/api/v1/User/Login';
      final response = await http.post(Uri.parse(UrlBusqueda),
          body: jsonEncode(mentalmap),
          headers: {"Content-Type": "application/json", "Accept": "/"});
      print("codigo respuetsa");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        var registros = <RespuestaLogin>[];
        var datos = json.decode(response.body);
        //var datos2 = datos['resultado'];
        print("resputa resultado");
        print(datos);

        Map<String, dynamic> res = {
          "token": datos["token"],
          "sucursal": datos["sucursal"],
          "noEmpleado": datos["noEmpleado"],
          "nombreCompleto": datos["nombreCompleto"],
          "totalEmplacado": datos["totalEmplacado"],
        };

        await prefs.setInt('Sucursal', datos["sucursal"]);
        await prefs.setInt('Empleado', datos["noEmpleado"]);
        await prefs.setString('token', datos["token"]);

        print("respuesa modelo");
        print(res);
        registros.add(RespuestaLogin.fromJson(res));
        print("Modelo lleno");
        print(registros);
      } else {
        print("Failed to load jobs from API");
      }
      return response.statusCode;
    } catch (Error) {
      return 400;
    }
  }

  ValidarEstado(int Estado) {
    if (Estado == 8) {
      return "Nuevos";
    } else if (Estado == 1) {
      return "Documentos Aceptados";
    } else if (Estado == 2) {
      return "Documentos Rechazados";
    } else if (Estado == 3) {
      return "En Pagos";
    } else if (Estado == 4) {
      return "Enviado a SAT";
    } else if (Estado == 5) {
      return "En Italika";
    } else if (Estado == 6) {
      return "Enviado a Sucursal";
    } else if (Estado == 7) {
      return "Entregado al Cliente";
    } else if (Estado == 0) {
      return "Pendiente de Revisar";
    }
  }
}
