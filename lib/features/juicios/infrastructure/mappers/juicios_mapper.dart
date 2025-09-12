


import 'package:myntora_app/features/juicios/domain/entities/juicio.dart';

class JuiciosMapper {

  static Juicio juicioToEntity(Map<String, dynamic> json) {
    final aprendiz = json['aprendiz'];

    final competencias = (json['competenciasEvaluadas'] as List).map((comp) {
      final competenciaJson = comp['competencia'];
      final resultadosJson = comp['resultados'] as List;

      return Competencia(
        id: competenciaJson['id'],
        nombre: competenciaJson['nombre'],
        codigo: competenciaJson['codigo'],
        estado: competenciaJson['estado'],
        resultados: resultadosJson.map((resultado) => Resultado(
          id: resultado['id'],
          codigo: resultado['codigo'],
          nombre: resultado['nombre'],
          estado: resultado['estado'],
          observaciones: resultado['observaciones'],
          instructor: resultado['instructor'],
        )).toList(),
      );
    }).toList();

    return Juicio(
      id: aprendiz['id'],
      idFicha: aprendiz['id_ficha'],
      nombre: aprendiz['nombre'],
      apellidos: aprendiz['apellidos'],
      tipoFocumento: aprendiz['tipo_documento'],
      nroDocumento: aprendiz['nro_documento'],
      estado: aprendiz['estado'],
      competencias: competencias,
    );
    
  }

}