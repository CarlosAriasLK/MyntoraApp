


import 'package:myntora_app/features/juicios/domain/entities/juicio.dart';

abstract class JuiciosDatasources {

  Future<Juicio> getAprendizById( int id, String token );

}