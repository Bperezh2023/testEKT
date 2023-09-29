import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../Pages/EntregaPlaca.dart';
import '../Pages/busquedaPlaca.dart';
import '../Pages/placaPorEntregar.dart';
import '../model/EntregaPlacaModel.dart';
import 'busqueda2.dart';

class PlacaPrincipal extends StatefulWidget {
  const PlacaPrincipal({Key? key}) : super(key: key);

  @override
  State<PlacaPrincipal> createState() => _PlacaPrincipalState();
}

class _PlacaPrincipalState extends State<PlacaPrincipal> {
  List<RespuestaPlaca> listaPlaca = <RespuestaPlaca>[];
  int index = 0;
  final screens = [
    BusquedaPlaca(),
    EntregaPlaca(),
    PlacaPorEntregar()
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.blue.shade200,
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        child: NavigationBar(
          height: 80,
          backgroundColor: Color.fromARGB(255, 0, 66, 213),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: index,
          //animationDuration: Duration(seconds: 0),
          onDestinationSelected: (index) =>
            setState(() => this.index = index),

          destinations: [
            NavigationDestination(icon: Icon(Icons.search,color: Colors.white),selectedIcon: Icon(Icons.search, color: Colors.white,) ,label: 'Buscar'),
            NavigationDestination(icon: Icon(Icons.access_time,color: Colors.white),selectedIcon: Icon(Icons.access_time, color: Colors.white,) , label: 'Por Entregar'),
            NavigationDestination(icon: Icon(Icons.check,color: Colors.white),selectedIcon: Icon(Icons.check, color: Colors.white,), label: 'Entregadas'),
          ],
        ),

      ),
    );
  }
}
