


class Usuario {

  final int id;
  final String nombre;
  final String apellido;
  final String password;
  final String tipoDocumento;
  final String nroDocumento;
  final String correoInstitucional;
  final String rol;
  final String tipoRol;
  final DateTime fechaInicioContrato;
  final DateTime fechaFinContrato;
  final String telefono;

  Usuario({
    required this.id, 
    required this.nombre, 
    required this.apellido, 
    required this.password, 
    required this.tipoDocumento, 
    required this.nroDocumento, 
    required this.correoInstitucional, 
    required this.rol, 
    required this.tipoRol, 
    required this.fechaInicioContrato, 
    required this.fechaFinContrato, 
    required this.telefono, 
  });

}