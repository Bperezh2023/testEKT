import 'package:flutter/material.dart';

class RespuestaApiDownload {
  int id = 0;
  String name = ""; //api int
  String attached_to_doctype = "";
  String attached_to_field = "";
  String attached_to_name = "";
  String content_hash = "";
  String creation = "";
  int docstatus = 0;
  String file_name = "";
  int file_size = 0; //api int
  String file_url = "";
  String folder = ""; //api int
  int is_private = 0;
  String modified = "";
  String modified_by = "";
  String owner = "";
  int folio = 0;
  String uuid = "";

  RespuestaApiDownload(this.id, this.name, this.attached_to_doctype,
      this.attached_to_field,
      this.attached_to_name, this.content_hash, this.creation, this.docstatus,
      this.file_name, this.file_size, this.file_url, this.folder,
      this.is_private,
      this.modified, this.modified_by, this.owner, this.folio, this.uuid);

  RespuestaApiDownload.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    attached_to_doctype = json['attached_to_doctype'];
    attached_to_field = json['attached_to_field'];
    attached_to_name = json['attached_to_name'];
    content_hash = json['content_hash'];
    creation = json['creation'];
    docstatus = json['docstatus'];
    file_name = json['file_name'];
    file_size = json['file_size'];
    file_url = json['file_url'];
    folder = json['folder'];
    is_private = json['is_private'];
    modified = json['modified'];
    modified_by = json['modified_by'];
    owner = json['owner'];
    folio = json['folio'];
    uuid = json['uuid'];
  }
}