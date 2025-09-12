


class Juicio {

  final int id;
  final int idFicha;
  final String nombre;
  final String apellidos;
  final String tipoFocumento;
  final String nroDocumento;
  final String estado;
  final List<Competencia> competencias;

  Juicio({
    required this.id, 
    required this.idFicha, 
    required this.nombre, 
    required this.apellidos, 
    required this.tipoFocumento, 
    required this.nroDocumento, 
    required this.estado, 
    required this.competencias, 
  });

}


class Competencia {

  final int id;
  final String nombre;
  final int codigo;
  final String estado;
  final List<Resultado> resultados;

  Competencia({
    required this.id, 
    required this.nombre, 
    required this.codigo, 
    required this.estado,
    required this.resultados,
  });
}

class Resultado {
  
  final int id;
  final int codigo;
  final String nombre;
  final String estado;
  final String observaciones;
  final String instructor;

  Resultado({
    required this.id, 
    required this.codigo, 
    required this.nombre, 
    required this.estado, 
    required this.observaciones, 
    required this.instructor
  });

}