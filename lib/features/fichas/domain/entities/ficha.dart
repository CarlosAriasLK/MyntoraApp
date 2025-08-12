

class Ficha {

  final int id;
  final int id_programa_formacion;
  final String jornada;
  final DateTime fecha_inicio;
  final DateTime fecha_fin;
  final String modalidad;
  final String etapa;
  final String jefe_ficha;
  final String oferta;

  Ficha({
    required this.id,
    required this.id_programa_formacion,
    required this.jornada,
    required this.fecha_inicio,
    required this.fecha_fin,
    required this.modalidad,
    required this.etapa,
    required this.jefe_ficha,
    required this.oferta,
  });

}