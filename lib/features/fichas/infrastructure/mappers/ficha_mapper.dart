


import 'package:myntora_app/features/fichas/domain/domain.dart';

class FichaMapper {

  static jsonToEntity( Map<String, dynamic> json ) => Ficha(
    id: json['id'] ?? '',
    id_programa_formacion: json['id_programa_formacion'],
    jornada: json['jornada'],
    fecha_inicio: DateTime.parse(json['fecha_inicio']),
    fecha_fin: DateTime.parse(json['fecha_fin']),
    modalidad: json['modalidad'],
    etapa: json['etapa'],
    jefe_ficha: json['jefe_ficha'],
    oferta: json['oferta']
  );

}