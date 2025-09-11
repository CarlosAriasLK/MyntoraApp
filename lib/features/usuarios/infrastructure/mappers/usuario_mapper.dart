


import 'package:myntora_app/features/usuarios/domain/entities/usuario.dart';

class UsuarioMapper {

  static Usuario responseToEntity( Map<String, dynamic> json ) => Usuario(
    id: json['id'] != null ? (json['id'] as num).toInt() : null, 
    nombre: json['nombre'] ?? '',
    apellido: json['apellido'] ?? '',
    tipoDocumento: json['tipo_documento'] ?? '',
    nroDocumento: json['nro_documento'] ?? '',
    correoInstitucional: json['correo_institucional'] ?? '',
    rol: json['rol'] ?? '',
    tipoContrato: json['tipo_contrato'] ?? '',
    tipoRol: json['tipo_rol'] ?? '',
    fechaInicioContrato: json['fecha_inicio_contrato'] ?? '', 
    fechaFinContrato: json['fecha_fin_contrato'] ?? '',
    telefono: json['telefono'] ?? '', 
  );

}