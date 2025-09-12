
import 'package:myntora_app/features/aprendices/domain/entities/aprendiz.dart';

abstract class AprendicesRepositories {

  Future<List<Aprendiz>> getAllAprendices( int idFicha, String token );


}