


import 'package:myntora_app/features/programas/domain/domain.dart';

class ProgramasMapper {

  static jsonListToEntity( List<dynamic> json ) {
    return json.map( ( json ) => Programa(
        id: json['id'],
        nombre: json['nombre_programa'],
        nivel: json['nivel'],
        estado: json['estado'],
    )).toList();
  }

}