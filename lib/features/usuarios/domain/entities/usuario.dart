


class Usuario {

  final int? id;
  final String nombre;
  final String apellido;
  final String tipoDocumento;
  final String nroDocumento;
  final String correoInstitucional;
  final String rol;
  final String tipoContrato;
  final String tipoRol;
  final String fechaInicioContrato;
  final String fechaFinContrato;
  final String telefono;

  Usuario({
    this.id, 
    required this.nombre, 
    required this.apellido,
    required this.tipoDocumento, 
    required this.nroDocumento, 
    required this.correoInstitucional, 
    required this.rol, 
    required this.tipoContrato,
    required this.tipoRol, 
    required this.fechaInicioContrato, 
    required this.fechaFinContrato, 
    required this.telefono, 
  });

}