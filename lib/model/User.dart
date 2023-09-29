class User
{
  int? id;
  String? Nombre;
  String? DPI;
  String? Cliente;

  userMap(){
    var mapping=Map<String, dynamic>();
    mapping['id']=id??null;
    mapping['Nombre']=Nombre!;
    mapping['DPI']=DPI!;
    mapping['Cliente']=Cliente!;
    return mapping;
  }

}