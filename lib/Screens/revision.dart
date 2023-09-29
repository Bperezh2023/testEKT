import 'package:flutter/material.dart';
import 'package:app_itk4/main.dart';

import '../Services/userService.dart';
import '../model/ModelBusqueda.dart';
import '../model/modelRevision.dart';

class Revision extends StatefulWidget {
  final RespuestaBusqueda items;
  const Revision(this.items, {Key? key}) : super(key: key);

  @override
  State<Revision> createState() => _RevisionState();
}

class _RevisionState extends State<Revision> {

  final _service = UserService();
  bool control = false;
  bool EmplacadoNuevo = true;
  List<RespuestaBusqueda> Lista3 = <RespuestaBusqueda>[];
  List<RespuestaRevision> Lista4 = <RespuestaRevision>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      Lista4.clear();

    Lista4.add(RespuestaRevision("DPI/Hoja de Reposición",(widget.items.dpi2 == false ? "Rechazado": "Aceptado"),(widget.items.motivoDpi == null ? "":widget.items.motivoDpi!), widget.items.dpi2));
    Lista4.add(RespuestaRevision("Factura",(widget.items.factura== false ? "Rechazado": "Aceptado"),(widget.items.motivoFactura== null ? "":widget.items.motivoFactura!), widget.items.factura));
    Lista4.add(RespuestaRevision("RTU",(widget.items.rtu== false ? "Rechazado": "Aceptado"),(widget.items.motivoRtu== null ? "":widget.items.motivoRtu!), widget.items.rtu));
    Lista4.add(RespuestaRevision("Acta de Entrega",(widget.items.acta== false ? "Rechazado": "Aceptado"),(widget.items.motivoActa== null ? "":widget.items.motivoActa!), widget.items.acta));
    Lista4.add(RespuestaRevision("Carta de Responsabilidad",(widget.items.responsabilidad== false ? "Rechazado": "Aceptado"),(widget.items.motivoResponsabilidad== null ? "":widget.items.motivoResponsabilidad!), widget.items.responsabilidad));
    print(widget.items.idTipo);
    if(widget.items.idTipo == 2){
      Lista4.add(RespuestaRevision("Nombramiento(Reg/Mer)",(widget.items.docempresa== false ? "Rechazado": "Aceptado"),(widget.items.motivoDocEmpresa== null ? "":widget.items.motivoDocEmpresa!), widget.items.docempresa));
    }
    EmplacadoNuevo = widget.items.motivoDpi == "Sin revisar" ? false : true;
    });
    print("revision");
    print(Lista4);
    print(Lista4[0].change);

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
          'Revisión',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
          child: Column(
            children: [
            const Text(
            '   Datos de Revisión',
            style: TextStyle(
                fontSize: 25,
                color: Colors.blueGrey,
                fontWeight: FontWeight.w500),
            ),
            const SizedBox(
            height: 50.0,
            ),
              Visibility(
                  visible: true,
                  child: Lista4.isNotEmpty
                      ? Expanded(
                    child: ListView.builder(
                      itemCount: Lista4.length,
                      itemBuilder: (_,int index) {
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            //leading: Text(Lista4[index].estado),
                            title: Text(Lista4[index].nombreDocumento.toString()),
                            subtitle: Text(Lista4[index].motivoRechazo),
                            trailing:SizedBox(
                               height: 50,
                               width: 50,
                              child:
                            Wrap(
                              spacing: 12, // space between two icons
                              children: <Widget>[
                                Visibility(
                                    visible: EmplacadoNuevo,
                                    child: Row(
                                      children: [
                                        Visibility(visible: Lista4[index].change, child: Icon(Icons.check, color: Colors.green,)),
                                        // icon-1
                                        Visibility(visible: !Lista4[index].change, child: Icon(Icons.cancel_outlined, color: Colors.red,)),
                                      ],
                                    )
                                )                                // icon-2
                              ],
                            ),
                            ),
                            onTap: () async {

                            },
                          ),
                        );
                      },
                    ),
                  )
                      : Container())
            ],
          ),
      ),
    );
  }
}
