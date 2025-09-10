
import 'package:myntora_app/features/juicios/domain/entities/aprendiz.dart';

abstract class AprendicesRepositories {

  Future<List<Aprendiz>> getAllAprendices( int idFicha, String token );

  Future<Aprendiz> getAprendizById( int id, String token );

}