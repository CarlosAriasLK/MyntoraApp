


import 'package:myntora_app/features/fichas/domain/domain.dart';

class FichaMapper {

  static jsonToEntity( Map<String, dynamic> json ) => Ficha(
    id: json['id'] ?? '',
    idProgramaFormacion: json['id_programa_formacion'],
    jornada: json['jornada'],
    fechaInicio: DateTime.parse(json['fecha_inicio']),
    fechaFin: DateTime.parse(json['fecha_fin']),
    modalidad: json['modalidad'],
    etapa: json['etapa'],
    jefeFicha: json['jefe_ficha'],
    oferta: json['oferta']
  );

}