import 'dart:io';
import 'package:app_itk4/Screens/Indicadores.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Screens/Comments.dart';
import 'Menu.dart';
import 'Services/userService.dart';

void main() {
  //requestStoragePermission();
  //requestCameraPermission();
  //requestStoragePermission2();
  //requestStoragePermission4();
  //requestStoragePermission5();
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 11, 83, 216),
          secondary: const Color.fromARGB(255, 11, 83, 216),
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isHidden = true;
  final _tfUser = TextEditingController();
  final _tfPass = TextEditingController();
  final _service = UserService();

  @override
  Widget build(BuildContext context) {
    _showSuccesSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width * 0.82,
                height: height * 0.45,
                child: Image.asset(
                  'assets/italika-logo2.png',
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Inicio de Sesión',
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 60.0,
              ),
              TextFormField(
                controller: _tfUser,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    suffixIcon: Icon(Icons.account_box_rounded),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Usuario",
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 15.0)),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                obscureText: _isHidden,
                controller: _tfPass,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isHidden ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black45,
                      ),
                      onPressed: () {
                        setState(() {
                          _isHidden = !_isHidden;
                        });
                      },
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Contraseña",
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 15.0)),
              ),
              /*TextField(
                controller: _tfNota1,
                keyboardType:
                TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Ingresa tu plantilla de Activos:",
                  hintText: "Example: 100",
                  errorText: _tfNota1.text.toString() == ""
                      ? "falta ingresar un valor"
                      : null,
                )),*/
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text(
                        '   Iniciar Sesión   ',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                          //padding: EdgeInsets.all(15.0),
                          ),
                      onPressed: () async {
                        var result = await UserService.Validacion(
                                _tfUser.text, _tfPass.text)
                            .then((response) {
                          if (response == 200) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Indicadores()));
                          } else {
                            switch (response) {
                              case 400:
                                _showSuccesSnackBar(
                                    "Error, Usuario o Contraseña incorrecto");
                                break;
                              case 401:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyApp()),
                                );
                                break;
                              case 404:
                                _showSuccesSnackBar(
                                    "Usuario y Contraseña Incorrectos");
                                break;
                              case 500:
                                _showSuccesSnackBar(
                                    "No se completo la petición intente mas tarde.");
                                break;
                            }
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                "Terminos y Condiciones \n        versión: 1.1.0+10",
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> requestStoragePermission5() async {
  final status = await Permission.photos.request();
  if (status != PermissionStatus.granted) {
    print('Permiso de almacenamiento no otorgado');
  } else {
    print('Permiso de almacenamiento otorgado');
  }
}

Future<void> requestStoragePermission4() async {
  final status = await Permission.notification;
  if (status != PermissionStatus.granted) {
    print('Permiso de almacenamiento no otorgado');
  } else {
    print('Permiso de almacenamiento otorgado');
  }
}

Future<void> requestStoragePermission2() async {
  final status = await Permission.mediaLibrary.request();
  if (status != PermissionStatus.granted) {
    print('Permiso de almacenamiento no otorgado');
  } else {
    print('Permiso de almacenamiento otorgado');
  }
}

Future<void> requestStoragePermission() async {
  final status = await Permission.storage.request();
  if (status != PermissionStatus.granted) {
    print('Permiso de almacenamiento no otorgado');
  } else {
    print('Permiso de almacenamiento otorgado');
  }
}

Future<void> requestCameraPermission() async {
  final status = await Permission.camera.request();
  if (status != PermissionStatus.granted) {
    print('Permiso de cámara no otorgado');
  } else {
    print('Permiso de cámara otorgado');
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
