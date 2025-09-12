
import 'package:myntora_app/features/aprendices/domain/entities/aprendiz.dart';

class AprendizMapper {


  static Aprendiz toEntity( Map<String, dynamic> json ) => Aprendiz(
    id: (json['id'] as num).toInt(), 
    idFicha: (json['id_ficha'] as num).toInt(), 
    nombre: json['nombre'], 
    apellidos: json['apellidos'], 
    tipoFocumento: json['tipo_documento'], 
    nroDocumento: json['nro_documento'], 
    estado: json['estado'], 
  );


}