

import 'package:myntora_app/features/juicios/domain/entities/juicio.dart';

abstract class JuiciosRepositories {

  Future<Juicio> getAprendizById( int id, String token );

}