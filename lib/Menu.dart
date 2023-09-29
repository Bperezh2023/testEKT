import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'Services/userService.dart';
import 'Screens/Indicadores.dart';
import 'model/User.dart';
import 'model/modelApi.dart';
import 'Screens/Imageness.dart';
import 'Screens/JobsListView.dart';
import 'Screens/addUser.dart';
import 'Screens/busqueda.dart';
import 'Screens/navigatorBar.dart';
import 'package:permission_handler/permission_handler.dart';

class Menu extends StatefulWidget {
  final int selector;
  Menu(this.selector, {Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String assetPDFPath = "";
  String urlPDFPath = "";
  List<User>? _userList;
  final _userService = UserService();
  bool flatbutton = true;
  var notification;
  List<RespuestaApi> resApi = <RespuestaApi>[];

  _showSuccesSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //requestStoragePermission();
    //requestCameraPermission();
    //requestStoragePermission2();
    //requestStoragePermission4();
    //requestStoragePermission5();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Detalle de Emplacados"),
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: Center(
          child: JobsListView(widget.selector),
        ),
      ),
    );
  }

  /*Widget cuerpo() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                "https://upload.wikimedia.org/wikipedia/commons/f/f2/Italika-logo.png"),
            fit: BoxFit.cover),
      ),
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[pruebamonet(), buildCombineWidget()],
          )),
    );
  }*/

  Widget pruebamonet() {
    print("aqui viene el selector");
    print(widget.selector);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Center(
        child: JobsListView(widget.selector),
      )),
    );
  }

  Widget Nombre() {
    return Text("Sign In");
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
