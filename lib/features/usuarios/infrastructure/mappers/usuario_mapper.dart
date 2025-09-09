


import 'package:myntora_app/features/usuarios/domain/entities/usuario.dart';

class UsuarioMapper {

  static Usuario responseToEntity( Map<String, dynamic> json ) => Usuario(
    id: (json['id'] as num).toInt(), 
    nombre: json['nombre'],
    apellido: json['apellido'],
    password: json['password'],
    tipoDocumento: json['tipo_documento'],
    nroDocumento: json['nro_documento'],
    correoInstitucional: json['correo_institucional'],
    rol: json['rol'],
    tipoRol: json['tipo_rol'],
    fechaInicioContrato: DateTime.parse(json['fecha_inicio_contrato']), 
    fechaFinContrato: DateTime.parse(json['fecha_fin_contrato']),
    telefono: json['telefono'],
  );

}