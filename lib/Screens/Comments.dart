import 'dart:convert';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:app_itk4/main.dart';
import 'package:flutter_timeline/defaults.dart';
import 'package:flutter_timeline/event_item.dart';
import 'package:flutter_timeline/indicator_position.dart';
import 'package:flutter_timeline/timeline.dart';
import 'package:flutter_timeline/timeline_theme.dart';
import 'package:flutter_timeline/timeline_theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/modelComentario.dart';

class TimelineDemoApp extends StatelessWidget {
  final String folioEmplacado;
  TimelineDemoApp({Key? key, required this.folioEmplacado}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Timeline',
      debugShowCheckedModeBanner: false,
      home: PlainTimelineDemoScreen(
        folioEmplacado: folioEmplacado,
      ),
    );
  }
}

class PlainTimelineDemoScreen extends StatefulWidget {
  final String folioEmplacado;
  PlainTimelineDemoScreen({Key? key, required this.folioEmplacado})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _PlainTimelineDemoScreenState();
}

class _PlainTimelineDemoScreenState extends State<PlainTimelineDemoScreen> {
  List<EventData> eventsData = <EventData>[];
  List<TimelineEventDisplay> events = <TimelineEventDisplay>[];
  List<RespuestaComentario> data = <RespuestaComentario>[];
  List<RespuestaComentario> registross = <RespuestaComentario>[];
  static int folio2 = 0;
  var prueba;
  bool VerLineTime = false;
  static String comentario = "";
  static String fechas = "";

  @override
  void initState() {
    //ComentariosApi();
    print(25);
    print(widget.folioEmplacado.toString());
    print(452);
    print(registross);
    print(256);
    //tomarDatos();
    _addEvent();
    super.initState();
    initializeDateFormatting("fr_FR", null);
  }

  String Data1 = "";
  String Data2 = "";
  String Data3 = "";

  save_timeline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //serialize event data to json
    var json = jsonEncode(eventsData);
    await prefs.setString('timeline', json);
  }

  load_timeline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = prefs.getString('timeline');
    if (json == null) {
      //no data available
      eventsData = [];
    } else {
      //deserialize event data from json
      var items = jsonDecode(json) as List;
      eventsData = items.map((i) => EventData.fromJson(i)).toList();
    }
    //render event data
    events = eventsData.map(plainEventDisplay).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Comentarios',
        ),
      ),
      body:
      Visibility(
        visible: VerLineTime,
        child: FutureBuilder(
        future: load_timeline(),
        builder: (context, snapshot) {
          return _buildTimeline();
        },
        ),
      ),

      /*floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: Icon(Icons.add),
      )*/
    );
  }

  TimelineEventDisplay plainEventDisplay(EventData eventData) {

    var formattedTime = "${eventData.data1}";
    return TimelineEventDisplay(
      anchor: IndicatorPosition.top,
      indicatorOffset: Offset(0, 0),
      child: TimelineEventCard(
          title: Text("${formattedTime}"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Fecha : ${eventData.data2}"),
              //Text("fecha : ${eventData.data2}"),
            ],
          )),
      indicator: TimelineDots.of(context).circleIcon,
    );

  }

  Widget _buildTimeline() {
    return TimelineTheme(
        data: TimelineThemeData(
            lineColor: Colors.blueAccent, itemGap: 5, lineGap: 0),
        child: Timeline(
          anchor: IndicatorPosition.center,
          indicatorSize: 56,
          altOffset: Offset(10, 10),
          events: events,
        ));
  }

  void _addEvent() async {
    final prefs = await SharedPreferences.getInstance();
    _showSuccesSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
    eventsData.clear();
    var registros = <RespuestaComentario>[];
    try {
      print("folioc omentario");
      print(widget.folioEmplacado);
      Map mentalmap = {
        "inventario": "emplacados",
        "folioInventario": widget.folioEmplacado
      };
      final UrlBusqueda =
          'https://apis.italikaguatemala-dev.com/comentarios/busquedas';
      final response = await http.post(Uri.parse(UrlBusqueda),
          body: jsonEncode(mentalmap),
          headers: {"Content-Type": "application/json",
            "Accept": "/",
            "Authorization": "Bearer " + await prefs.getString('token')!
      });
      print("response comentario");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        var datos = json.decode(response.body);
        var datos2 = datos['resultado']["comentarios"];
        print("aqui ya paso!");
        print(datos2);
        for (datos in datos2) {
          Map<String, dynamic> respuestaComentario = {
            "id": datos["id"],
            "descripcion": datos["descripcion"].toString(),
            "usuarioCreo": datos["usuarioCreo"].toString(),
            "fechaHoraCreado": datos["fechaHoraCreado"].toString(),
          };
          print(1111);
          print(respuestaComentario);
          registros.add(RespuestaComentario.fromJson(respuestaComentario));
        }
        print("modelo2");
        print(registros.length);
      } else {
        print("Failed to load jobs from API");
      }

      if(response.statusCode == 200){
        setState(() {
          VerLineTime = true;
        });
        print(123);
        print("registros.length");
        print(registros.length);

        eventsData.clear();
        registros.sort((a, b) => a.fechaHoraCreado.compareTo(DateTime.now().toString()));
        for (int a = 0; a < registros.length; a++) {
          //for(data in data){
          //widget.folio.toString()
          Data1 = registros[a].descripcion.toString();
          Data2 = registros[a].fechaHoraCreado;
          var eventData = EventData(DateTime.now(), Data1, Data2);
          eventsData.add(eventData);
          save_timeline();
          //trigger refresh
          setState(() {

          });
        }
        print("paso for");
      }else{
        setState(() {
          VerLineTime = false;
        });
      }

    } catch (e) {
      print(e);
    }
  }
}

class EventData {
  final DateTime dateTime;
  final String data1;
  final String data2;

  EventData(this.dateTime, this.data1, this.data2);

  EventData.fromJson(Map<String, dynamic> json)
      : dateTime = DateTime.parse(json['dateTime']),
        data1 = json['data1'],
        data2 = json['data2'];

  Map<String, dynamic> toJson() => {
        'dateTime': dateTime.toIso8601String(),
        'data1': data1,
        'data2': data2,
      };
}
