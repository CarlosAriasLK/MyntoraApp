

import 'package:myntora_app/features/aprendices/domain/entities/aprendiz.dart';

abstract class AprendicesDatasources {

  Future<List<Aprendiz>> getAllAprendices( int idFicha, String token );

}